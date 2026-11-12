#!/bin/sh
# Writes a Caddyfile from the environment and starts Caddy.
#   BASIC_AUTH_USERNAME  login name for the Spacebot UI
#   BASIC_AUTH_PASSWORD  its password (bcrypt: at most 72 bytes)
#   SPACEBOT_UPSTREAM    private host:port of the Spacebot service
#   PORT                 port Caddy listens on (default 8080)
set -eu

: "${BASIC_AUTH_USERNAME:?BASIC_AUTH_USERNAME is not set}"
: "${BASIC_AUTH_PASSWORD:?BASIC_AUTH_PASSWORD is not set}"
: "${SPACEBOT_UPSTREAM:?SPACEBOT_UPSTREAM is not set}"
PORT="${PORT:-8080}"

if [ "$(printf %s "$BASIC_AUTH_PASSWORD" | wc -c)" -gt 72 ]; then
  echo "BASIC_AUTH_PASSWORD is longer than 72 bytes, which bcrypt can't hash. Use a shorter one." >&2
  exit 1
fi

hash="$(caddy hash-password --plaintext "$BASIC_AUTH_PASSWORD")"

cat > /etc/caddy/Caddyfile <<CADDY
{
	admin off
	auto_https off
}

:${PORT} {
	handle /healthz {
		respond "ok" 200
	}
	handle {
		basic_auth {
			${BASIC_AUTH_USERNAME} ${hash}
		}
		reverse_proxy ${SPACEBOT_UPSTREAM}
	}
}
CADDY

caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

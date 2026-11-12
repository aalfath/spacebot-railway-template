[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/6sOnTR?utm_medium=integration&utm_source=button&utm_campaign=spacebot)

# Spacebot on Railway

This repo is the source of the Spacebot template on Railway. It deploys
[Spacebot](https://github.com/spacedriveapp/spacebot) **v0.5.0**, an open-source,
self-hosted AI agent platform, behind a small Caddy proxy that adds a login.

## What it deploys

| Service | Folder | Builds from | Public | Storage |
|---|---|---|---|---|
| `spacebot` | [`spacebot/`](spacebot) | `ghcr.io/spacedriveapp/spacebot:v0.5.0` (pinned by digest) | no, private network only | volume at `/data` |
| `caddy` | [`caddy/`](caddy) | `caddy:2.11.9-alpine` (pinned by digest) and [`start.sh`](caddy/start.sh) | yes, port 8080 | none |

Spacebot's web UI and API have no login of their own, so only Caddy gets a
public domain. Caddy asks for HTTP Basic Auth on every route except `/healthz`,
which Railway's health check uses, and passes everything else to Spacebot over
Railway's private network.

Each folder has its own `Dockerfile` and `railway.json` (build settings, health
check, restart policy).

## Variables

**`caddy`**

| Variable | Default | Notes |
|---|---|---|
| `BASIC_AUTH_USERNAME` | `admin` | Login name for the Spacebot UI |
| `BASIC_AUTH_PASSWORD` | `${{secret(48, "abcdef0123456789")}}` | Generated login password. bcrypt accepts at most 72 bytes, so keep it short |
| `SPACEBOT_UPSTREAM` | `${{spacebot.RAILWAY_PRIVATE_DOMAIN}}:19898` | Private address of the Spacebot service |
| `PORT` | `8080` | Port Caddy listens on |

**`spacebot`** (all optional except `PORT`)

| Variable | Notes |
|---|---|
| `PORT` | `19898`, the port Spacebot listens on |
| `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `OPENROUTER_API_KEY` | LLM provider keys. Add at least one, here or later in the Spacebot UI |
| `BRAVE_SEARCH_API_KEY` | Enables web search |
| `DISCORD_BOT_TOKEN`, `TELEGRAM_BOT_TOKEN` | Connect Discord or Telegram on first start |

On first start, Spacebot's entrypoint writes `/data/config.toml` from these
variables. Provider keys stay linked to the variables, so you can change them
later and redeploy. Channels (Discord, Telegram, Slack and others) that you add
after the first start are set up in the Spacebot UI, not through variables.

Your password: open the `caddy` service in Railway, then **Variables** →
`BASIC_AUTH_PASSWORD`.

## Updates

The template builds from the `main` branch of this repo. When a new Spacebot
release is tested, the pinned image changes here in a pull request with a
[`CHANGELOG.md`](CHANGELOG.md) entry. After it's merged, Railway shows an
"update available" notice on projects deployed from the template, and you
choose when to apply it. Read the changelog first: breaking changes are listed
at the top of each entry. Your `/data` volume is kept across updates.

## License

The files in this repo are MIT licensed. Spacebot and Caddy keep their own
licenses.

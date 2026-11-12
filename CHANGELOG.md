# Changelog

Each entry is one template version. Breaking changes come first.

## 2026-11-12: Spacebot v0.5.0

First version of the repo-based template.

- Spacebot `ghcr.io/spacedriveapp/spacebot:v0.5.0@sha256:ccd9411f72def62b192e44aed23446b94e6e4774d55d7100a94de1531029f6ed`.
- Caddy `caddy:2.11.9-alpine@sha256:0bbb055bda6793c999bde78b1b5ce3e89f829fb031af2cf50056ea1246559fee` with HTTP Basic Auth in front of Spacebot.
- `BASIC_AUTH_PASSWORD` is generated with 48 characters. bcrypt rejects passwords longer than 72 bytes, so the older template's 128-character password crashed Caddy.
- `PORT` is set on both services (Spacebot 19898, Caddy 8080), so Railway's health check probes the right port.
- Compared with the older image-based Spacebot template: `SLACK_*` and `SPACEBOT_*_MODEL` variables are gone, because Spacebot's Docker entrypoint always writes a config file and those variables then have no effect. `TELEGRAM_BOT_TOKEN` is new.

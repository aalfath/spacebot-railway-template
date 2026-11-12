# Caddy 2.11.9 (official image, pinned by digest) in front of Spacebot:
# HTTP Basic Auth on every route except /healthz.
FROM caddy:2.11.9-alpine@sha256:0bbb055bda6793c999bde78b1b5ce3e89f829fb031af2cf50056ea1246559fee

COPY start.sh /usr/local/bin/spacebot-proxy-start
RUN chmod 0755 /usr/local/bin/spacebot-proxy-start

EXPOSE 8080
CMD ["/usr/local/bin/spacebot-proxy-start"]

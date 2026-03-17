#!/bin/sh
set -eu

mkdir -p /tmp/caddy /data/caddy /config/caddy

"$@" &
openclaw_pid=$!

/usr/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
caddy_pid=$!

term_handler() {
  kill -TERM "$openclaw_pid" "$caddy_pid" 2>/dev/null || true
}

trap term_handler INT TERM HUP

wait -n
exit_code=$?

term_handler

wait "$openclaw_pid" 2>/dev/null || true
wait "$caddy_pid" 2>/dev/null || true

exit $exit_code
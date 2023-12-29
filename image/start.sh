#!/bin/ash
trap 'kill -TERM $PID' TERM INT
echo "Starting Tailscale daemon"
tailscaled --tun=userspace-networking --statedir="${TS_STATEDIR}" ${TS_OPT} &
PID=$!
until tailscale up --authkey="${TS_AUTHKEY}" --hostname="${TS_HOSTNAME}"; do
  sleep 0.1
done
tailscale status
if [ -n "${TS_SERVE_PORT}" ]; then
  if [ -n "${TS_FUNNEL}" ]; then
    if ! tailscale funnel status | grep -q -A1 '(Funnel on)' | grep -q "${TS_SERVE_PORT}"; then
      tailscale funnel --bg "${TS_SERVE_PORT}"
    fi
  else
    if ! tailscale serve status | grep -q "${TS_SERVE_PORT}"; then
      tailscale serve --bg "${TS_SERVE_PORT}"
    fi
  fi
fi
wait ${PID}

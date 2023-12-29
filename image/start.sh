#!/bin/ash
trap 'kill -TERM $PID' TERM INT
echo "Starting Tailscale daemon"
tailscaled --tun=userspace-networking --state=${TS_STATE} ${TS_OPT} &
PID=$!
until tailscale up --authkey="${TS_AUTHKEY}" --hostname="${TS_HOSTNAME}"; do
  sleep 0.1
done
tailscale status
if [ -n "${TS_SERVE_PORT}" ]; then
  if ! tailscale serve status | grep -q "${TS_SERVE_PORT}"; then
    tailscale serve --bg "${TS_SERVE_PORT}"
  fi
fi
wait ${PID}

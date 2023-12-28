#!/bin/ash
trap 'kill -TERM $PID' TERM INT
echo "Starting Tailscale daemon"
# -state=mem: will logout and remove ephemeral node from network immediately after ending.
tailscaled --tun=userspace-networking --state=${TS_STATE_ARG} ${TS_OPT} &
PID=$!
until tailscale up --authkey="${TS_AUTH_KEY}" --hostname="${TS_HOSTNAME}"; do
  sleep 0.1
done
tailscale status
wait ${PID}
wait ${PID}

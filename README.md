# Tailscale in Docker with Serve/Funnel Support

This modification of the [official Tailscale Docker image](https://github.com/tailscale/tailscale/pkgs/container/tailscale) makes it easy to [Serve](https://tailscale.com/kb/1312/serve)/[Funnel](https://tailscale.com/kb/1223/funnel) another container without needing interactive configuration.

## Prereqs
- A [pre-authentication key](https://tailscale.com/kb/1085/auth-keys) so the Tailscale container can log in to your tailnet.
- [Tailscale Serve setup](https://tailscale.com/kb/1312/serve#setup)
- [Tailscale Funnel setup](https://tailscale.com/kb/1223/funnel#setup)
- [Tailscale Funnel ACL](https://tailscale.com/kb/1223/funnel#tailnet-policy-file-requirement)

> If you're planning to use Funnel, you may want to build the ACL around a tag (such as `tag:funnel`) and automatically apply that tag when you generate the pre-auth key.

## docker-compose

See [docker-compose.yml](/docker-compose-example/docker-compose.yml) for an example Compose config.

Expected environment variables:
| Variable Name | Example | Description |
| --- | --- | --- |
| `TS_AUTHKEY` | `tskey-auth-somestring-somelongerstring` | used for unattened auth of the new node, get one [here](https://login.tailscale.com/admin/settings/keys) |
| `TS_HOSTNAME` | `my-app` | optional Tailscale hostname for the new node |
| `TS_STATEDIR` | `/var/lib/tailscale/` | required directory for storing Tailscale state, this should be mounted to the container for persistence |
| `TS_OPT` | `--verbose=1` | optional additional [flags](https://tailscale.com/kb/1278/tailscaled#flags-to-tailscaled) for `tailscaled` |
| `TS_SERVE_PORT` | `8080` | optional application port to expose with [Tailscale Serve](https://tailscale.com/kb/1312/serve) |
| `TS_FUNNEL` | `1` | if set (to anything), will proxy `TS_SERVE_PORT` **publicly** with [Tailscale Funnel](https://tailscale.com/kb/1223/funnel) |

You can drop these in a `.env` file alongside your `docker-compose.yml` to load them automatically - see [.env_template](/docker-compose-example/env_template) for an example.

### Usage
- Copy the `image/` directory next to your `docker-compose.yml`.
- Start with rebuild if necessary:
`docker compose up -d --build`
- Tail logs:
`docker compose logs --follow`
- Access tailscale container for troubleshooting:
`docker exec -i -t tailscale ash`
- Stop:
`docker compose down`

## Credits
Based on Louis-Philippe Asselin's [tailscale-docker](https://github.com/lpasselin/tailscale-docker).
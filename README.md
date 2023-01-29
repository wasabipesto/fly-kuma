## Introduction

This Dockerfile runs on Fly.io's free tier and connects over Tailscale to monitor your services with Uptime Kuma.

## Getting Started

Before you start, grab a reusable, ephemeral authkey from [here](https://login.tailscale.com/admin/settings/keys).

Run the install script:

```shell
curl -L https://fly.io/install.sh | sh
export FLYCTL_INSTALL="/home/[username]/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

flyctl auth signup
```

Grab the files:

```shell
cd /opt
git clone git@github.com:wasabipesto/fly-kuma.git
cd fly-kuma
chmod +x start.sh
```

Set up the project:

```shell
fly create
flyctl secrets set TAILSCALE_AUTHKEY="tskey-auth-asdf..."
flyctl volumes create kuma
fly deploy
```

Add the CNAME record from `status.example.com` to `fly-kuma.fly.dev`, then create a certificate:

```shell
flyctl certs create status.example.com
flyctl certs show status.example.com
```

## References

- https://fly.io/docs/hands-on/
- https://tailscale.com/kb/1132/flydotio/
- https://github.com/louislam/uptime-kuma/issues/1981
- https://noted.lol/easy-off-site-monitoring-with-fly-io-and-uptime-kuma/
- https://fly.io/docs/app-guides/custom-domains-with-fly/
FROM alpine:latest as tailscale
WORKDIR /app
ENV TSFILE=tailscale_1.36.0_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1

# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM louislam/uptime-kuma:alpine
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy binary to production image
COPY ./start.sh /app/start.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# copied from https://github.com/louislam/uptime-kuma/blob/master/docker/dockerfile-alpine
EXPOSE 3001
VOLUME ["/app/data"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD node extra/healthcheck.js
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/app/extra/entrypoint.sh"]

# Run on container startup.
CMD ["/app/start.sh"]
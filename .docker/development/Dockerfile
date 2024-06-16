ARG VERSION=latest
FROM alpine:3.19 as base

RUN apk add --no-cache --no-progress jq curl bash iputils-ping ca-certificates tzdata
RUN rm -rf /var/cache/apk/*

FROM smallstep/step-cli as step
FROM traefik:${VERSION} as proxy
FROM base

COPY --from=step /usr/local/bin/step /usr/local/bin/
COPY --from=proxy /entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY --from=proxy /usr/local/bin/traefik /usr/local/bin/

ARG CA_URL=https://step:9000
ARG CA_FINGERPRINT

ENV CA_URL=${CA_URL} CA_FINGERPRINT=${CA_FINGERPRINT} STEPPATH=/.step TLS_CERT_LOCATION=/run/tls/server.crt TLS_KEY_LOCATION=/run/tls/server.key TLS_CA_CERT_LOCATION=/run/tls/ca.crt

RUN mkdir -p /run/tls

COPY entrypoint-shim.sh /usr/local/bin
COPY cert-*.sh /usr/local/bin/

ENTRYPOINT ["entrypoint-shim.sh"]
CMD [ "traefik" ]

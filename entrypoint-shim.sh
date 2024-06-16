#!/bin/sh
set -e

if [ ! -z "$CA_FINGERPRINT" ] && [ ! -z "$CA_URL" ]; then
  step ca bootstrap --ca-url $CA_URL \
    --fingerprint $CA_FINGERPRINT --install -f
  step ca root $TLS_CA_CERT_LOCATION
fi

/usr/local/bin/cert-enroller.sh
if [ "$?" -eq 0 ]; then
  /usr/local/bin/cert-renewer.sh &
fi

/usr/local/bin/docker-entrypoint.sh "$@"

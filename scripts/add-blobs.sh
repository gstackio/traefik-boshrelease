#!/usr/bin/env bash

set -eo pipefail -u -x

TRAEFIK_VERSION=1.7.28
TRAEFIK_SHA256=e0d6fa9cb46477daedec6bb7512ef6e8b916d9f5b2f5ddb1b7b4693c7286b2c9

if [[ ! -f "traefik-${TRAEFIK_VERSION}_linux-amd64" && ! -f "traefik-${TRAEFIK_VERSION}_linux-amd64.gz" ]]; then
    curl -L "https://github.com/containous/traefik/releases/download/v$TRAEFIK_VERSION/traefik_linux-amd64" \
        -o "traefik-${TRAEFIK_VERSION}_linux-amd64"
    shasum -a 256 --check <<< "${TRAEFIK_SHA256}  traefik-${TRAEFIK_VERSION}_linux-amd64"
fi

if [[ -f "traefik-${TRAEFIK_VERSION}_linux-amd64" && ! -f "traefik-${TRAEFIK_VERSION}_linux-amd64.gz" ]]; then
    gzip -9 "traefik-${TRAEFIK_VERSION}_linux-amd64"
fi

blob_path="traefik/traefik-${TRAEFIK_VERSION}_linux-amd64.gz"
set +o pipefail
if ! bosh blobs | grep -q "${blob_path}"; then
    bosh add-blob "traefik-${TRAEFIK_VERSION}_linux-amd64.gz" "${blob_path}"
fi

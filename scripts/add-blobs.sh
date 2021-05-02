#!/usr/bin/env bash

set -eo pipefail -u -x

TRAEFIK_VERSION=1.7.30
TRAEFIK_SHA256=58c5eb53ed70126122921c3d568b1cfa1e103505f094823f2cecdf5c91976d78

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

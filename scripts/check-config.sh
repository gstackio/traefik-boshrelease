#!/usr/bin/env bash

TRAEFIK_REPO=${TRAEFIK_REPO:-~/workspace/bosh/traefik/traefik}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
RELEASE_DIR=$(dirname "${SCRIPT_DIR}")


{
    sed -e '/^<%$/,/^-%>$/d' "${RELEASE_DIR}/jobs/traefik/templates/conf/traefik.toml"
} \
    > "${RELEASE_DIR}/tmp/current-config.toml"


{
    cat <<EOF
################################################################
# Global configuration
################################################################

EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/commons.md"
    cat <<EOF
################################################################
# Entrypoints configuration
################################################################
################################################################
# Traefik logs configuration
################################################################

EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/logs.md"
    cat <<EOF
################################################################
# API and dashboard configuration
################################################################

EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/api.md"
    cat <<EOF

################################################################
# Ping configuration
################################################################

EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/ping.md"
    cat <<EOF

################################################################
# Metrics configuration
################################################################

EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/metrics.md"
    cat <<EOF
################################################################
# Let's Encrypt configuration
################################################################
EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/acme.md"
    cat <<EOF
################################################################
# Web backend configuration
################################################################

EOF
    sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/backends/web.md"
    cat <<EOF



<% if p('traefik.file.enabled') -%>
################################################################
# File backend configuration
################################################################

EOF
    # sed -n -e '/^```toml$/,/^```$/p' "${TRAEFIK_REPO}/docs/configuration/backends/file.md"
} \
    | grep -vE '^```(toml)?$' \
    > "${RELEASE_DIR}/tmp/reference-config.toml"

colordiff -u \
        "${RELEASE_DIR}/tmp/current-config.toml" \
        "${RELEASE_DIR}/tmp/reference-config.toml" \
    | less -R

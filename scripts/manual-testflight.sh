#!/usr/bin/env bash

set -e

function main() {
    _setup

    local vars_file  depl_name
    vars_file="${DEPL_DIR}/operations/testflight/testflight-vars.yml"
    depl_name=$(
        bosh interpolate "${vars_file}" \
            --path "/deployment_name"
    )

    local bosh_cmd=(
        bosh deploy \
            "${DEPL_DIR}/traefik.yml" \
            --deployment "${depl_name}" \
            --ops-file "${DEPL_DIR}/operations/latest-release.yml" \
            --ops-file "${DEPL_DIR}/operations/testflight/smoke-tests-setup.yml" \
            --ops-file "${DEPL_DIR}/operations/enable-api.yml" \
            --ops-file "${DEPL_DIR}/operations/enable-rest.yml" \
            --vars-file "${vars_file}" \
            "$@"
    )
    pretty_print >&2 "${bosh_cmd[@]}"
    "${bosh_cmd[@]}"

    bosh_cmd=(
        bosh run-errand \
            --deployment "${depl_name}" \
            "smoke-tests" \
            --keep-alive
    )
    pretty_print >&2 "${bosh_cmd[@]}"
    "${bosh_cmd[@]}"
}

function _setup() {
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    RELEASE_DIR=$(dirname "${SCRIPT_DIR}")
    DEPL_DIR="${RELEASE_DIR}/deployment"
}

function pretty_print() {
    local command=$1; shift
    local verb=$1; shift

    echo "+ ${command}" "${verb}"
    echo -n "    "
    local requires_space="false"
    for arg in "$@"; do
        if [[ "${requires_space}" == "true" ]]; then
            if [[ "${arg}" == "--"* ]]; then
                echo -en '\n    '
            else
                echo -n " "
            fi
        fi
        requires_space="true"
        if [[ "${arg}" == "${RELEASE_DIR}/"* ]]; then
            # echo "found prefix '${RELEASE_DIR}/' in '${arg}'"
            # echo "replacement: '${arg##"${RELEASE_DIR}/"}'"
            arg=${arg##"${RELEASE_DIR}/"}
        fi
        if [[ "${arg}" == "--"* ]]; then
            echo -n "${arg}"
        else
            echo -n "'${arg}'"
        fi
    done
    echo
}

main "$@"

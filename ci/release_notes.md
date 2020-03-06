### Improvements

- Bump Træfik to the latest version [1.7.21](https://github.com/containous/traefik/releases/tag/v1.7.21).

- Bump the [Consul release](https://github.com/gstackio/gk-consul-boshrelease) to v1.2.0 in the `clustering.yml` ops file.

- Bump BPM to v1.1.7 in the `traefik.yml` deployment manifest.

- Fix the broken DNS healthcheck script.


### Breaking changes

- In the [default deployment manifest](./deployment), the Traefik Certificate Authority has been renamed from `traefikCA` to `traefik_ca` and its Common Name (CN) from `traefikCA` to `Traefik CA`. This might have an impact on existing deployments relying on the default manifests, as the CA is to be re-generated with a new CN, and thus all dependant certificates are also to be re-generated so that they refer to this new CN.


### Caveats

- Smoke tests require an access to the Internet.

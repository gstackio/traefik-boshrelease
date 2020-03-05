## Base deployment

The `traefik-deployment.yml` base manifest desribes a classical 1-node
deployment of a Træfik reverse-proxy, that can be deployed in
[BOSH-Lite](https://bosh.io/docs/bosh-lite.html).

It enables a TLS endpoint with a custom certificate named `traefik_tls`,
signed by a custom Certificate Authority named `traefik_ca`. When you need
your Certificate Authority, or your certificate to be used, upload it in
CredHub with the correct `//<director-name>/<deployment-name>/<variable-name>`
path or put it in your `--vars-store` file prior to deploying.


## Cloud config

### `cloud-config/cf-integration.yml`

This Operation File is an example of how you can tweak the
[BOSH-Lite default cloud config](https://github.com/cloudfoundry/cf-deployment/blob/master/iaas-support/bosh-lite/cloud-config.yml)
and use Træfik as the main reverse-proxy in front of Cloud Foundry routers in
[BOSH-Lite](https://bosh.io/docs/bosh-lite.html).


## Operations files

### `operations/cf-integration.yml`

This operations file is an example of how to tweak the base deployment and use
Træfik as the main reverse-proxy in front of Cloud Foundry routers in
[BOSH-Lite](https://bosh.io/docs/bosh-lite.html).


### `operations/enable-lets-encrypt.yml`

This operation file enables the automatic provisioning of Let's Encrypt TLS
certificates. The HTTP-01 challenge is used.


### `operations/disable-default-tls-certificate.yml`

When the default kind-of-self-signed TLS certificate doesn't suit your needs,
then use this operation file to remove it.

This should not be enable when using the `enable-lets-encrypt.yml` ops file.


### `operations/enable-api.yml`

This operation file enables the `[api]` section of the configuration. This
provides an HTTPS entry-point for viewing the Træfik config through a
read-only web UI (but a read-write API). This managment UI runs on port `8443`
and is protected by a Digest Auth username and password.


### `operations/static-ip.yml`

Set a static IP to the Træfik reverse-proxy.


### `operations/rename-deployment.yml`

Allows to customize the deployment name.


### `operations/rename-network.yml`

Allows to customize the network name.


### `operations/latest-release.yml`

By default, the default deployment manifest pins this release version to the
latest final version available. When iterating on newer versions of this BOSH
release, you'll be interested in using the `latest` release that has been
uploaded to the BOSH Director. This is exactly what's provided by this
operations file.


## Deprecated operations files


### `operations/deprecated/enable-web-backend.yml`

This operation file enables the `web` backend for viewing the Træfik config
through a read-only web UI. This managment UI runs on port `8080` and is
protected by a Basic Auth username and password.

This alone is not compatible with the default `cf-integration.yml` ops file
that assumes the `web` backend is accessible on th `8443` port in order to
expose it on the main TLS entrypoint for a certain host. In such case, you'll
also need the `enable-web-backend-tls.yml` ops file.


### `operations/deprecated/enable-web-backend-tls.yml`

Together with `enable-web-backend.yml`, this enables TLS on the `web` backend,
and have it served on port `8443`.

This is required when using `enable-web-backend.yml` with the
`cf-integration.yml` ops file.


### `operations/deprecated/enable-web-backend-readwrite.yml`

This operation file enables the `web` backend for modifying the Træfik config
through a read-only web UI and a read-write API. Enabling this is discouraged
in production, unless proper access restrictions are applied on the `web`
backend, and TLS is enabled.

### Improvements

- Bump the [Consul release](https://github.com/gstackio/gk-consul-boshrelease) to v1.5.0 in the `clustering.yml` and `clustering-compiled-release.yml` ops files.

- Demonstrate how to add a BOSH DNS alias for Træfik, and feed this into the generated TLS certificate alternative names.

- Mount persistent disk with BPM only when Let's Encrypt is enabled.

- Add `NET_BIND_SERVICE` capability in BPM only when Træfik needs to bind to some port number that is less than 1024.


### Caveats

- Smoke tests require an access to the Internet.

- Clustering mode is experimental: we've experienced situations where no Traefik node is able to acquire the Consul lock in order to access Let's Encrypt cetificates. In such situations, all HTTPS requests requiring a Let's Encrypt certificate are failing, which is pretty bad. We've observed that the Traefik timeout for acquiring Consul lock is too short. Consul does store the expected lock value written by Traefik, but a little too late. So when the value is available, Traefik already has failed at acquiring the lock, and has already started retrying, writing a new value. Traefik won't be able to read the new value back because Consul is still late. Lock acquiring will fail again. Traefik will be able to read this new value only during the next retry. All in all, with enough Let's Encrypt certificates stored (we haven't identified any precise threshold yet), we've observed an infinite loop while Traefik fails at acquiring the Consul lock.

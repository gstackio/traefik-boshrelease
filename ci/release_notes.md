### Improvements

- Bump Træfik to the latest version [1.7.24](https://github.com/containous/traefik/releases/tag/v1.7.24).

- Bump the [Consul release](https://github.com/gstackio/gk-consul-boshrelease) to v1.3.0 in the `clustering.yml` ops file.

- Bump BPM to v1.1.8 in the `traefik.yml` deployment manifest.


### Caveats

- Smoke tests require an access to the Internet.

- Clustering mode is experimental: we've experienced situations where no Traefik node is able to acquire the Consul lock in order to access Let's Encrypt cetificates. In such situation, all HTTPS requests requiring a Let's Encrypt certificate are failing, which is pretty bad. We observed that the Traefik timeout for acquiring Consul lock is to short. Consul does store the expected lock value written by Traefik, but a little too late. So when the value is available, Traefik already has failed at acquiring the lock, and has already started retrying, writing a new value. Traefik won't be able to read the new value back because Consul is still late. Loxk acquiring will fail again. Traefik will be able to read this new value only during the next retry. All in all, with enough Let's Encrypt certificates stored (we haven't identified any precise threshold yet), we've observed an infinite loop while Traefik fails at acquiring the Consul lock.

### Improvements

- Add support for Traefik clustering, leveraging the modern [gk-consul](https://github.com/gstackio/gk-consul-boshrelease) BOSH Release.

- Add native support for BOSH DNS health checks using Træfik `/ping` endpoint. Now BOSH DNS queries properly return healthy instances.

- Bump BPM to v1.1.5 in the standard deployment manifest.

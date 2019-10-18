### Improvements

- Have the smoke tests fail when running them with `traefik.rest.enabled` set
  to `false`, as they depend in the REST backend to be opted-in.

- Bump BPM to v1.1.3 in the standard deployment manifest.

- Bump stemcell family to v456.x, and create Træfik compiled releases based
  the latest stemcell from this family.


### Breaking Changes

- The `traefik-deployment.yml` manifest name is standardized to `traefik.yml`

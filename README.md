Træfik BOSH Release
===================

This [BOSH](https://bosh.io) release deploys a [Træfik](https://traefik.io/)
reverse-proxy.

Træefik is a modern and dynamic reverse-proxy, that is well known for
implementing on-demand [Let's Encrypt](https://letsencrypt.org/) certificates.

So the main use-case for this BOSH Release is to deploy Træfik in front of
your Cloud Foundry routers. This enable all your Cloud Foundry applications to
benefit from valid HTTPS certificates with absolutely no fuss. They are
provisioned on the fly, when the first web request is made. See the main
[deployment manifest](./deployment) and related operations files for Cloud
Foundry integration.


What is BOSH?
-------------

For those who don't know,
[BOSH is Borg++](https://twitter.com/marklucovsky/status/728950262593953792),
where [Google Borg](https://research.google.com/pubs/pub43438.html) is a
large-scale cluster management tool. Borg is a proprietary tool by Google,
whereas [BOSH is Open Source](https://github.com/cloudfoundry/bosh).

For an introduction about what is BOSH, go watch
[this talk given by Benjamin Gandon from Gstack](https://slides.gstack.io/bosh-deploy-distributed-systems-like-a-boss-may-2017/)
and then go read the [Ultimate Guide to BOSH](http://ultimateguidetobosh.com/)
in order to lean more.


Usage
-----

Here is a very basic way of using this BOSH Release. You'll need to properly
target a previously-installed BOSH Director.

```bash
export BOSH_ENVIRONMENT=<alias>
export BOSH_DEPLOYMENT=traefik

git clone https://github.com/gstackio/traefik-boshrelease.git
cd traefik-boshrelease

mkdir tmp
> tmp/depl-creds.yml
chmod 600 tmp/depl-creds.yml

bosh deploy deployment/traefik-deployment.yml --vars-store tmp/depl-creds.yml
```

For more details and possible variants, go read the documentation in the
[deployment](./deployment) sub-directory.

An example for a Træfik deployment that is integrated to Cloud Foundry is
available in the [Easy Foundry distribution](https://github.com/gstackio/gstack-bosh-environment).


Contributing
------------

Please feel free to submit issues and pull requests.

See the [CONTRIBUTING](CONTRIBUTING.md) docs for more details.


Author and License
------------------

Copyright © 2018-present, Benjamin Gandon

Like the rest of BOSH, the Træfik BOSH release is released under the terms
of the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0).

<!--
# Local Variables:
# indent-tabs-mode: nil
# End:
-->

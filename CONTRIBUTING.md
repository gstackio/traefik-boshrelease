Contributing
============


Version bumps
-------------

The “bump” pipeline is here to help bumping Traefik version.

When a pull request is submitted by the pipeline, the Traefik configuration
template in `jobs/traefik/templates/conf/traefik.toml` should be inspected for
any required evolution.

The helper `scripts/check-config.sh` is designed to assist that task.

As requirements, the `colordiff` utility must be installed first, and the
`TRAEFIK_REPO` environment variable must point to a Git directory where the
`traefik` new version has been checked out.

For a first run, adapt the following example commands to your context:

```shell
cd traefik-boshrelease
git clone --branch "v1.7" -- https://github.com/containous/traefik.git ../traefik
TRAEFIK_REPO=../traefik scripts/check-config.sh
```

This will display a diff between current configuration ERB template, and new
configuration examples, so that you have a chance to spot any evolutions, that
you would then port to the configurtion ERB template.


Testing
-------

When submitting code, take care that it is tested. For this, one option is to
run the Concourse pipeline, another is to run the smoke tests manually.


### Run tests manually

As a requirement, you need to target a properly-configured Bosh Director.

This means that you need the `bosh` CLI in your shell `$PATH`, and typically
four environment variables to be properly set (i.e. `BOSH_ENVIRONMENT`,
`BOSH_CA_CERT`, `BOSH_CLIENT` and `BOSH_CLIENT_SECRET`) so that the CLI can
properly “talk” to the Director. Of course, this requires a configured and
deployed Bosh server, that properly serves the Director REST API. Refer to the
[documentation][deploy_director] for that.

This director needs to have a “_runtime config_” that properly implements
[BOSH DNS][bosh_dns_runtime_config], and a “_cloud config_” that defines a
`default` VM type, a `default` network, and a `default` persistent disk type.
This is fairly common when using [bosh-deployment][bosh_deployment], as
advised by the Bosh documentation, but also a source of confusion for
newcomers when it's missing.

When these requirements are met, just run the `manual-testflight.sh` script,
that will execute the same `bosh deploy` and `bosh run-errand smoke-tests` as
the `testflight` job does in the Concourse pipeline.

```shell
scripts/manual-testflight.sh
```

Ans you may pass a `--non-interactive` option to this script when you're
confident about what you are doing.

After the debug is done, make sure that you properly cleanup the “testflight”
deployment.

```shell
bosh delete-deployment --deployment "traefik-testflight" --non-interactive
```

[deploy_director]: https://bosh.io/docs/init/
[bosh_dns_runtime_config]: https://github.com/cloudfoundry/bosh-deployment/blob/master/runtime-configs/dns.yml
[bosh_deployment]: https://github.com/cloudfoundry/bosh-deployment


### Run tests in the pipeline

The Concourse pipeline can be deployed on any Concourse installation using the
`ci/repipe` script, just as explained in the
[documentation][pipeline_templates].


### Re-generate the pipeline from (updated) template

The Concourse pipeline is a standard pipeline of `boshrelease` type, from the
[pipeline templates][pipeline_templates], as maintained by the Cloud Foundry
community. It can be re-generated using the `setup boshrelease` command as
detailed by the documentation.

```shell
cd traefik-boshrelease
path/to/concourse/pipeline-templates/setup boshrelease
```

After runing this, one should inspect the changes appled, and update the
`settings.yml` accordingly, to that the `spruce merge` operation keeps being
successful. This is most often a trivial update.

[pipeline_templates]: https://github.com/cloudfoundry-community/pipeline-templates

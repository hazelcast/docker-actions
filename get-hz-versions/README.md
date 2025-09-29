### get-hz-versions Action

A GitHub Action that extracts Hazelcast OSS and EE version information from Dockerfiles and Maven repositories.

#### Inputs

| Name                | Description                                                                 | Required | Default |
|---------------------|-----------------------------------------------------------------------------|----------|---------|
| working-directory   | Directory containing `hazelcast-oss` and `hazelcast-enterprise` directories | No       | .       |

#### Outputs

| Name                         | Description                                                 |
|------------------------------|-------------------------------------------------------------|
| HZ_VERSION                   | Hazelcast version from the `Dockerfile`                     |

## Usage

Example workflow:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hazelcast/docker-actions/get-hz-versions@master
        id: hz_versions
      - run: echo "HZ Version: ${{ steps.hz_versions.outputs.HZ_VERSION }}"
```
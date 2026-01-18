# kubectl image

POC of kubectl image, based on debian, multi-arch, with a shell, and with variants
- basic: `kubectl` with shell
- jq: basic+`jq`

each variant exist from many debian versions:
- 11
  - `jfcoz/kubectl-deb11-basic`
  - `jfcoz/kubectl-deb11-jq`
- 12
  - `jfcoz/kubectl-deb12-basic`
  - `jfcoz/kubectl-deb12-jq`
- 13
  - `jfcoz/kubectl-deb13-basic`
  - `jfcoz/kubectl-deb13-jq`

all versions are available via different tags:
- `$major.$minor.$patch`
- `v$major.$minor.$patch`
- `$major.$minor`
- `v$major.$minor`


## Velero

when using with Velero, use the same debian version for LD_PRELOAD compatibility of /usr/bin/sh which is copied from kubectl image and run in velero image

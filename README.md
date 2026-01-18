# kubectl image

POC of kubectl image, based on debian, multi-arch, with a shell, and with variants
- basic: kubectl+shell
- jq: basic+jq

## Velero

when using with Velero, use the same debian version for LD_PRELOAD compatibility of /usr/bin/sh which is copied from kubectl image and run in velero image

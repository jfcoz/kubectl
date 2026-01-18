variable "REGISTRY" {
  default = "jfcoz"
}

function "tag" {
  params = [tgt, debian_version, kubectl_version]
  result = [
    "${REGISTRY}/kubectl-deb${debian_version}-${replace(tgt,"_","-")}:${kubectl_version}",
    "${REGISTRY}/kubectl-deb${debian_version}-${replace(tgt,"_","-")}:v${kubectl_version}"
  ]
}

target "default" {
  context = "."
  name = "kubectl-deb${debian_version}-${replace(tgt,"_","-")}-${replace(kubectl_version, ".", "-")}"
  dockerfile = "Dockerfile"
  tags = tag(tgt,debian_version,kubectl_version)
  matrix = {
    tgt = ["basic", "jq"]
    debian_version = [
      "11",
      "12",
      "13",
    ]
    kubectl_version = [
      "1.30.0","1.30.1","1.30.2","1.30.3","1.30.4","1.30.5","1.30.6","1.30.7","1.30.8","1.30.9","1.30.10","1.30.11","1.30.12","1.30.13","1.30.14",
      "1.31.0","1.31.1","1.31.2","1.31.3","1.31.4","1.31.5","1.31.6","1.31.7","1.31.8","1.31.9","1.31.10","1.31.11","1.31.12","1.31.13","1.31.14",
      "1.32.0","1.32.1","1.32.2","1.32.3","1.32.4","1.32.5","1.32.6","1.32.7","1.32.8","1.32.9","1.32.10","1.32.11",
      "1.33.0","1.33.1","1.33.2","1.33.3","1.33.4","1.33.5","1.33.6","1.33.7",
      "1.34.0","1.34.1","1.34.2","1.34.3",
      "1.35.0"
    ]
  }
  args = {
    KUBECTL_VERSION = kubectl_version
    DEBIAN_VERSION = debian_version
  }
  target = tgt
  platforms = ["linux/amd64", "linux/arm64"]
}

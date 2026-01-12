variable "REGISTRY" {
  default = "jfcoz"
}

function "tag" {
  params = [tgt, version]
  result = [
    "${REGISTRY}/kubectl-${tgt}:${version}",
    "${REGISTRY}/kubectl-${tgt}:v${version}"
  ]
}

target "default" {
  context = "."
  name = "kubectl-${tgt}-${replace(version, ".", "-")}"
  dockerfile = "Dockerfile"
  tags = tag(tgt,version)
  matrix = {
    tgt = ["basic", "jq"]
    version = [
      "1.30.0",
      "1.31.0",
      "1.32.0","1.32.1","1.32.2","1.32.3","1.32.4","1.32.5","1.32.6","1.32.7","1.32.8","1.32.9","1.32.10","1.32.11",
      "1.33.0",
      "1.34.0",
      "1.35.0"
    ]
  }
  args = {
    KUBECTL_VERSION = version
  }
  target = tgt
  platforms = ["linux/amd64", "linux/arm64"]
}

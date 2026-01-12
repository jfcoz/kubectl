variable "REPO" {
  default = "jfcoz/kubectl"
}

function "tag" {
  params = [tgt, version]
  result = ["${REPO}:${tgt}-${replace(version, ".", "-")}"]
}

target "default" {
  context = "."
  name = "kubectl-${tgt}-${replace(version, ".", "-")}"
  dockerfile = "Dockerfile"
  tags = tag(tgt,version)
  matrix = {
    tgt = ["basic", "jq"]
    version = [
      "v1.30.0",
      "v1.31.0",
#      "v1.32.0",
#      "v1.33.0",
#      "v1.34.0",
#      "v1.35.0"
    ]
  }
  args = {
    KUBECTL_VERSION = version
  }
  target = tgt
  platforms = ["linux/amd64", "linux/arm64"]
}

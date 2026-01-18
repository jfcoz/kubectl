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

function "tags" {
  params = [tgt, debian_version, kubectl_version]
  result = concat(
    tag(tgt,debian_version,kubectl_version),
    substr(kubectl_version,-6,6) == "latest" ? tag(tgt, debian_version,get_major_minor(kubectl_version)) : [],
  )
}

function "get_major_minor" {
  params = [version]
  result = join(".",slice(split(".",version),0,2))
}

function "get_patch" {
  params = [version]
  result = {
    patch = element(split(".",version),2)
  }
}

function "get_all_patches" {
  params = [version]
  result = concat(
    [for pv in range(0,element(split(".",version),2)): join(".",[
      element(split(".",version),0),
      element(split(".",version),1),
      pv
    ])],
    ["${version}-latest"]
  )
}

target "default" {
  context = "."
  name = "kubectl-deb${debian_version}-${replace(tgt,"_","-")}-${replace(kubectl_version, ".", "-")}"
  dockerfile = "Dockerfile"
  tags = tags(tgt,debian_version,kubectl_version)
  matrix = {
    tgt = ["basic", "jq"]
    debian_version = [
      "11",
      "12",
      "13",
    ]
    kubectl_version = concat(
      get_all_patches("1.30.14"),
      get_all_patches("1.31.14"),
      get_all_patches("1.32.11"),
      get_all_patches("1.33.7"),
      get_all_patches("1.34.3"),
      get_all_patches("1.35.0"),
    )
  }
  args = {
    KUBECTL_VERSION = regex("[0-9]+\\.[0-9]+\\.[0-9]+",kubectl_version)
    DEBIAN_VERSION = debian_version
  }
  target = tgt
  platforms = ["linux/amd64", "linux/arm64"]
}

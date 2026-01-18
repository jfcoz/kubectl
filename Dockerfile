ARG DEBIAN_VERSION
FROM jfcoz/debian-upgraded:${DEBIAN_VERSION}-slim AS securityupgraded

FROM securityupgraded AS builder
RUN apt-get update \
 && apt-get install -y curl ca-certificates \
 && rm -rf /var/lib/apt/lists/

FROM builder AS downloader
ARG KUBECTL_VERSION
ARG TARGETARCH
RUN curl -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" -o /usr/bin/kubectl \
 && chmod +x /usr/bin/kubectl \
 && kubectl version --client

FROM securityupgraded AS basic
COPY --from=downloader --link /usr/bin/kubectl /usr/bin/kubectl

FROM securityupgraded AS jq
RUN apt-get update \
 && apt-get install -y jq \
 && rm -rf /var/lib/apt/lists/
COPY --from=downloader --link /usr/bin/kubectl /usr/bin/kubectl

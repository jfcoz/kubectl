FROM debian:bookworm-slim as upgraded
RUN apt-get update \
 && apt-get upgrade \
 && rm -rf /var/lib/apt/lists/

FROM upgraded as builder
RUN apt-get update \
 && apt-get install -y curl ca-certificates \
 && rm -rf /var/lib/apt/lists/
ARG KUBECTL_VERSION
ARG TARGETARCH
RUN curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" -o /usr/bin/kubectl \
 && chmod +x /usr/bin/kubectl \
 && kubectl version --client

FROM upgraded as basic
COPY --from=builder /usr/bin/kubectl /usr/bin/kubectl

FROM upgraded as jq
RUN apt-get update \
 && apt-get install -y jq \
 && rm -rf /var/lib/apt/lists/
COPY --from=builder /usr/bin/kubectl /usr/bin/kubectl

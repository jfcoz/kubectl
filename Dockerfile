FROM debian:bookworm-slim AS upgraded
RUN apt-get update \
 && apt-get upgrade -y \
 && rm -rf /var/lib/apt/lists/

FROM upgraded AS kubectlrepo
RUN apt-get update \
 && apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
 && rm -rf /var/lib/apt/lists/
ARG KUBECTL_VERSION
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v'$(echo ${KUBECTL_VERSION} | cut -d . -f 1-2)'/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
 && chmod 644 /etc/apt/sources.list.d/kubernetes.list
ADD --chmod=644 kubernetes-apt-keyring.gpg /etc/apt/keyrings/kubernetes-apt-keyring.gpg

FROM upgraded AS builder
RUN apt-get update \
 && apt-get install -y curl ca-certificates \
 && rm -rf /var/lib/apt/lists/
ARG KUBECTL_VERSION
ARG TARGETARCH
RUN curl -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" -o /usr/bin/kubectl \
 && chmod +x /usr/bin/kubectl \
 && kubectl version --client

FROM upgraded AS basic
COPY --from=builder /usr/bin/kubectl /usr/bin/kubectl

FROM upgraded AS jq
RUN apt-get update \
 && apt-get install -y jq \
 && rm -rf /var/lib/apt/lists/
COPY --from=builder /usr/bin/kubectl /usr/bin/kubectl

FROM kubectlrepo AS deb_basic
ARG KUBECTL_VERSION
RUN apt-get update \
# && apt list kubectl ${KUBECTL_VERSION} \
# && apt-get install -y kubectl=1.35.0-1.1
 && apt-get install -y kubectl \
 && rm -rf /var/lib/apt/lists

FROM deb_basic AS deb_jq
RUN apt-get update \
 && apt-get install -y jq \
 && rm -rf /var/lib/apt/lists/

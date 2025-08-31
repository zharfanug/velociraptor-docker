FROM amazonlinux:2023

LABEL description="Velociraptor by velocidex - Endpoint visibility and collection tool."
LABEL maintainer="Zharfan Nugroho, @zharfanug"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ARG VELO_CONFIG="/etc/velociraptor"
ARG VELO_DIR="/opt/velociraptor"
ARG VELO_LOGS="/var/log/velociraptor"
ARG S6_VERSION="v2.2.0.3"

ENV VELO_CONFIG="${VELO_CONFIG}" \
    VELO_DIR="${VELO_DIR}" \
    VELO_DS="${VELO_DIR}/ds" \
    VELO_FS="${VELO_DIR}/fs" \
    VELO_FILES="${VELO_DIR}/files" \
    VELO_BIN="${VELO_DIR}/bin" \
    VELO_LOGS="${VELO_LOGS}" \
    PATH="${PATH}:${VELO_DIR}/bin"

# Install required packages
RUN yum install -y \
    curl-minimal \
    jq \
    tar \
    gzip \
    openssl \
  && yum clean all

# Install s6-overlay
RUN curl --fail --silent -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz -o /tmp/s6-overlay-amd64.tar.gz && \
  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
  tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin && \
  rm  /tmp/s6-overlay-amd64.tar.gz

# Get Velociraptor binaries (latest release)
RUN mkdir -p "$VELO_CONFIG" "$VELO_DIR" "$VELO_DS" "$VELO_FS" "$VELO_BIN" "$VELO_LOGS" "$VELO_FILES" && \
  curl -s https://api.github.com/repos/velocidex/velociraptor/releases/latest > /tmp/velociraptor_releases && \
  LINUX_BIN=$(jq -r '[.assets | sort_by(.created_at) | reverse | .[] | .browser_download_url | select(test("linux-amd64$"))][0]' /tmp/velociraptor_releases) && \
  curl -L -so "$VELO_BIN/velociraptor" "$LINUX_BIN" && chmod +x "$VELO_BIN/velociraptor" && \
  rm /tmp/velociraptor_releases

COPY config/etc/ /etc/

WORKDIR ${VELO_DIR}

ENTRYPOINT [ "/init" ]
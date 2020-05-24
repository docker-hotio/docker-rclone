FROM ubuntu:18.04 as builder

ARG DEBIAN_FRONTEND="noninteractive"

# install
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates curl unzip

# install rclone
ARG RCLONE_VERSION
RUN zipfile="/tmp/rclone.zip" && curl -fsSL -o "${zipfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm64.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-arm64/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM ubuntu@sha256:03e4a3b262fd97281d7290c366cae028e194ae90931bc907991444d026d6392a
LABEL maintainer="hotio"

ARG DEBIAN_FRONTEND="noninteractive"

ENTRYPOINT ["rclone"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

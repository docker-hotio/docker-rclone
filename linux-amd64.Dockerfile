FROM hotio/base@sha256:313617f9f749cb659c9d27e2a022a46fb879de967c44fdd63e88940753383602

ARG DEBIAN_FRONTEND="noninteractive"

ENV MOUNTPOINT="/mountpoint"

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/ncw/rclone/releases
ARG RCLONE_VERSION=1.50.2

# install rclone
RUN debfile="/tmp/rclone.deb" && curl -fsSL -o "${debfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /

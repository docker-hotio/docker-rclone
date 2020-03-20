FROM hotio/base@sha256:5fa856ae4a428184ae3b8a2863efbb786cd1808b38ea6ce1b420848b0a8f61b0

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
ARG RCLONE_VERSION=1.51.0

# install rclone
RUN debfile="/tmp/rclone.deb" && curl -fsSL -o "${debfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /

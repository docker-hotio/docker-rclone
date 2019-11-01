ARG BRANCH
FROM hotio/base:${BRANCH}

ARG DEBIAN_FRONTEND="noninteractive"

ENV MOUNT_DIR="/mount"

COPY root/ /

# https://github.com/ncw/rclone/releases
ENV RCLONE_VERSION=1.50.0

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse && \
# install rclone
    curl -fsSL -o "/tmp/rclone.deb" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.deb" && dpkg --install "/tmp/rclone.deb" && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG BRANCH
FROM hotio/base:${BRANCH}

ARG DEBIAN_FRONTEND="noninteractive"

ENV MOUNT_DIR="/mount"

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/ncw/rclone/releases
ENV RCLONE_VERSION=1.50.0

# install rclone
RUN curl -fsSL -o "/tmp/rclone.deb" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm.deb" && dpkg --install "/tmp/rclone.deb"

COPY root/ /

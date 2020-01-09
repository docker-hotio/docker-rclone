FROM hotio/base@sha256:9adbfc4150ae80b31ee18d991897022e26e0722b47c9bcf9acdd02d43a19d372

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
RUN debfile="/tmp/rclone.deb" && curl -fsSL -o "${debfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /

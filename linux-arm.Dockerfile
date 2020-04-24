FROM hotio/base@sha256:d668da1b18583d94b5ddb8e8c25012d24bf3ad54231ab8af2f0ed0ca02bcc6ff

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

ARG RCLONE_VERSION

# install rclone
RUN debfile="/tmp/rclone.deb" && curl -fsSL -o "${debfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /

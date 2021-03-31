FROM alpine:3.11 as builder

# install
RUN apk add --no-cache unzip

# install rclone
ARG VERSION
RUN zipfile="/tmp/rclone.zip" && wget -O "${zipfile}" "https://downloads.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-amd64.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-amd64/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM alpine@sha256:e103c1b4bf019dc290bcc7aca538dc2bf7a9d0fc836e186f5fa34945c5168310
LABEL maintainer="hotio"
ENTRYPOINT ["rclone"]

# install packages
RUN apk add --no-cache fuse

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

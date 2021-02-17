FROM alpine:3.11 as builder

# install
RUN apk add --no-cache unzip

# install rclone
ARG VERSION
RUN zipfile="/tmp/rclone.zip" && wget -O "${zipfile}" "https://beta.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-amd64.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-amd64/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM alpine@sha256:4661fb57f7890b9145907a1fe2555091d333ff3d28db86c3bb906f6a2be93c87
LABEL maintainer="hotio"
ENTRYPOINT ["rclone"]

# install packages
RUN apk add --no-cache fuse

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

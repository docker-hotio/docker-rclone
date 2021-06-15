FROM alpine:3.11 as builder

# install
RUN apk add --no-cache unzip

# install rclone
ARG VERSION
RUN zipfile="/tmp/rclone.zip" && wget -O "${zipfile}" "https://beta.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-arm64.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-arm64/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM alpine@sha256:55fc95a51d97f7b76b124f3b581a58ebf5555d12574f16087de3971a12724dd4
LABEL maintainer="hotio"
ENTRYPOINT ["rclone"]

# install packages
RUN apk add --no-cache fuse

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

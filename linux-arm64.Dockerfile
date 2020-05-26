FROM alpine:3.11 as builder

# install
RUN apk add --no-cache ca-certificates curl unzip

# install rclone
ARG RCLONE_VERSION
RUN zipfile="/tmp/rclone.zip" && curl -fsSL -o "${zipfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm64.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-arm64/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM alpine@sha256:ad295e950e71627e9d0d14cdc533f4031d42edae31ab57a841c5b9588eacc280
LABEL maintainer="hotio"
ENTRYPOINT ["rclone"]

# install packages
RUN apk add --no-cache ca-certificates fuse

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

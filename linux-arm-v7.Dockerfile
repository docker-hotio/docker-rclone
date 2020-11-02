FROM alpine:3.11 as builder

# install
RUN apk add --no-cache unzip

# install rclone
ARG VERSION
RUN zipfile="/tmp/rclone.zip" && wget -O "${zipfile}" "https://beta.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-arm.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-arm/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM alpine@sha256:d0f78a6ddf7a457dc72dbd44eab67209454ddb1e6d2323fa8e27275bc13dc320
LABEL maintainer="hotio"
ENTRYPOINT ["rclone"]

# install packages
RUN apk add --no-cache fuse

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

FROM alpine:3.11 as builder

# install
RUN apk add --no-cache unzip

# install rclone
ARG VERSION
RUN zipfile="/tmp/rclone.zip" && wget -O "${zipfile}" "https://beta.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-arm.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-arm/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM alpine@sha256:9df60229e68a34a47eee0a5801b311ef76d86c92a993f72cfa0c69942214c1fc
LABEL maintainer="hotio"
ENTRYPOINT ["rclone"]

# install packages
RUN apk add --no-cache fuse

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone

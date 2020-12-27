#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    export DOCKER_CLI_EXPERIMENTAL=enabled
    image="alpine"
    tag="3.12"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm" and .platform.os == "linux" and .platform.variant == "v7").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-arm-v7.Dockerfile && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
elif [[ ${1} == "tests" ]]; then
    echo "Listing packages..."
    docker run --rm --entrypoint="" "${2}" apk -vv info | sort
    echo "Show version info..."
    docker run --rm --entrypoint="" "${2}" rclone version
else
    version=$(curl -fsSL "https://beta.rclone.org/version.txt" | sed s/rclone\ v//g)
    [[ -z ${version} ]] && exit 1
    wget --spider "https://beta.rclone.org/v${version}/rclone-v${version}-linux-amd64.zip" 2>/dev/null || exit 0
    wget --spider "https://beta.rclone.org/v${version}/rclone-v${version}-linux-arm64.zip" 2>/dev/null || exit 0
    wget --spider "https://beta.rclone.org/v${version}/rclone-v${version}-linux-arm.zip" 2>/dev/null || exit 0
    old_version=$(jq -r '.version' < VERSION.json)
    changelog=$(jq -r '.changelog' < VERSION.json)
    [[ "${old_version: -9}" != "${version: -9}" ]] && changelog="https://github.com/rclone/rclone/compare/${old_version: -9}...${version: -9}"
    echo '{"version":"'"${version}"'","changelog":"'"${changelog}"'"}' | jq . > VERSION.json
fi

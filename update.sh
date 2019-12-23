#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    image="hotio/base:stable-linux-amd64" && docker pull ${image} && digest=$(docker inspect --format='{{index .RepoDigests 0}}' ${image}) && sed -i "s#FROM .*\$#FROM ${digest}#g" ./linux-amd64.Dockerfile
    image="hotio/base:stable-linux-arm"   && docker pull ${image} && digest=$(docker inspect --format='{{index .RepoDigests 0}}' ${image}) && sed -i "s#FROM .*\$#FROM ${digest}#g" ./linux-arm.Dockerfile
    image="hotio/base:stable-linux-arm64" && docker pull ${image} && digest=$(docker inspect --format='{{index .RepoDigests 0}}' ${image}) && sed -i "s#FROM .*\$#FROM ${digest}#g" ./linux-arm64.Dockerfile
else
    version=$(curl -fsSL "https://api.github.com/repos/ncw/rclone/releases/latest" | jq -r .tag_name | sed s/v//g)
    [[ -z ${version} ]] && exit
    find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG RCLONE_VERSION=.*$/ARG RCLONE_VERSION=${version}/g" {} \;
    sed -i "s/{TAG_VERSION=.*}$/{TAG_VERSION=${version}}/g" .drone.yml
    echo "##[set-output name=version;]${version}"
fi

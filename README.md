[<img src="https://hotio.dev/img/rclone.png" alt="logo" height="130" width="130">](https://github.com/rclone/rclone)

![Base](https://img.shields.io/badge/base-alpine-blue)
[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-rclone)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/rclone)](https://hub.docker.com/r/hotio/rclone)
[![GitHub Registry](https://img.shields.io/badge/registry-ghcr.io-blue)](https://github.com/users/hotio/packages/container/package/rclone)
[![Discord](https://img.shields.io/discord/610068305893523457?color=738ad6&label=discord&logo=discord&logoColor=white)](https://discord.gg/3SnkuKp)
[![Upstream](https://img.shields.io/badge/upstream-project-yellow)](https://github.com/rclone/rclone)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm hotio/rclone ...
```

The default `ENTRYPOINT` is `rclone`.

## Tags

| Tag                | Upstream      |
| -------------------|---------------|
| `release` (latest) | Releases      |
| `testing`          | Beta releases |

You can also find tags that reference a commit or version number.

## Using a rclone mount on the host

By setting the `bind-propagation` to `shared` on the volume `mountpoint`, like this `-v /data/mountpoint:/mountpoint:shared`, you are able to access the mount from the host. If you want to use this mount in another container, the best solution is to create a volume on the parent folder of that mount with `bind-propagation` set to `slave`. For example, `-v /data:/data:slave` (`/data` on the host, would contain the previously created volume `mountpoint`). Doing it like this will ensure that when the container creating the mount restarts, the other containers using that mount will recover and keep working.

## Extra docker privileges

In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using `rclone mount`.

```shell
--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse
```

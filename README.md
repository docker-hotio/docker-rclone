# rclone

<img src="https://raw.githubusercontent.com/hotio/unraid-templates/master/hotio/img/rclone.png" alt="Logo" height="130" width="130">

[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-rclone)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/rclone)](https://hub.docker.com/r/hotio/rclone)
[![Discord](https://img.shields.io/discord/610068305893523457?color=738ad6&label=discord&logo=discord&logoColor=white)](https://discord.gg/3SnkuKp)
[![Upstream](https://img.shields.io/badge/upstream-project-yellow)](https://github.com/rclone/rclone)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm --name rclone -v /<host_folder_config>:/config -v /<host_folder_mountpoint>:/mountpoint:shared -e REMOTE="remote:path/to/files" hotio/rclone
```

The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=002
-e TZ="Etc/UTC"
-e ARGS=""
-e MOUNTPOINT="/mountpoint"
-e ROTATE_SA_REMOTE=""
```

## Tags

| Tag      | Description                    | Build Status                                                                                                                                          | Last Updated                                                                                                                                                  |
| ---------|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| latest   | The same as `stable`           |                                                                                                                                                       |                                                                                                                                                               |
| stable   | Stable version                 | [![Build Status](https://cloud.drone.io/api/badges/hotio/docker-rclone/status.svg?ref=refs/heads/stable)](https://cloud.drone.io/hotio/docker-rclone) | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/hotio/docker-rclone/stable)](https://github.com/hotio/docker-rclone/commits/stable) |

You can also find tags that reference a commit or version number.

## Configuring rclone

Use `docker exec -it --user hotio rclone rclone config` to configure your remote when the container is running. Configuration files for `rclone` are stored in `/config/.config/rclone`.

## Using the rclone mount on the host

By setting the `bind-propagation` to `shared` on the volume `mountpoint`, like this `-v /data/mountpoint:/mountpoint:shared`, you are able to access the mount from the host. If you want to use this mount in another container, the best solution is to create a volume on the parent folder of that mount with `bind-propagation` set to `slave`. For example, `-v /data:/data:slave` (`/data` on the host, would contain the previously created volume `mountpoint`). Doing it like this will ensure that when the container creating the mount restarts, the other containers using that mount will recover and keep working.

## Rotating service accounts for supported remotes

By configuring `ROTATE_SA_REMOTE` with the name of the remote that supports service accounts and putting your `*.json` files in the folder `/config/rotate-sa`, everytime the container is started the oldest service account file sorted by modified date is used to start the mount.

## Extra docker privileges

In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a rclone mount.

```shell
--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse
```

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```

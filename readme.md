[![Docker Repository on Quay](https://quay.io/repository/pmav99/grass_docker_src/status "Docker Repository on Quay")](https://quay.io/repository/pmav99/grass_docker_src)

# Description

This repo contains Dockerfiles for compiling GRASS GIS from source.

Each branch corresponds to a different docker image. There are currently the following images:

* `base` which is the image on which the subsequent images are based upon.
* `702` which builds the last stable release of GRASS 7.
* `trunk7` which builds the last release.

# Usage

You should be able to pull each image directly from http://quay.io but you can also tweak the
Dockerfiles and build the images yourself.

## GRASS 7.0.2

This is the latest stable release.

```
docker pull quay.io/pmav99/grass_docker_src:702
```

## GRASS 7 latest (trunk)

```
docker pull quay.io/pmav99/grass_docker_src:trunk7
```


Just execute `build.sh` and you will end up in a root console.  There is also a normal user named
`grassuser` who has passwordless suod enabled and also has some sample GRASS locations in his home
directory.

## GUI

In order to be able to run the GUI you need to enable docker to access the host's X server:
```
xhost +local:docker
```

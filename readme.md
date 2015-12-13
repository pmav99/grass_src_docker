[![Docker Repository on Quay](https://quay.io/repository/pmav99/grass_docker_src/status "Docker Repository on Quay")](https://quay.io/repository/pmav99/grass_docker_src)

# Usage


Just execute `build.sh` and you will end up in a root console.  There is also a normal user named
`grassuser` who has passwordless suod enabled and also has some sample GRASS locations in his home
directory.

## GUI

In order to be able to run the GUI you need to enable docker to access the host's X server:
```
xhost +local:docker
```

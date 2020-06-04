# Factorio Container

A Docker container for running [Factorio](https://factorio.com) servers.

## Quickstart

* Create a volume
* Run the container with `docker run -p 34197:34197/udp --mount source=[your volume],target=/mnt/factorio factorio-container -h` - This will populate the volume with the neccesary directories
* Copy your save file into the `saves/` directory of the volume
* Ensure the file permissions for the save file allow the container to modify the file ([See Volume Format for details](#volume-format)).
* Start the container with `docker run -p 34197:34197/udp --mount source=[your volume],target=/mnt/factorio factorio-container --whitelist -s [your save file]`

***

## Pre-requisits

**Note:** The container requires a save file be provided for the server to run. It does not support generating the map in the container at this time.

Besides the standard requirements for running a Docker container, this container requires a volume be configured.

The required directories within the volume will automatically be generated by the container during startup in the [entrypoint.py](../blob/master/entrypoint.py) script.

If you wish to configure the directories yourself, you may do so follwing the instructions outlined by [Volume Format](#volume-format).

***

## Usage

Running the container requires two sets of arguments. Those used by docker to run the container, and those used by the container to start the factorio server.

They are combined in the format: `docker run [container arguments] factorio-container [entrypoint arguments]`.

An example of a full command would be:

`docker run -p 34197:34197/udp --mount source=myvol,target=/mnt/factorio factorio-container --whitelist -s mysave.zip`

### Container Arguments

The container itself takes two arguments to run, the port to expose the server on, and the volume to store the files on.

* Port: You'll need to bind `34197/udp` on the container, in most cases you'll wish to do so to the same port on the host (With `-p 34197:34197/udp`), as it's the default port used by Factorio.
* Volume: As discussed the container needs a volume bound to `/mnt/factorio` for config, mod, and save file storage. (Eg. `--mount source=myvol,target=/mnt/factorio`)

### Entrypoint Arguments

The entrypoint takes two more arguments, which are used in starting the factorio server binary.

* -s / --save-file: The name of the save file to use. This file must be stored within the `saves/` directory on the volume. (Eg. `mysave.zip`)
* --whitelist / --no-whitelist: Used to indicate if this should be a server gated with a whitelist of players, or not.

***

## Building

It is possible to build the container from scratch, if you wish to do so. The [Dockerfile](../blob/master/Dockerfile) takes exactly one build argument: `VERSION`. This argument is used to specify which version of Factorio the container should be built for. By default `stable` is used.

See https://factorio.com/download-headless for valid values of this parameter.

Examples:
* `docker build .` - Builds a container for Factorio `stable`
* `docker build --build-arg VERSION=latest .` - Builds a container for Factorio's latest experimental version
* `docker build --build-arg VERSION=0.18.18 .`- Builds a container for Factorio version 0.18.18

***

## Volume Format

The volume must contain the following file tree:

* config
  * map-gen-settings.json
  * map-settings.json
  * server-settings.json
  * server-adminlist.json (Automatically generated when the first player is promoted)
  * server-banlist.json (Automatically generated when the first player is banned)
  * server-whitelist.json (Only used with the `--whitelist` flag)
* mods
  * [any mods you wish to use]
* saves
  * [one or more save files]

All of the directories and files must have read, write, and execute permission for a user with UID 1000, and GID 1000. (This is because the factorio user inside the container needs the ability to interact with these files, without using root permissions)

On a Unix-like system, this can be achieved by running the following commands inside the volume:
```
chown -R 1000:1000 .
chmod -R u+rwx .
```

***

I'd like to thank the [factoriotools team](https://github.com/factoriotools/factorio-docker) for inspiring me to try my hand at containerizing Factorio.

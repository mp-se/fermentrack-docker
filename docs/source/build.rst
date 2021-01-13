Building docker image
---------------------

The docker image can be obtained via docker hub under the name

::

    mpse2/fermentrack-docker

But if you want to build it yourself just clone the git repository and make sure you have docker and optionally docker-compose installed.

A configuration file for docker compose is included in the repository and the easiset way is to invoke this and build for your current platform.

``docker-compose build``

But if you want to build for other architectures you can use buildx for that:

``docker buildx build ./fermentrack --platform linux/amd64``

**Tested platforms are; armv7, i386 amd64** but any platform that is supported by the base image debian:buster should work. 
Installing docker image
-----------------------

Requirements for installation
=============================

Pre-requsities, install the following docker components according to installation instructions for your platform:

* Docker (or DockerDesktop)
* Docker compose

The following target platforms are tested so far; 

* linux/arm64   (Tested on Raspberry PI)
* linux/amd64   (Tested on Ubuntu)

Access rights to mounted volumes
================================

Since the container is built to run fermentrack and web server as non root there could be issues with mounted volume if the permissions are not correct.

On a linux bases system the access rights are determined by the UID of the user running the process and fermentrack is using UID 2001 (user) and GID 2000 (group). 
So a user with the same UID on the host system will need to have R+W access rights on the host for the mounted volume in order for access to work.

Indications that the is insufficent access rights can be 403 errors from the web gui, graphs not showing up on active fermentations etc. 

To check the access rights you will need to execute a few linux commands from within the container via a bash shell. This may differ depending on your docker host. From a linux 
commandline this will attach to a running container and start a shell.

``docker exec -it fermentrack /bin/bash``

To check the permissions run these commands:

``ls -al /app``

Check the permission on the folder called data.

You can also check the permissions of the files in the data directory

``ls -al /app/data``

This is the way it should look.

``drwxrwxrwx 31 django django 4096 Jun 8 01:16``

This is an indication that permissions are insufficent.

``drwx--x--x 31 django django 4096 Jun 8 01:16``

Installation via docker-compose
===============================

To install and start the docker image via docker-compose you need to create a .yaml file that contains the right configuration for your system; 

It's important to update the volume part (full or relative) for the 3 volumes that will be mapped into the container;

* /app/db      (contains the database file)
* /app/data    (contains beer logs)
* /app/log     (contains logfiles from system)

For some functions to work it's needed to run the container in priviliged mode and network_mode=host. This also means that the port mapping 
will be ignored and fermentrack will be accessed on port 8080 which is the default port used in the image.  This applies to the following functions:

* Update firmware on brewpi controllers via USB
* Connect a tilt via Bluetooth
* Use MDNS functionallity

::

    version: '3'
    services:
    fermentrack:
        image: mpse2/fermentrack-docker
        container_name: fermentrack
        restart: always
        network_mode: "host"
        privileged: true
        volumes:
            - ./db:/app/db
            - ./data:/app/data
            - ./log:/app/log
            - /dev:/dev


If you dont need the functionallity described above use the following configuration.

::

    version: '3'
    services:
    fermentrack:
        image: mpse2/fermentrack-docker
        container_name: fermentrack
        restart: always
        ports:
        - "80:80"
        volumes:
            - ./db:/app/db
            - ./data:/app/data
            - ./log:/app/log


The following commands will download the image and then start the container. The yaml file needs to be in the current directory.

Download image:

``docker-compose pull``

Start container:

``docker-compose up``

Stop container:

``docker-compose down``

If everything is working as planned you should see a similar startup screen like this. The last line (Starting circus deamon) indicate that everything has started as it should.

::

    TODO, this needs to be updated.

Things to consider when running in privliged mode
=================================================

Some functions require the container to be run in privliged mode mainly to access resouces of the host system. This include Bluetooth and USB devices.

If the system is run in priviliged mode using the host network the following network ports needs to be available for the container to start;

* 80 webserver 
* 8123 django server
* 6379 redis server

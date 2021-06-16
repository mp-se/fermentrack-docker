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

``ls -al /home/fermentrack/fermentrack/``

Check the permission on the folder called data.

You can also check the permissions of the files in the data directory

``ls -al /home/fermentrack/fermentrack/data``

This is the way it should look.

``drwxrwxrwx 31 fermentrack fermentrack 4096 Jun 8 01:16``

This is an indication that permissions are insufficent.

``drwx--x--x 31 fermentrack fermentrack 4096 Jun 8 01:16``

Installation via docker-compose
===============================

To install and start the docker image via docker-compose you need to create a .yaml file that contains the right configuration for your system; 

It's important to update the volume part (full or relative) for the 3 volumes that will be mapped into the container;

* /home/fermentrack/fermentrack/db      (contains the database file)
* /home/fermentrack/fermentrack/data    (contains beer logs)
* /home/fermentrack/fermentrack/log     (contains logfiles from system)

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
            - ./db:/home/fermentrack/fermentrack/db
            - ./data:/home/fermentrack/fermentrack/data
            - ./log:/home/fermentrack/fermentrack/log
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
        - "80:8080"
        volumes:
            - ./db:/home/fermentrack/fermentrack/db
            - ./data:/home/fermentrack/fermentrack/data
            - ./log:/home/fermentrack/fermentrack/log


The following commands will download the image and then start the container. The yaml file needs to be in the current directory.

Download image:

``docker-compose pull``

Start container:

``docker-compose up``

Stop container:

``docker-compose down``

If everything is working as planned you should see a similar startup screen like this. The last line (Starting circus deamon) indicate that everything has started as it should.

::

    fermentrack    | Checking if all required volumes are mounted correctly
    fermentrack    | Volume for data and database are mounted. 
    fermentrack    | Copying secret settings from db folder to image
    fermentrack    | Setting correct access rights on mounted volumes
    fermentrack    | Version of main linux packages installed in image:
    fermentrack    | ****************************************************************
    fermentrack    | Debian GNU/Linux 10 \n \l
    fermentrack    | 
    fermentrack    | nginx version: nginx/1.14.2
    fermentrack    | Redis server v=5.0.3 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=1b271fe49834c463
    fermentrack    | Python 3.7.3
    fermentrack    | Image build date: 
    fermentrack    | Wed Jan 13 16:00:50 UTC 2021
    fermentrack    | Starting NGINX
    fermentrack    | Starting REDIS
    fermentrack    | nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:1
    fermentrack    | Checking if the container is running in priviliged mode
    fermentrack    | /home/fermentrack/entrypoint.sh: line 71: /home/fermentrack/venv/bin/python3: Operation not permitted
    fermentrack    | Container is NOT running in priviligied mode
    fermentrack    | Starting Fermentrack
    fermentrack    | Collecting static files
    fermentrack    | 
    fermentrack    | 0 static files copied to '/home/fermentrack/fermentrack/collected_static', 269 unmodified.
    fermentrack    | Applying database migration
    fermentrack    | Operations to perform:
    fermentrack    |   Apply all migrations: admin, app, auth, contenttypes, database, external_push, firmware_flash, gravity, sessions
    fermentrack    | Running migrations:
    fermentrack    |   No migrations to apply.
    fermentrack    | Version/Source of fermentrack installed in image:
    fermentrack    | ****************************************************************
    fermentrack    | origin	https://github.com/thorrak/fermentrack.git (fetch)
    fermentrack    | origin	https://github.com/thorrak/fermentrack.git (push)
    fermentrack    | 
    fermentrack    | commit b4e73786803e94eda4f0a2794d1e8ed8815fe933
    fermentrack    | Merge: 3f6a8a1 d592658
    fermentrack    | Author: John <thorrak@users.noreply.github.com>
    fermentrack    | 
    fermentrack    |     Tilt Pro Support (and other things)
    fermentrack    | ****************************************************************
    fermentrack    | Starting circus deamon

Things to consider when running in privliged mode
=================================================

Some functions require the container to be run in privliged mode mainly to access resouces of the host system. This include Bluetooth and USB devices.

If the system is run in priviliged mode using the host network the following network ports needs to be available for the container to start;

* 8080 webserver 
* 8123 django server
* 6379 redis server

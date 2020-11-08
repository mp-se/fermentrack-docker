# Fermentrack Docker Image

If you want to know more about Fermentrack please go to [https://docs.fermentrack.com/](https://docs.fermentrack.com/).

NOTE! This is still under testing/development and might not work as expected. 

In the future the version tag will be used to track the base installation, linux version, nginx, redis python etc. There will most likley be a new build every 3-6 months to include new security fixes.

- v0.1.0 = fermentrack release 4d8d89b from 22 Aug 2020 (testing)
- v0.2.0 = fermentrack release 4d8d89b from 22 Aug 2020 but with additional code to disable git integration (not to break the installation)
- v0.3.0 = fermentrack release 99495bf from 7 Nov 2020, most functions should work now

## Single docker-image for Fermentrack (non-offical)

I wanted to move my installation to a normal x86 server in order to improve my possibilities to make backup of the database and brew logs. I have had one to many crashes where I lost most of the data. Since I have added some code to hide the git options I'm using my development branch of fermentrack to create this image. 

There is an official version of docker for fermentrack on the way but that takes a differnt approach than this one. The offical will be based on docker-compose and use multiple containers. My approach uses a single container since I dont have docker-compose support on my NAS which i use to runt the container. 

So I belive that there will be a need for both options based on what docker support your server/nas/workstation has. My intention is to keep this updated and as close to the offical docker installation as possible. I'm also one of the contributors to fermentrack.

**The target for this image is a standard x86 linux host (not raspberry pi)**

I looked at a few docker images for fermentrack (available on docker hub) but they where quite crude and just ran the installation scripts and most of them would not build. My approach was to base it on the manual installation steps I use for setting up the development environment. I have tried to mimic the normal installation procedure with a few exceptions in order to have a better fit towards docker. This is however my first attempt to create a docker build process so there are probably several improvements to be made.

I have modified the standard installation in the following way: 

- Database file (db.sqlite3) is moved to a subdirectory called db in order to have a volume mount point (this is done since docker is not really good at handling a single file outside the container)
- Redis and Nginx will run as non root user for increased security. Port 8080 will be exposed inside the container since ports below 1024 requires root access. This is not a problem since we can expose any port outside the container. 
- Most functions in fermentrack should work, including GIT upgrades. There are a few things that will need to be tested in relation to serial/bluetooth configuration that will require more changes to in the docker container.
- Validations have been added to check that data and db directories are mounted, otherwise it will not start. 
- Access righs on mounted volumes as well as database migrations are done before fermentrack starts.
- During startup you can also see what git repo is used as source as well as the latest version tag. 

The following functions are not yet tested (but should work if the USB devices are exported into the container);

- Flashing firmware via USB/Serial
- TILT / Bluetooth support (I dont own a tilt)

## Installation

You can download the docker image from here .... Docker Hub under mpse2/fermentrack-docker

The following VOLUMES should be mounted for the container;

* - YOUR PATH:/home/fermentrack/fermentrack/data
* - YOUR PATH:/home/fermentrack/fermentrack/log
* - YOUR PATH:/home/fermentrack/fermentrack/db

The follwoing PORTS should be mapped for the container;

* YOUR PORT:8080

Any suggestions on improvements are welcome, and please note that this is not tested enough to ensure stability, please backup your data files before testing. I take no responsibility for lost data. The project is made available as is. 

Good luck!

## Troubleshooting

See Issues on github for known problems and options.

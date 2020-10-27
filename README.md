# Fermentrack Docker Image

If you want to know more about Fermentrack please go to [https://docs.fermentrack.com/](https://docs.fermentrack.com/).

## My first attempt to create a dockerfile for Fermentrack

I wanted to move my installation to a normal x86 server in order to improve my possibilities to make backup of the database and brew logs. I have had one to many crashes where I most most of the data. 

**The target for this image is a standard x86 linux host (not raspberry pi)**

I looked at a few docker images for fermentrack but they where quite crude and just ran the installation scripts. My approach was to base it on the manual installation steps I use for setting up the development environment. I have tried to mimic the normal installation procedure with a few exceptions in order to have a better fit towards docker. This is however my first attempt to create a docker build process so there are probably several improvements to be made.

I have modified the standard installation in the following ways;

* No virtual environment is created, but I use the same mount point to reduce changes to the fermentrack installation
* Database file (db.sqlite3) is moved to a subdirectory called db in order to have a volume mount point (this is done since docker is not really good at handling a single file outside the container)
* I'm not using cron to manage the circus jobs, instead this is moved to the supervisor process
* At startup the migration job is run once to make sure the database is updated correctly. This should make it smooth to upgrade to a new version that require schema changes

I plan to make the following changes to the installation in order to make it more smooth;

* Disable the git update pages (for now just choose to ignore new versions)
* Disable the command to upgrade python (should not be needed since this is part of the docker build process)

The following functions are not yet tested (but should work if the USB devices are exported into the container);

* Flashing firmware via USB/Serial
* TILT / Bluetooth support (I dont own a tilt)

## Installation

You can download the docker image from here .... < ADD URL >

The following VOLUMES should be mounted for the container;

* - <YOUR PATH>:/home/fermentrack/fermentrack/data
* - <YOUR PATH>:/home/fermentrack/fermentrack/log
* - <YOUR PATH>:/home/fermentrack/fermentrack/db

The follwoing PORTS should be mapped for the container;

* <YOUR PORT>:80

Any suggestions on improvements are welcome, and please note that this is not tested enough to ensure stability, please backup your data files before testing. I take no responsibility for lost data. The project is made available as is. 

Good luck! /Magnus
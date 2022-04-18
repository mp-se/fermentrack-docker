Changes towards the standard installation
-----------------------------------------

I have modified the standard installation in the following way: 

- Based on dockerfile for django (from standard fermentrack)
- Added ngnix and redis to django image
- Modified startup script to set environment variables
- Added supervisor to manage starting the needed processes
- Volumes log, db and data can be mounted

- Most functions in fermentrack should work, including GIT upgrades. 
- Serial connections will only work if docker is running on a linux host and the container is running in privliged mode.
- Access rights on mounted volumes as well as database migrations are done before fermentrack starts at startup.
- During startup you can also see what git repo is used as source, linux kernel, nginx and redis versions and when docker image was built. 
- The startup will automatically detect if the container is running in priviliged mode and set the capabilities accordingly.

The following are planned changes to be implemented

- Options to set the port number for web server
- Ability to configure and use an existing postgres database

Changes towards the standard installation
-----------------------------------------

I have modified the standard installation in the following way: 

- Database file (db.sqlite3) is moved to a subdirectory called /home/fermentrack/fermetrack/db in order to have a volume mount point (this is done since docker is not really good at handling a single file outside the container) which would be the case if the database file wasnt moved. 

- The django file secretsetings.py will now be copied from the mounted db directory into the container at start so that you can keep your own key. If it does not exist, one will be created for you. So dont delete it.

- Redis and Nginx will run as non root user for increased security. Port 8080 will be exposed inside the container since ports below 1024 requires root access. This is not a problem since we can transform that to any port outside the container. 

- Most functions in fermentrack should work, including GIT upgrades. 

- Serial connections will only work if docker is running on a linux host and the container is running in privliged mode.

- Validations have been added to check that data and db directories are mounted, otherwise it will not start. 

- Access rights on mounted volumes as well as database migrations are done before fermentrack starts at startup.

- During startup you can also see what git repo is used as source, linux kernel, nginx and redis versions and when docker image was built. 

- The startup will automatically detect if the container is running in priviliged mode and set the capabilities accordingly.
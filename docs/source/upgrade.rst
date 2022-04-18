Upgrading from v1.x
-------------------

Volumes
=======

The internal structure of the docker image has changes and so also the mount point.

/home/fermentrack/fermentrack/db is now /app/db
/home/fermentrack/fermentrack/data is now /app/data
/home/fermentrack/fermentrack/log is now /app/log

None of these are now mandatory, the reason is that there is now a built in backup function in fermentrack that allows you to 
export data from the image.

Django secret key
=================

This option is now set in the environment variables. In the older versions this was found in a pythin script in the db directory. 

Default http port
=================

This is changed from 8080 to 80 since this is now the default port in the fermentrack docker setup.

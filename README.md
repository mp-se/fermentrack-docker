# Fermentrack Docker Image

If you want to know more about Fermentrack please go to https://docs.fermentrack.com/.

This is the v2.x version of the image. Since fermentrack is moving to a full docker setup I have chosen to rewrite this and reuse as much as possible from the standard setup. The intention is to keep this as a "all-in-one" package as much as possible and  include; django, nginx and redis in the same image. It will support either a sqlite database or a full postgres install just as the standard fermentrack (assume you have a postgres installation already). It will also be possible to run this on multiple devices in both priviliged and unprivliged mode for maximum compatibility. 

if you have issues, please report them here; https://github.com/mp-se/fermentrack-docker/issues

Please note that the configuration options for v2.x is different from v1.x and not longer compatible so check the setup instructions. This is due to the internal file system structure of the base fermentrack install. 

*If you have an older version installed the DJANGO_SECRET_KEY can be found in the db directory in the file secretsetting.py*

The following environment variables exist:

- DJANGO_SECRET_KEY=*django secret key*
- POSTGRES_HOST=*ip or dns name (mandatory)*
- POSTGRES_PORT=*5434 (optional, deafult value)*
- POSTGRES_DB=*fermentrack (optional, default value)*
- POSTGRES_USER=*fermentrack (optional, default value)*
- POSTGRES_PASSWORD=*password (mandatory)*

Volumes mount options (all are optional):

- ./volumes/db:/app/db
- ./volumes/data:/app/data
- ./volumes/log:/app/log

## Documentation

Documentation has now been moved to the docs folder of the repository, here you can find the history and instructions for build and installation.

Any suggestions on improvements are welcome. Pplease backup your data files before testing. I take no responsibility for lost data. The project is made available as is. 

You can also read the documentation online at; https://fermentrack-docker.readthedocs.io/

# Release history

### v2.0.0 Migrated to using fermentrack docker base. 

- Release bases on fermentrack built in docker support. Hopefully easier to maintain.
- Combines the django, redis and nginx containers into one image. 
- Use sqlite database as default.
- Will work on most platforms with minium configuration settings.

## Troubleshooting

See Issues on github for known problems and options.
# Fermentrack Docker Image

If you want to know more about Fermentrack please go to https://docs.fermentrack.com/.

In the future the version tag will be used to track the base installation, linux version, nginx, redis python etc. There will most likley be a new build every 3-6 months to include new security fixes from the core components. But you can always fork the repository and do your own build if you want. 

```
Note! Older images are no longer compatible with Fermentrack releases after 5 April 2021. Use image v0.8 or higher
```

These are the builds that have been released so far.

Newer versions have switched to debian and is now support more targets i386/amd64/arm64

### v0.9.0 Updated to work with fermentrack docker structure. 
- Match environment settings with standard docker setup.
- Updated installation for python using fermentrack user (should work better with python upgrades)

### v0.8.0 Updated to work with fermentrack release from 5 Apr 2021. 
- New path to static django files
- New file for python requirements
- Running in docker mode now uses /app for launching background tasks

### v0.7.0
- added script for debugging tilt connections 
- healthcheck for nginx/redis/django

These versions only exist for amd64 target and are based on ubuntu stable release

- v0.6.0 = fermentrack release b4e7378 from 19 Dec 2020, tested bluetooth and firmware update
- v0.5.0 = fermentrack release b4e7378 from 19 Dec 2020, tested bluetooth and firmware update
- v0.4.0 = fermentrack release 3f6a8a1 from 11 Nov 2020, locked version of numpy since the latest version gave wrong result in gravity calculation
- v0.3.0 = fermentrack release 99495bf from 7 Nov 2020, most functions should work now (bluetooth is still not verified)
- v0.2.0 = fermentrack release 4d8d89b from 22 Aug 2020 but with additional code to disable git integration (not to break the installation)
- v0.1.0 = fermentrack release 4d8d89b from 22 Aug 2020 (testing)

## Documentation

Documentation has now been moved to the docs folder of the repository, here you can find the history and instructions for build and installation.

Any suggestions on improvements are welcome. Pplease backup your data files before testing. I take no responsibility for lost data. The project is made available as is. 

You can also read the documentation online at; https://fermentrack-docker.readthedocs.io/

Good luck!

## Troubleshooting

See Issues on github for known problems and options.

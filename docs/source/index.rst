.. Fermentack-docker documentation master file, created by
   sphinx-quickstart on Wed Jan 13 12:32:44 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Fermentack-docker's documentation!
=============================================

*This documentation now reflects the v2.x version of the image.*

This is a single docker image based on the project Fermentrack (https://github.com/thorrak/fermentrack).

Fermentrack is a web interface for controlling and monitoring fermentation temperature and progress. It interfaces with
BrewPi controllers as well as specific gravity sensors like the Tilt and iSpindel in order to help you make better beer.

There is a official docker releasewhich consists of several docker images (fermentrack/app, postgress/db, redis, nginx/web). 
But in order to handle that you need a platform that supports the docker-compose add-on. 

This project takes a diffrent approach and package everything into one single image that can be run on any platform that just have the base docker 
deamon installed, for example, I run this on my Synology NAS which works fine.

You also have an option to run this in non-privliged mode which increases security (but you will loose some functionallity).

I started this project since I wanted a more stable platform than my Raspberry pi (SD cards are not the most stable media) and after loosing my 
data a couple of times I decided to start this project.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   installation
   upgrade
   build
   about 
   troubleshooting
   
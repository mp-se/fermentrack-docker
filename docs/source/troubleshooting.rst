Troubleshooting
---------------------

This section contains some hints that are useful to find various issues witht he installation.

Bluetooth/Tilt
=====================

TODO! This chapter needs to be revised!

These issues can be hard to troubleshoot. First make sure you have the right permissions in order for this to work.

Included in the repostory (and docker image) there is a simple python script that can find data transmitted from a Tilt (or simulator). 
It's located under the fermentrack folder in the repository and in the home directory in the docker image.

First run the script on the host computer to check that this is detecting the tilt broadcasts.

::

    virtualenv env
    source env/bin/activate
    pip install requests PyBluez beacontools beaconscanner
    python tiltview.py

If messages are detected you should see the color, gravity and temperature.

If that is working then start the container and run the command from within the container.

::

    docker exec -it fermentrack /bin/bash
    python tiltview.py


If you can see the messages it should also work form fermentrack. 
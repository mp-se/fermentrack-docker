Troubleshooting
---------------------

This section contains some hints that are useful to find various issues witht he installation.

Bluetooth/Tilt
=====================

These issues can be hard to troubleshoot. First make sure you have the right permissions in order for this to work.

Included in the repostory (and docker image) there is a simple python script that can find data transmitted from a Tilt (or simulator). 
It's located under / folder in the repository and in the home directory in the docker image.

To run that script in the container do the followin; 

::

    docker exec -it fermentrack /bin/bash
    pip install requests PyBluez beacontools beaconscanner
    python /tiltview.py


If you can see the messages it should also work in fermentrack. 

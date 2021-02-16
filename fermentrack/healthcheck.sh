#!/bin/bash
set -e

# Test #1, check if deamon circusd is running. This should always be ok. All of the fermentrack processes are
# attached to this one and Circus is restarting them if they fail/crash. 
if ps -a | grep circusd > /dev/null
then
	echo "Circusd is running"
else
	echo "Error: Circusd is not running"
	exit 1
fi

# Test #2 Try to reach the django application. A ok response should indicate that its running
STATUSCODE=$(curl --silent --output /dev/null --write-out "%{http_code}" http://localhost:8080/)
#STATUSCODE=$(curl --silent --output /dev/null --write-out "%{http_code}" http://loclhost:8123/site/help)
#echo $STATUSCODE

if test $STATUSCODE -ne 200
then
	echo "Error: Site is not responding with 200"
	exit 1
else
	echo "Site is responding"
fi

# Test #3 Checking that redis is responding as it should. 

# TODO

exit 0
#!/bin/bash
set -e

# Test #1 Try to reach the django application. A ok response should indicate that its running
set +e
STATUSCODE=$(curl --silent --output /dev/null --write-out "%{http_code}" http://localhost:8080/)
#echo "Ngnix + Django is reporting $STATUSCODE"
set -e

if test $STATUSCODE -ne 200
then
        echo "Error: Site is not responding with 200"
        exit 1
else
        echo "Site is responding"
fi

# Test #2 Checking that redis is responding as it should. 
set +e
STATUSCODE=$(redis-cli ping)
#echo "Redis reporting $STATUSCODE"
set -e

if [ "$STATUSCODE" != "PONG" ]
then
        echo "Error: Redis is not responding"
        exit 1
else
        echo "Redis is responding"
fi

exit 0

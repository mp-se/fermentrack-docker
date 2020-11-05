#!/bin/bash
set -e

#
# Check if we have mounted all needed volume
#
echo "Checking if all required volumes are mounted correctly"
if [ -d /home/fermentrack/fermentrack/data ] && [ -d /home/fermentrack/fermentrack/db ]
then
    echo "Volume for data and database are mounted. "
else
    echo "Volume for data and/or database is NOT mounted. Aborting startup since data will not be persistent."
    sleep 60
    exit -1
fi

#
# Secure that access rights for all mounted volumes are correct
#
echo "Setting correct access rights on mounted volumes"
chown -R fermentrack:fermentrack /home/fermentrack/fermentrack/db
chown -R fermentrack:fermentrack /home/fermentrack/fermentrack/data
chown -R fermentrack:fermentrack /home/fermentrack/fermentrack/log

#
# Start NGINX
#
# TODO: Run as non root
#
echo "Starting NGINX"
/usr/sbin/nginx -g "daemon off;" &

#
# Start REDIS
#
# TODO: Run as non root
#
echo "Starting REDIS"
redis-server > /dev/null &

#
# Start fermentrack, running as fermentrack user
#
echo "Starting Fermentrack"
sudo -u fermentrack /bin/bash <<EOF
export DOCKER=yes
export USE_DOCKER=true
cd /home/fermentrack/fermentrack
source /home/fermentrack/venv/bin/activate
#
echo "Collecting static files"
python manage.py collectstatic --noinput 
echo "Applying database migration"
python manage.py migrate --noinput
#
echo "Version/Source of fermentrack installed in image:"
echo "****************************************************************"
git remote -v
echo ""
git log -n 1
echo "****************************************************************"
circusd circus.ini
EOF

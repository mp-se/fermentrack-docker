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

if [ -f /home/fermentrack/fermentrack/db/secretsettings.py ]
then
    echo "Copying secret settings from db folder to image"
    cp /home/fermentrack/fermentrack/db/secretsettings.py /home/fermentrack/fermentrack/fermentrack_django/secretsettings.py
elif [ ! -f /home/fermentrack/fermentrack/fermentrack_django/secretsettings.py ]
then
    echo "No secret file found, creating one"
    sudo -u fermentrack /home/fermentrack/fermentrack/utils/make_secretsettings.sh
    echo "Saving copy of secretsfile to db folder"
    cp /home/fermentrack/fermentrack/fermentrack_django/secretsettings.py /home/fermentrack/fermentrack/db/secretsettings.py
fi

#
# Secure that access rights for all mounted volumes are correct
#
echo "Setting correct access rights on mounted volumes"
chown -R fermentrack:fermentrack /home/fermentrack/fermentrack/db
chown -R fermentrack:fermentrack /home/fermentrack/fermentrack/data
chown -R fermentrack:fermentrack /home/fermentrack/fermentrack/log

#
# Print image version
#
echo "Version of main linux packages installed in image:"
echo "****************************************************************"
cat /etc/issue
/usr/sbin/nginx -v
redis-server -v
python -V
echo "Image build date: "
cat /home/fermentrack/build_info

#
# Start NGINX
#
echo "Starting NGINX"
sudo -u nginx /bin/bash <<EOF
/usr/sbin/nginx -g "daemon off;" &
EOF

#
# Start REDIS
#
echo "Starting REDIS"
sudo -u redis /bin/bash <<EOF
cd /var/lib/redis
redis-server > /dev/null &
EOF

#
# Setting priviligies required for bluetooth support. If we cannot start python we are not running in priviligied mode.
#
echo "Checking if the container is running in priviliged mode"
setcap cap_net_raw,cap_net_admin+eip /usr/bin/python3.8
if python3 -h > /dev/null;
then
    echo "Container is running in priviligied mode"
else 
    echo "Container is NOT running in priviligied mode"
    # We need to remove the setcap options or python will fail to start fermentrack
    setcap -r /usr/bin/python3.8
fi

#
# Start fermentrack, running as fermentrack user
#
echo "Starting Fermentrack"
sudo -u fermentrack /bin/bash <<EOF
export USE_DOCKER=true
cd /home/fermentrack/fermentrack
source /home/fermentrack/venv/bin/activate
export PYTHONPATH=":;/home/fermentrack/fermentrack;/home/fermentrack/venv/bin;/home/fermentrack/venv/lib/python3.8/site-packages"

echo "Collecting static files"
python manage.py collectstatic --noinput 
echo "Applying database migration"
python manage.py migrate --noinput

echo "Version/Source of fermentrack installed in image:"
echo "****************************************************************"
git remote -v
echo ""
git log -n 1 --pretty=short
echo "****************************************************************"

echo "Starting circus deamon"
circusd circus.ini
EOF

#
# Dockerfile for Fermentrack image
#
FROM ubuntu:groovy
EXPOSE 8080/tcp
#
# Install the needed dependecies, some are only used at the installphase so those will be removed later.
#
RUN apt-get update && apt-get install --no-install-recommends -y \
  nginx \
  redis-server \
  python3 \
  python3-pip \
  python3-dev \
  python3-venv \
  python3-zmq \
  python3-scipy \
  python3-numpy \
  libbluetooth-dev \
  bluez \
  libcap2-bin\
  libbluetooth3 \
  ca-certificates \
  build-essential \
  git-core \
  avrdude \
  nano \
  sudo 
#
# Create the users, group and directories for git. Its needed for fermentrack to work correcly
#
RUN groupadd -g 2000 fermentrack && useradd -m -u 2001 -g fermentrack fermentrack
RUN groupadd -g 2002 nginx && useradd --system -M -u 2003 -g nginx nginx -s /usr/sbin/nologin
#
# Install fermentrack, just make a copy of git and we will handle the run commands in the supervisor
#
WORKDIR /home/fermentrack
USER fermentrack:fermentrack
#
# Use this for using the master branch from thorrak (beware that running git update from the repository will break the installation)
RUN git clone https://github.com/thorrak/fermentrack.git /home/fermentrack/fermentrack
#
# Setup python and install the packages
#
USER root
WORKDIR /home/fermentrack
RUN pip install virtualenv
RUN virtualenv venv
ENV VIRTUAL_ENV="/home/fermentrack/venv"
ENV PATH="/home/fermentrack/venv/bin:/usr/bin:/usr/sbin"
RUN pip install --no-cache-dir -r /home/fermentrack/fermentrack/requirements.txt
#
# Setup nginx and update config to point towards fermentrack. 
#
USER root
COPY default-fermentrack /etc/nginx/sites-available/default-fermentrack
RUN rm -f /etc/nginx/sites-enabled/default
RUN ln -sf /etc/nginx/sites-available/default-fermentrack /etc/nginx/sites-enabled/default-fermentrack
RUN chown -R nginx:nginx /var/log/nginx
RUN chown -R nginx:nginx /var/lib/nginx
RUN touch /run/nginx.pid
RUN chown nginx:nginx /run/nginx.pid
#
# Setup the startup scripts and configure webservers
#
USER root
COPY entrypoint.sh /home/fermentrack/entrypoint.sh
RUN chmod 700 /home/fermentrack/entrypoint.sh
RUN rm -fR /home/fermentrack/fermentrack/data
#
# Start the supervisor
#
WORKDIR /home/fermentrack
USER root
RUN date >> /home/fermentrack/build_info
ENTRYPOINT ["/home/fermentrack/entrypoint.sh"]
CMD [""]
# EOF
#
# Dockerfile for Fermentrack image, this version can be generated for both amd64/i386/armv7
#
FROM debian:buster-slim
EXPOSE 8080/tcp
#
# Install the needed dependecies, some are only used at the installphase so those will be removed later.
#
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
  nginx \
  redis-server \
  python3.7 \
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
  sudo \
  libffi-dev \
  libssl-dev \
  libcap2-bin \
  curl \
# For debugging
# procps
# net-tools
  nano \
  usbutils
#
# Create the users, group and directories for git. Its needed for fermentrack to work correcly.
# User fermentrack is added to the dialout group on order to have access to firmware flashing when running as non root. 
#
RUN groupadd -g 2000 fermentrack && useradd -m -u 2001 -g fermentrack fermentrack
RUN groupadd -g 2002 nginx && useradd --system -M -u 2003 -g nginx nginx -s /usr/sbin/nologin
RUN usermod -a -G dialout fermentrack
#
# Install fermentrack, just make a copy of git and we will handle the run commands in the supervisor
#
WORKDIR /home/fermentrack
USER fermentrack:fermentrack
#
# Clone the master branch of fermentrack into the image (updates will work afterwards)
#
RUN git clone https://github.com/thorrak/fermentrack.git /home/fermentrack/fermentrack
#
# Setup python and install the packages
#
USER root
WORKDIR /home/fermentrack
# With the introduction of docker it uses /app for launching processes
RUN ln -s /home/fermentrack/fermentrack /app
RUN pip3 install --upgrade pip
RUN pip3 install virtualenv
RUN virtualenv venv
ENV VIRTUAL_ENV="/home/fermentrack/venv"
ENV PATH="/home/fermentrack/venv/bin:/usr/bin:/usr/sbin:/bin:/sbin"
ENV PYTHONPATH=":;/home/fermentrack/fermentrack;/home/fermentrack/venv/bin;/home/fermentrack/venv/lib/python3.8/site-packages"
ENV USE_DOCKER=true
RUN pip3 install --no-binary numpy numpy==1.18.4
RUN pip3 install --no-binary pyzmq pyzmq==19.0.1
RUN pip3 install circus
RUN pip3 install --no-cache-dir -r /home/fermentrack/fermentrack/requirements/base.txt
RUN chown -R fermentrack:fermentrack /home/fermentrack/venv
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
# Setup healtcheck
#
USER root
COPY healthcheck.sh /home/fermentrack/healthcheck.sh
RUN chmod 700 /home/fermentrack/healthcheck.sh
HEALTHCHECK --interval=60s --timeout=10s --retries=3 CMD /home/fermentrack/healthcheck.sh
#
# Copy scripts for debugging (tilt)
#
USER root
COPY tiltview.py /home/fermentrack/tiltview.py
RUN pip3 install beacontools beaconscanner
#
# Start the supervisor
#
WORKDIR /home/fermentrack
USER root
RUN date >> /home/fermentrack/build_info
ENTRYPOINT ["/home/fermentrack/entrypoint.sh"]
CMD [""]
# EOF
# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Saturnino Adrales <ado@creativegeek.jp>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs apache2 mysql-server mysql-client php5 php5-mysql

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs
    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Update cloud9
RUN git -C /cloud9 pull origin master
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# Add supervisord conf
ADD conf/cloud9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# Install unzip, zip, wget, nano, php5-curl
RUN apt-get install -y zip unzip nano wget php5-curl

# Change apache port
RUN sed -i -e 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#for cake, remember to install php5-intl
# Install wordpress
RUN wget -O /var/www/latest.zip https://ja.wordpress.org/wordpress-4.4.2-ja.zip
RUN unzip -o /var/www/latest.zip -d /var/www/
RUN rm -fr /var/www/latest.zip
RUN sed -i -e 's>DocumentRoot /var/www/html>DocumentRoot /var/www/wordpress/>g' /etc/apache2/sites-available/*
RUN sed -i -e 's/<VirtualHost \*:80>/<VirtualHost *:8080>/g' /etc/apache2/sites-available/000-default.conf
RUN ln -s /var/www /workspace
# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

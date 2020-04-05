# Mapserver for Docker
FROM osgeo/gdal:ubuntu-small-latest

MAINTAINER Admire Nyakudya<admire@kartoza.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get clean && apt-get update && apt-get install -y locales
ENV LANG C.UTF-8
RUN update-locale LANG=C.UTF-8

RUN set -e \
    export DEBIAN_FRONTEND=noninteractive \
    dpkg-divert --local --rename --add /sbin/initctl \
    && (echo "Yes, do as I say!" | apt-get remove --force-yes login) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update and upgrade system
RUN apt-get -qq update --fix-missing && apt-get -qq --yes upgrade

#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

#-------------Application Specific Stuff ----------------------------------------------------

# Install mapcache compilation prerequisites
RUN apt-get install -y software-properties-common g++ make cmake wget git  bzip2 apache2 apache2-dev \
build-essential  curl openssl autoconf gtk-doc-tools libc-ares-dev libc-ares-dev libpdf-api2-perl python3-pip \
swig protobuf-compiler


RUN add-apt-repository -y ppa:ondrej/php
RUN  apt-get update; apt install -y php7.3 php7.3-common php7.3-opcache php7.3-cli php7.3-gd php7.3-curl php7.3-fpm \
libapache2-mod-php7.3   php7.3-fpm php php7.3-dev

# Install mapcache dependencies provided by Ubuntu repositories
RUN apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    libproj-dev \
    libfribidi-dev \
    libcairo2-dev \
    librsvg2-dev \
    libmysqlclient-dev \
    libpq-dev \
    libcurl4-gnutls-dev \
    libexempi-dev \
    libgdal-dev \
    libfcgi-dev \
    libpsl-dev \
    libharfbuzz-dev \
    libexempi-dev \
    libgif-dev \
    libfcgi-dev \
    libjpeg62-dev \
    libproj-dev

#RUN apt -y install libboost-tools-dev libboost-thread1.62-dev magics++
ADD resources /tmp/resources

ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh



# Configure localhost in Apache
RUN cp  /tmp/resources/000-default.conf /etc/apache2/sites-available/

# To be able to install libapache.





# Apache configuration for PHP-FPM
RUN cp /tmp/resources/php5-fpm.conf /etc/apache2/conf-available/

# Enable these Apache modules
RUN  a2enmod actions  alias  proxy_fcgi setenvif
RUN a2enconf php7.3-fpm

RUN service apache2 restart

# Link to cgi-bin executable
RUN chmod o+x /usr/local/bin/mapserv
RUN ln -s /usr/local/bin/mapserv /usr/lib/cgi-bin/mapserv
RUN chmod 755 /usr/lib/cgi-bin

EXPOSE  80

ENV HOST_IP `ifconfig | grep inet | grep Mask:255.255.255.0 | cut -d ' ' -f 12 | cut -d ':' -f 2`
RUN rm -r /tmp/resources

CMD apachectl -D FOREGROUND

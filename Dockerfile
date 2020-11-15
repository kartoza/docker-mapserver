# Mapserver for Docker
FROM ubuntu:focal
#If you change ubuntu version, don't forget to change 3 echo lines 
MAINTAINER Admire Nyakudya<admire@kartoza.com>

ENV LANG C.UTF-8

# Update and upgrade system
RUN apt-get -qq update --fix-missing && apt-get -qq --yes upgrade


#-------------Application Specific Stuff ----------------------------------------------------

# Install mapcache compilation prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common g++ make \
cmake wget git  bzip2 apache2 curl apache2-dev \
build-essential   openssl autoconf gtk-doc-tools libc-ares-dev libc-ares-dev libpdf-api2-perl python3-pip \
swig protobuf-compiler python-setuptools libprotobuf-c-dev protobuf-c-compiler libcurl4

# Install mapcache dependencies provided by Ubuntu repositories
RUN apt-get install -y --fix-missing --no-install-recommends \
    libxml2-dev \
    libxslt1-dev \
    libfribidi-dev \
    libcairo2-dev \
    librsvg2-dev \
    libmysqlclient-dev \
    libpq-dev \
    libcurl4-gnutls-dev \
    libexempi-dev \
    libfcgi-dev \
    libpsl-dev \
    libharfbuzz-dev \
    libexempi-dev \
    libgif-dev \
    libfcgi-dev \
    libjpeg62-dev \
    libproj-dev \
    libcairo2-dev \
    libprotobuf-dev \
    gdal-bin

RUN apt-get install -y libgdal-dev

# Install PHP7.4 and necessary modules
RUN  apt-get install -y php7.4-fpm libapache2-mod-php7.4 php7.4-common php7.4-cli  php7.4 \
php7.4  php7.4-opcache  php7.4-gd php7.4-curl php7.4-fpm php7.4-dev php7.4-mysql php7.4-mbstring  php7.4-xml

# Compile mapserver and associated resources
ADD resources /tmp/resources
ARG MAPSERVER_VERSION=branch-7-6
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh


# Configure localhost in Apache
RUN cp  /tmp/resources/000-default.conf /etc/apache2/sites-available/
RUN wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb \
-O libapache2-mod-fastcgi.deb && dpkg -i libapache2-mod-fastcgi.deb && apt install -f;rm libapache2-mod-fastcgi.deb

# Apache configuration for PHP-FPM # No fastcgi anymore
RUN cp /tmp/resources/php7-fpm.conf /etc/apache2/conf-available/

# Enable these Apache modules
RUN a2enmod actions  cgi alias proxy_fcgi  fastcgi headers
RUN a2enconf php7.4-fpm

# Link to cgi-bin executable
RUN chmod o+x /usr/local/bin/mapserv
RUN ln -s /usr/local/bin/mapserv /usr/lib/cgi-bin/mapserv
RUN chmod 755 /usr/lib/cgi-bin

EXPOSE  80
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

#ifconfig not installed by default in focal
RUN apt-get install -y net-tools
ENV HOST_IP `ifconfig | grep inet | grep Mask:255.255.255.0 | cut -d ' ' -f 12 | cut -d ':' -f 2`

# Fix php startup error https://stackoverflow.com/questions/59993170/php-7-4-and-ubuntu-18-php-startup-unable-to-load-dynamic-library-curl-so
RUN mv /usr/local/lib/libcurl.so.4.4.0 /usr/local/lib/libcurl.so.4.4.0.backup

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


CMD ["dockerize", "-stdout", "/var/log/apache2/access.log", "-stderr", "/var/log/apache2/error.log", "apachectl", "-D", "FOREGROUND"]
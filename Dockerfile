# Mapserver for Docker
FROM ubuntu:focal
#If you change ubuntu version, don't forget to change 3 echo lines 
MAINTAINER Admire Nyakudya<admire@kartoza.com>

ENV LANG C.UTF-8
#RUN update-locale LANG=C.UTF-8

# Update and upgrade system
RUN apt-get -qq update --fix-missing && apt-get -qq --yes upgrade

#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

#-------------Application Specific Stuff ----------------------------------------------------

# Install mapcache compilation prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common g++ make cmake wget git  bzip2 apache2 curl #apache2-threaded-dev curl apache2-mpm-worker # doesn't exists anymore
#DEBIAN_FRONTEND=noninteractive to solve problem with tzdata whitch needs 2 answers !

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
    libgeos-dev \
    gdal-bin

ADD resources /tmp/resources

ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh


# Configure localhost in Apache
RUN cp  /tmp/resources/000-default.conf /etc/apache2/sites-available/

# To be able to install libapache. #Allready in source.list for ubuntu:focal
#RUN echo 'deb http://archive.ubuntu.com/ubuntu focal multiverse' >> /etc/apt/sources.list
#RUN echo 'deb http://archive.ubuntu.com/ubuntu focal-updates multiverse' >> /etc/apt/sources.list
#RUN echo 'deb http://security.ubuntu.com/ubuntu focal-security multiverse' >> /etc/apt/sources.list
#RUN  apt-get update

# Install PHP7.4 and necessary modules
RUN  apt-get install -y php7.4-fpm libapache2-mod-php7.4 php7.4-common php7.4-cli php7.4-fpm php7.4 #libapache2-mod-fastcgi doesn't exist anymore

# Enable these Apache modules
RUN  a2enmod actions cgi alias

# Apache configuration for PHP-FPM # No fastcgi anymore
#RUN cp /tmp/resources/php5-fpm.conf /etc/apache2/conf-available/

# Link to cgi-bin executable
RUN chmod o+x /usr/local/bin/mapserv
RUN ln -s /usr/local/bin/mapserv /usr/lib/cgi-bin/mapserv
RUN chmod 755 /usr/lib/cgi-bin

EXPOSE  80

#ifconfig not installed by default in focal
RUN apt-get install -y net-tools
ENV HOST_IP `ifconfig | grep inet | grep Mask:255.255.255.0 | cut -d ' ' -f 12 | cut -d ':' -f 2`

CMD apachectl -D FOREGROUND

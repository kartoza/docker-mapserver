#!/bin/bash

#Install curl from source
if [[ ! -f /tmp/resources/curl-7.50.0.tar.gz ]]; then \
  wget -c https://curl.haxx.se/download/curl-7.50.0.tar.gz -P /tmp/resources/; \
fi;\
cd /tmp/resources && \
tar -zxvf curl-7.50.0.tar.gz && \
cd curl-7.50.0 && \
./configure --with-ssl=/usr/local/ssl --enable-ares --enable-versioned-symbols && \
make -j 4 install


#VERSION=harfbuzz-0.9.19.tar.bz2
VERSION=harfbuzz-2.6.4
EXTENSION=.tar.xz
if [ ! -f /tmp/resources/${VERSION}${EXTENSION} ]; then \
    wget http://www.freedesktop.org/software/harfbuzz/release/${VERSION}${EXTENSION} -P /tmp/resources/; \
    fi; \
    cd /tmp/resources &&\
    tar xf ${VERSION}${EXTENSION}  &&\
    cd $VERSION && \
    ./configure  && \
    make  && \
    make -j 4 install  && \
    ldconfig

# Compile geos
GEOS_VERSION=3.8.1
if [[ ! -f /tmp/resources/geos-${GEOS_VERSION}.tar.bz2 ]]; then \
wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 -P /tmp/resources/; \
fi; \
cd /tmp/resources && \
tar xjf geos-${GEOS_VERSION}.tar.bz2 && \
cd geos-${GEOS_VERSION} && \
./configure  && \
make -j 4 install


if [  ! -d /tmp/resources/mapserver ]; then \
    git clone https://github.com/mapserver/mapserver /tmp/resources/mapserver; \
    fi;\
    mkdir -p /tmp/resources/mapserver/build && \
    cd /tmp/resources/mapserver/ && \
    git checkout ${MAPSERVER_VERSION} && \
    cd ./build && \
    cmake /tmp/resources/mapserver/ -DWITH_THREAD_SAFETY=1 \
        -DWITH_KML=1 \
        -DWITH_SOS=1 \
        -DWITH_WMS=1 \
        -DWITH_FRIBIDI=1 \
        -DWITH_HARFBUZZ=1 \
        -DWITH_ICONV=1 \
        -DWITH_CAIRO=1 \
        -DWITH_RSVG=1 \
        -DWITH_MYSQL=1 \
        -DWITH_GEOS=1 \
        -DWITH_POSTGIS=1 \
        -DWITH_CURL=1 \
        -DWITH_CLIENT_WMS=1 \
        -DWITH_CLIENT_WFS=1 \
        -DWITH_WFS=1 \
        -DWITH_WCS=1 \
        -DWITH_LIBXML2=1 \
        -DWITH_GIF=1 \
        -DWITH_EXEMPI=1 \
        -DWITH_XMLMAPFILE=1 \
        -DWITH_PYTHON=ON \
        -DWITH_PERL=ON \
        -DWITH_PIXMAN=1 \
        -DWITH_PROTOBUFC=1 \
        -DWITH_FCGI=1 \
        -DWITH_PHPNG=1 \
        -DWITH_PHP=ON && \
    make -j 4 install  && \
    ldconfig

echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo '<?php phpinfo();' > /var/www/html/info.php

rm -rf /tmp/resources/mapserver /tmp/resources/geos-${GEOS_VERSION}.tar.bz2 \
/tmp/resources/${VERSION}${EXTENSION}


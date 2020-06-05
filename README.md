# Mapserver

Docker container for Mapserver

## Build image

```docker build  -t kartoza/mapserver .```
or using the build script
```
./build.sh
```

You can also use build arguments like

```
 docker build --build-arg MAPSERVER_VERSION=branch-7-6 -t kartoza/mapserver:7.6 
```

## Start container
```
docker run -d -p 8182:80 --name mapserver -v `pwd`/map:/map kartoza/mapserver
```

## Access container via http

When Docker is forwarded as _localhost_ simply open the following URL:<br/> 
`http://localhost:8182/cgi-bin/mapserv`

When if you have _docker-machine_ in place check its IP with to following command and replace the _localhost_ with it.<br/>
`docker-machine ip`

To make sure the url specified above works the web browser should give a response:<br/>
 `No query information to decode. QUERY_STRING is set, but empty.`

A quick way to access the contents of your mapfile in a browser can be achived by:<br/>
`http://localhost:8182/cgi-bin/mapserv?map=/map/generic.map&mode=browse&template=openlayers&layers=all`

The displayed map should look like that:<br/>
<img src="generic-map-browse-mode-screenshot.png" title="Generic-Map Browse-Mode Screenshot" alt="Generic-Map Browse-Mode Screenshot" width="250px">

Replace generic.map with the name of your mapserver mapfile.

## Enter container via bash

To enter the container with a bash interface simple switch from _daemon_ mode to _interactive_ mode<br/>
```
docker run -it -v `pwd`/map:/map kartoza/mapserver bash
```

There you'll see the mapped /map folder and can use the useful cli tool like 
* `mapserv` http://www.mapserver.org/utilities/
Running mapserv -v results in 

```
mapserv -v
MapServer version 7.6.0 OUTPUT=PNG OUTPUT=JPEG OUTPUT=KML \
SUPPORTS=PROJ SUPPORTS=AGG SUPPORTS=FREETYPE SUPPORTS=CAIRO \
SUPPORTS=SVG_SYMBOLS SUPPORTS=RSVG SUPPORTS=ICONV SUPPORTS=XMP \
SUPPORTS=FRIBIDI SUPPORTS=WMS_SERVER SUPPORTS=WMS_CLIENT \
SUPPORTS=WFS_SERVER SUPPORTS=WFS_CLIENT SUPPORTS=WCS_SERVER \
SUPPORTS=SOS_SERVER SUPPORTS=FASTCGI SUPPORTS=THREADS \
SUPPORTS=GEOS SUPPORTS=POINT_Z_M SUPPORTS=PBF INPUT=JPEG \
INPUT=POSTGIS INPUT=OGR INPUT=GDAL INPUT=SHAPEFILE 
```

* `gdal` raster utilities: http://www.gdal.org/gdal_utilities.html
* `ogr` vector utilities: http://www.gdal.org/ogr_utilities.html
* `shp2img` Creates a map image from a mapfile: https://mapserver.org/utilities/shp2img.html
* Mapserver utilities: https://www.mapserver.org/utilities/
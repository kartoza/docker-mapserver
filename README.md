# mapserver

Docker container for Mapserver

## build image

```docker build -t mapserver .```

## start container
```docker run -d -p 8182:80 -v `pwd`/map:/map mapserver```

while the command is<br/>
`docker run -d -p [exposed port]:[internal port] -v [your-path]:[container-path] mapserver` 

## access container via http

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

## enter container via bash

To enter the container with a bash interface simple switch from _daemon_ mode to _interactive_ mode<br/>
```docker run -it -v `pwd`/map:/map mapserver bash```

There you'll see the mapped /map folder and can use the useful cli tool like 
* `mapserv` http://www.mapserver.org/utilities/
* `gdal` raster utilities: http://www.gdal.org/gdal_utilities.html
* `ogr` vector utilities: http://www.gdal.org/ogr_utilities.html
# mapserver

Docker container for Mapserver

## Instructions

* Clone the repo and navigate to the base of the repo

* Run ./build which will build the mapserver image.

* Once the image has been build we need to run the image.

* docker run -d -p 8182:80 -v /web:/map --name mapserving kartoza/mapserver

* Once the container is running we can go to the url below

 http://localhost:8182/cgi-bin/mapserv
 
 The following url should give the following result: No query information to decode. QUERY_STRING is set, but empty.

* To access the map go to the  url below and see all the layer:

  http://localhost:8182/cgi-bin/mapserv?mode=browse&template=openlayers&layers=all&map=/maps/test.map

* When running the container it can also be linked to a postgres container. 

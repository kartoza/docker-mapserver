# mapserver

Docker container for Mapserver

## Instructions

Pull the image from docker hub:
```bash
docker pull kartoza/mapserver
sudo docker run -d -p 8182:80 -v /web:/map --name mapserving kartoza/mapserver
```

If you mapfile consist of layer in a postgres database then you need to link the mapserver container to the postgis container.

Once the container is running  go to the url below:
````
http://localhost:8182/cgi-bin/mapserv
 ````
To make sure the url specified above works the web browser should give a response:
 ```
No query information to decode. QUERY_STRING is set, but empty.
 ```

A quick way to access the contents of your mapfile in a browser can be achived by :
```
http://localhost:8182/cgi-bin/mapserv?mode=browse&template=openlayers&layers=all&map=/maps/test.map
 ```
Replace test.map with the name of your mapserver mapfile.
 
If you want to build the image yourself using the Docker recipe then do the following:


```bash
sudo apt-get install apt-cacher-ng
```

Edit ``71-apt-cacher-ng`` to use your host's ip address.

```bash
git clone git@github.com:kartoza/docker-mapserver.git
cd docker-mapserver
```



```bash
sudo ./build.sh
```


Its going to take a long time (and consume a chunk of bandwidth) for the build
because you have any docker base operating system images on your system.

After it is installed, to run the container using the  command below:

```bash
sudo docker run -d -p 8182:80 -v /web:/map --name mapserving kartoza/mapserver
```
Then from your local machine you go to the url below to test if mapserver is running:

```
http://localhost:8182/cgi-bin/mapserv
```
To make sure the url specified above works the web browser should give a response:
 ```
No query information to decode. QUERY_STRING is set, but empty.
 ```

A quick way to access the contents of your mapfile in a browser can be achived by :
```
http://localhost:8182/cgi-bin/mapserv?mode=browse&template=openlayers&layers=all&map=/maps/test.map
 ```


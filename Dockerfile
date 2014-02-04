FROM stackbrew/ubuntu:saucy

RUN apt-get update

RUN apt-get install -y build-essential git cmake pkg-config libprotoc-dev libprotobuf7 \
    protobuf-compiler libprotobuf-dev libosmpbf-dev libpng12-dev \
    libbz2-dev libstxxl-dev libstxxl-doc libstxxl1 libxml2-dev \
    libzip-dev libboost-all-dev lua5.1 liblua5.1-0-dev libluabind-dev libluajit-5.1-dev

RUN git clone git://github.com/DennisOSRM/Project-OSRM.git
RUN cd Project-OSRM;mkdir -p build;cd build;cmake ..;make

RUN ln -s ../profiles/car.lua profile.lua
RUN ln -s ../profiles/lib/

#download pdf file
RUN wget http://download.geofabrik.de/europe/france-latest.osm.pbf -O map.osm.pbf
RUN ./osrm-extract map.osm.pbf
RUN ./osrm-prepare map.osrm

EXPOSE 5000
ENTRYPOINT ["/Project-OSRM/build/osrm-routed"]
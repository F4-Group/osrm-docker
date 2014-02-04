FROM stackbrew/ubuntu:saucy

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git cmake pkg-config libprotoc-dev libprotobuf7 \
    protobuf-compiler libprotobuf-dev libosmpbf-dev libpng12-dev \
    libbz2-dev libstxxl-dev libstxxl-doc libstxxl1 libxml2-dev \
    libzip-dev libboost-all-dev lua5.1 liblua5.1-0-dev libluabind-dev libluajit-5.1-dev wget

RUN mkdir -p /build && mkdir -p /data
RUN git clone git://github.com/DennisOSRM/Project-OSRM.git /src

WORKDIR /build
RUN cmake /src
RUN make
RUN ln -s /src/profiles/car.lua profile.lua
RUN ln -s /src/profiles/lib/
RUN wget -nv http://download.geofabrik.de/europe/france-latest.osm.pbf -O /data/map.osm.pbf
RUN ./osrm-extract /data/map.osm.pbf
RUN ./osrm-prepare map.osrm

EXPOSE 5000
ENTRYPOINT ["/build/osrm-routed"]

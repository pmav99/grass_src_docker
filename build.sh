# create the base image. It contains the user that
docker build \
    -f grass_base.docker \
    -t grass-base \
    ./

# build the container with the grass 7 dependencies.
docker build \
    -f grass7_base.docker \
    -t grass7_base \
    ./

# create a data only container that will contain the sample data
# build the image
docker build \
    -f grass7_datasets.docker \
    -t grass7-datasets \
    ./
# create the actual container
docker run \
    --name grass7_datasets \
    -t grass7-datasets;

# create the image that contains PROJ, GEOS, GDAL etc.
docker build \
    -f grass7_dependencies.docker \
    -t grass7_dependencies \
    ./

# create the image for grass 7.0.2 release
docker build \
    -f grass7_702.docker \
    -t grass702 \
    ./

docker build \
    -f grass7_70_trunk.docker \
    -t grass70_trunk \
    ./

docker run \
    --rm \
    --volumes-from grass7_datasets \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/:/home/grassuser/hosthome \
    -e DISPLAY=unix:0 \
    -it grass702;

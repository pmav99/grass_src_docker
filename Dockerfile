FROM phusion/baseimage:0.9.17

MAINTAINER Panos Mavrogiorgos <pmav99 - gmail >

# we are going to create a normal user that is going to be used for building
# the various libs and running GRASS. We are also granting him password-less sudo
ENV GRASS_USER=grassuser \
    GRASS_SAMPLE_LOCATIONS=/home/$GRASS_USER/sample_locations

RUN useradd $GRASS_USER -m -s /bin/bash && \
    su $GRASS_USER && \
    mkdir -p $GRASS_SAMPLE_LOCATIONS && \
    cd $GRASS_SAMPLE_LOCATIONS && \
    curl -O https://grass.osgeo.org/sampledata/north_carolina/nc_basic_spm_grass7.tar.gz && \
    tar -zxvf nc_basic_spm_grass7.tar.gz

COPY readme.md $GRASS_SAMPLE_LOCATIONS/readme.md

VOLUME $GRASS_SAMPLE_LOCATIONS

CMD ["echo", "Sample datasets for GRASS 7."]

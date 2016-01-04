FROM quay.io/pmav99/grass_docker_src:base

MAINTAINER Panos Mavrogiorgos <pmav99 - gmail >

# we are going to create a normal user that is going to be used for building
# the various libs and running GRASS. We are also granting him password-less sudo
ENV GRASS_SAMPLE_LOCATIONS=/home/$GRASS_USER/sample_locations

RUN mkdir -p $GRASS_SAMPLE_LOCATIONS && \
    cd $GRASS_SAMPLE_LOCATIONS && \
    curl -O https://grass.osgeo.org/sampledata/north_carolina/nc_basic_spm_grass7.tar.gz && \
    tar -zxvf nc_basic_spm_grass7.tar.gz && \
    # get temporal dataset script
    echo "curl -O http://fatra.cnr.ncsu.edu/temporal-grass-workshop/NC_spm_temporal_workshop.zip" > $GRASS_SAMPLE_LOCATIONS/get_temporal.sh && \
    echo "unzip -o NC_spm_temporal_workshop.zip" >> $GRASS_SAMPLE_LOCATIONS/get_temporal.sh && \
    # get spearfish dataset script
    echo "curl -O https://grass.osgeo.org/sampledata/spearfish_grass70data-0.3.tar.gz" > $GRASS_SAMPLE_LOCATIONS/get_spearfish.sh && \
    echo "tar -zxvf spearfish_grass70data-0.3.tar.gz" > $GRASS_SAMPLE_LOCATIONS/get_spearfish.sh && \
    # get full North Carolina dataset script
    echo "curl -O https://grass.osgeo.org/sampledata/north_carolina/nc_spm_08_grass7.tar.gz" > $GRASS_SAMPLE_LOCATIONS/get_full_nc.sh && \
    echo "tar -zxvf nc_spm_08_grass7.tar.gz" >> $GRASS_SAMPLE_LOCATIONS/get_full_nc.sh

COPY readme.md $GRASS_SAMPLE_LOCATIONS/readme.md

VOLUME $GRASS_SAMPLE_LOCATIONS

CMD ["echo", "Sample datasets for GRASS 7."]

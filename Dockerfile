FROM quay.io/pmav99/grass_docker_src:base

MAINTAINER Panos Mavrogiorgos <pmav99 - gmail >

# Compile grass
ENV GRASS_VERSION=7.0.2

USER $GRASS_USER
RUN cd $BUILD_DIRECTORY && \
    wget https://grass.osgeo.org/grass70/source/grass-${GRASS_VERSION}.tar.gz && \
    tar -xzvf grass-${GRASS_VERSION}.tar.gz && \
    cd $BUILD_DIRECTORY/grass-$GRASS_VERSION && \
    CFLAGS='-O2 -Wall' LDFLAGS='-s' ./configure \
        --enable-largefile=yes \
        --with-nls \
        --with-cxx \
        --with-readline \
        --with-pthread \
        --with-proj-share=/usr/local/share/proj/ \
        --with-geos=/usr/local/bin/geos-config \
        --with-wxwidgets \
        --with-cairo \
        --with-opengl-libs=/usr/include/GL \
        --with-freetype=yes \
        --with-freetype-includes='/usr/include/freetype2/' \
        --with-postgres=yes \
        --with-postgres-includes='/usr/include/postgresql' \
        --with-sqlite=yes \
        --with-mysql=yes --with-mysql-includes='/usr/include/mysql' \
        --with-odbc=yes \
        --with-liblas=yes \
        --with-liblas-config=/usr/bin/liblas-config && \
    echo "y" | make -j`nproc` && \
    sudo ln -s /usr/local/src/grass70/bin.x86_64-unknown-linux-gnu/grass70 /usr/bin/grass70

ENTRYPOINT ["/bin/bash"]

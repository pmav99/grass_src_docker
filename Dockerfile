FROM quay.io/pmav99/grass_docker_src:base

MAINTAINER Panos Mavrogiorgos <pmav99 - gmail >

# Compile grass
ENV GRASS_VERSION=70 \
    GRASS_SVN_URL=https://svn.osgeo.org/grass/grass/trunk \
    GRASS_SVN_DIR=/usr/local/src/grass_svn

USER $GRASS_USER
WORKDIR $BUILD_DIRECTORY
RUN svn co $GRASS_SVN_URL $GRASS_SVN_DIR && \
    cd $GRASS_SVN_DIR && \
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
    sudo ln -sf $GRASS_SVN_DIR/bin.x86_64-pc-linux-gnu/grass$GRASS_VERSION /usr/bin/grass

ENTRYPOINT ["/bin/bash"]

FROM phusion/baseimage:0.9.17

MAINTAINER Panos Mavrogiorgos <pmav99 - gmail >

# we are going to create a normal user that is going to be used for building
# the various libs and running GRASS. We are also granting him password-less sudo
ENV GRASS_USER=grassuser \
    BUILD_DIRECTORY=/usr/local/src \
    PROJ_VERSION=4.9.2 \
    PROJ_DATUMGRID_VERSION=1.5 \
    GEOS_VERSION=3.4.2 \
    GDAL_VERSION=1.11.3

RUN useradd $GRASS_USER -m -s /bin/bash && \
    adduser $GRASS_USER sudo && \
    echo "$GRASS_USER ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers && \
    # Create the build directory make sure that it has the correct permissions.
    mkdir -p $BUILD_DIRECTORY && \
    chown $GRASS_USER:$GRASS_USER $BUILD_DIRECTORY && \
    chmod ug+rwx $BUILD_DIRECTORY && \
    # add the local lib to ld.so.conf \
    echo '/usr/local/lib' | tee -a /etc/ld.so.conf && \
    # GRASS complains if the following file is missing
    su $GRASS_USER && \
    mkdir -p /home/$GRASS_USER/.local/share/ && \
    touch /home/$GRASS_USER/.local/share/recently-used.xbel

# We are going to add a ppa that provides apt-fast (i.e. an apt wrapper that uses aria2c).
# While we do so we will also add some addititonal ppas that are going to be needed.
# gta is needed for gdal (not sure if it is needed for GRASS though).
RUN add-apt-repository -y ppa:saiarcot895/myppa && \
    add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    add-apt-repository -y ppa:marlam/gta && \
    apt-get update && \
    apt-get install -y \
        -o APT::Install-Recommends=false \
        -o APT::Install-Suggests=false \
        apt-fast && \
    # upgrade the system \
    apt-fast update && \
    apt-fast -y upgrade && \
    # We can now install some packages that are often useful when working on the cli. \
    # Yeah, I know that on Docker you should not install packages which are not \
    # necessary, but while developing with GRASS we often have to work \
    # interactively. \
    apt-fast install -y \
        -o APT::Install-Recommends=false \
        -o APT::Install-Suggests=false \
        git \
        curl \
        wget \
        vim-gtk \
        tree \
        htop \
        silversearcher-ag \
        unzip \
        # Install GRASS dependencies. Copy pasted from the wiki \
        build-essential \
        flex \
        make \
        bison \
        gcc \
        libgcc1 \
        g++ \
        cmake \
        ccache \
        python \
        python-dev \
        python-opengl \
        python-wxversion \
        python-wxtools \
        python-wxgtk2.8 \
        python-dateutil \
        libgsl0-dev \
        python-numpy \
        python-matplotlib \
        wx2.8-headers \
        wx-common \
        libwxgtk2.8-dev \
        libwxgtk2.8-dbg \
        libwxbase2.8-dev \
        libwxbase2.8-dbg \
        libncurses5-dev \
        zlib1g-dev \
        gettext \
        libtiff-dev \
        libpnglite-dev \
        libcairo2 \
        libcairo2-dev \
        sqlite3 \
        libsqlite3-dev \
        libpq-dev \
        libreadline6 \
        libreadline6-dev \
        libfreetype6-dev \
        libfftw3-3 \
        libfftw3-dev \
        libboost-thread-dev \
        libboost-program-options-dev \
        liblas-c-dev \
        resolvconf \
        libjasper-dev \
        subversion \
        libav-tools \
        libavutil-dev \
        ffmpeg2theora \
        libffmpegthumbnailer-dev \
        libavcodec-dev \
        libxmu-dev \
        libavformat-dev \
        libswscale-dev \
        checkinstall \
        libglu1-mesa-dev \
        libxmu-dev \
        ghostscript \
        # mysql support
        libmysqlclient-dev \
        # netcdf support
        netcdf-bin \
        libnetcdf-dev \
        # Also install the pre-compiled dev-packages for PROJ.4, GEOS, GDAL
        #libproj-dev \
        #libgeos-dev \
        #libgdal-dev \
        #python-gdal \
        #proj-bin \
        postgis \
        postgresql-server-dev-9.3 \
        postgresql-9.3-postgis-2.1 \
        postgresql-9.3-postgis-2.1-scripts \
        libpng12-dev \
        libjpeg-dev \
        libgif-dev \
        liblzma-dev \
        libcurl4-gnutls-dev \
        libxml2-dev \
        libexpat-dev \
        libxerces-c-dev \
        libpoppler-dev \
        libspatialite-dev \
        gpsbabel \
        swig \
        libhdf4-alt-dev \
        libhdf5-serial-dev \
        libpodofo-dev \
        poppler-utils \
        libfreexl-dev \
        unixodbc-dev \
        libwebp-dev \
        libepsilon-dev \
        liblcms2-2 \
        libpcre3-dev \
        libarmadillo-dev \
        doxygen \
        ant \
        mono-mcs \
        # from ppa
        libgta-dev \
        # GDAL can be compiled with opencl although I am not sure if GRASS needs it. \
        opencl-headers \
        ocl-icd-libopencl1 \
        # these are necessary for the GUI
        xorg \
        hicolor-icon-theme && \
    # clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
           /var/tmp/* \
           /tmp/*

# compile stuff
USER $GRASS_USER
RUN cd $BUILD_DIRECTORY && \
    # download and compile PROJ
    wget https://github.com/OSGeo/proj.4/archive/${PROJ_VERSION}.zip && \
    unzip -o ${PROJ_VERSION}.zip && \
    cd proj.4-$PROJ_VERSION/nad && \
    wget http://download.osgeo.org/proj/proj-datumgrid-${PROJ_DATUMGRID_VERSION}.zip && \
    unzip -o proj-datumgrid-${PROJ_DATUMGRID_VERSION}.zip && \
    rm  ./proj-datumgrid-${PROJ_DATUMGRID_VERSION}.zip && \
    rm  ../../${PROJ_VERSION}.zip && \
    cd $BUILD_DIRECTORY/proj.4-$PROJ_VERSION && \
    ./configure && \
    echo "yes" | make -j`nproc` && \
    # download and compile GEOS \
    cd $BUILD_DIRECTORY && \
    wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 && \
    bunzip2 geos-${GEOS_VERSION}.tar.bz2 && \
    tar xvf geos-${GEOS_VERSION}.tar && \
    cd geos-${GEOS_VERSION} && \
    ./configure && \
    echo "yes" | make -j`nproc` && \
    rm ../geos-${GEOS_VERSION}.tar && \
    # download and compile GDAL \
    cd $BUILD_DIRECTORY && \
    wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    tar -xzf gdal-${GDAL_VERSION}.tar.gz && \
    cd gdal-${GDAL_VERSION} && \
    CFLAGS="-g -Wall" LDFLAGS="-s" ./configure \
        --with-png=internal \
        --with-libtiff=internal \
        --with-geotiff=internal \
        --with-jpeg=internal \
        --with-gif=internal \
        --with-ecw=no \
        --with-expat=yes \
        --with-sqlite3=yes \
        --with-geos=yes \
        --with-python \
        --with-libz=internal \
        --with-netcdf \
        --with-threads=yes \
        --without-grass  \
        --without-ogdi \
        --with-pg=/usr/bin/pg_config \
        --with-xerces=yes && \
    echo "yes" | make -j`nproc` && \
    # become root and install packages
    # install PROJ
    cd $BUILD_DIRECTORY/proj.4-$PROJ_VERSION && \
    sudo checkinstall && \
    sudo ldconfig && \
    # install geos
    cd $BUILD_DIRECTORY/geos-$GEOS_VERSION && \
    sudo checkinstall && \
    sudo ldconfig && \
    # install gdal
    cd $BUILD_DIRECTORY/gdal-$GDAL_VERSION && \
    sudo checkinstall && \
    sudo ldconfig && \
    # you can now remove the src directories
    cd $BUILD_DIRECTORY && \
    sudo rm -rf gdal-${GDAL_VERSION} proj.4-${PROJ_VERSION} geos-${GEOS_VERSION}

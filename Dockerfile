FROM phusion/baseimage:0.9.17

MAINTAINER Panos Mavrogiorgos <pmav99 - gmail >

# we are going to create a normal user that is going to be used for building
# the various libs and running GRASS. We are also granting him password-less sudo
ENV GRASS_USER=grassuser \
    BUILD_DIRECTORY=/usr/local/src
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


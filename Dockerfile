FROM ubuntu:14.04
MAINTAINER Qiang Li "li.qiang@gmail.com"

#https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md

####
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    clang \
    git \
    curl

# Install additional build dependencies
RUN curl -L https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh > /tmp/install-build-deps.sh
    && chmod +x /tmp/install-build-deps.sh
    && /tmp/install-build-deps.sh --no-prompt --no-arm --no-chromeos-fonts --no-nacl
    && rm /tmp/install-build-deps.sh

#
ENV LOGIN=vcap
ENV HOME /home/$LOGIN

RUN useradd -m -b /home -s /bin/bash $LOGIN

USER $LOGIN
WORKDIR /home/$LOGIN

# Install depot_tools.
ENV DEPOT_TOOLS /home/$LOGIN/depot_tools
ENV PATH $PATH:$DEPOT_TOOLS

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $DEPOT_TOOLS
RUN echo "export PATH=\"\$PATH:$DEPOT_TOOLS\"" >> .bashrc

##
ENV SRC /home/$LOGIN/chromium/src
WORKDIR $SRC

# Get the code
#RUN fetch --nohooks --no-history chromium
#

# Build Chromium
# RUN ninja -C out/Release chrome -j18
FROM ubuntu:22.04

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        can-utils \
        dh-autoreconf \
        git \
        iproute2 \
        kmod \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    ;

# TODO: If building this requires your kernel headers, we may not be able to build and run it in a
# Docker container ...
SHELL ["/bin/bash", "-c"]
RUN git clone https://github.com/linux-can/socketcand.git /tmp/socketcand/ \
    && pushd /tmp/socketcand/ \
    && ./autogen.sh \
    && ./configure --prefix /usr/local/ \
    && make \
    && make install \
    && popd \
    && rm -rf /tmp/socketcand/ \
    ;

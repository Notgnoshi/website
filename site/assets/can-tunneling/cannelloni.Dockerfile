FROM ubuntu:22.04

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        can-utils \
        cmake \
        git \
        iproute2 \
        libsctp-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    ;

SHELL ["/bin/bash", "-c"]
RUN git clone https://github.com/mguentner/cannelloni.git /tmp/cannelloni/ \
    && pushd /tmp/cannelloni/ \
    && cmake -B ./build/ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/ . \
    && cmake --build ./build/ --parallel --target install \
    && popd \
    && rm -rf /tmp/cannelloni/ \
    ;

---
title: Tunneling CAN over IP
description: A tutorial on how to tunnel CAN over IP so that the same CAN bus can be shared between Docker containers
date: 2023-06-20

---

# Tunneling CAN over IP

```{toc}
```

This post will focus on sharing a CAN network between Docker containers. I'm sure there are other
use-cases for tunneling CAN over IP, but this is the one that I've run into.

* Use `--network host` to use the host's `vcan` network(s)
    * Not a tunnel
    * Depending on requirements, it may not be acceptable to use the host network
* Use <https://gitlab.com/chgans/can4docker> to provide CAN support for Docker
    * Flaky, only kind of works, undocumented, unsupported, abandoned, and does weird things on the
      boot cycle after using it
* Use <https://github.com/mguentner/cannelloni> to tunnel CAN over UDP or SCTP
    * May not be acceptable to use a possibly lossy protocol like UDP
    * The hardware device you may be working with might have a kernel that doesn't support SCTP
    * It appears support was added for TCP since the last time I looked at it
* Use <https://github.com/GBert/railroad/tree/master/can2udp> to tunnel CAN over UDP
    * UDP might not be acceptable as describe above
* There _might_ be a way to use [socat](https://repo.or.cz/socat.git) that I haven't figured out
* Pipe `candump | nc` on one side and `nc | cansend` on the other side
    * That wasn't a serious suggestion. Just trying to make sure you're awake.
* Use `cangw` as described by
  <https://www.systec-electronic.com/en/demo/blog/article/news-socketcan-docker-the-solution> to setup
  pairs of unidirectional IP tunnels
    * Complex to setup, possibly requires a third Docker container to act as the gateway between the
      two you want to tunnel together?
* Use <https://github.com/linux-can/socketcand> to create a TCP client/server CAN tunnel
    * Easiest option to use. Unware of any tradeoffs as of yet

I have experience using `cannelloni` and `socketcand`. I recommend using `socketcand` for ease-of-use.

# Sharing the same CAN bus between two Docker containers

## socketcand

### Docker image

Take the following Docker image

```dockerfile
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
```

```{dark}
If you _really_ care about container size, you could use a multi-stage build to cut out the build
dependencies from the resulting `socketcand` and `kmod` binaries.
```

Build with

```sh
docker build -t socketcand .
```

### Server

On the host, run
```sh
docker network create socketcand-shared
docker run -it --rm --network socketcand-shared --name socketcand-server --cap-add NET_ADMIN socketcand
```

In the container, run
```sh
ip link add dev can1 type vcan
ip link set up can1
socketcand --verbose --interface can1 &
candump -L can1
```

Then again on the host, run
```sh
$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' socketcand-server
172.19.0.2
```
This is how we'll tell what IP address to connect the `socketcandcl` client to.

### Client

```{dark}
The `socketcand` [protocol](https://github.com/linux-can/socketcand/blob/master/doc/protocol.md)
defines a UDP service discovery mechanism for clients to discover the `socketcand` server.

However, the `socketcandcl` client does not use this discovery mechanism, so you need to connect it
to the `socketcand` server by IP address directly.
```

On the host, run
```sh
export SOCKETCAND_SERVER="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' socketcand-server)"
docker run -it --rm --network socketcand-shared --name socketcand-client --cap-add NET_ADMIN --env SOCKETCAND_SERVER socketcand
```

In the container, run
```sh
ip link add dev can1 type vcan
ip link set up can1
socketcandcl --verbose --server $SOCKETCAND_SERVER --interfaces can1,can1 &
candump -L can1 &
cansend can1 123#4455
```

You should see
```
(1687220675.698707) can1 123#4455
```
in both the server and the client's console output.

## cannelloni
I'm sure you could use `cannelloni` for this, but I think `socketcand` was easier, so I never tried.

# Sharing a CAN bus between a Docker container and your host

## socketcand

You can run either the server or the client in a container. I'll provide instructions for running
the server on the host.

On the host, create a `can1` virtual CAN network to share with the container.
```sh
sudo modprobe vcan
sudo ip link add dev can1 type vcan
sudo ip link set up can1
```

This doesn't have to be a `vcan` network, but I don't currently have access to a physical CAN
network for demonstration.

On the host, run
```sh
socketcand --verbose --interface can1 &
candump -L can1 &
```

This will bind to your default interface's public IP, which we'll need to use to connect the client
to the server.

```sh
# There's probably a better way
export SOCKETCAND_SERVER=$(ip -4 -br address show eth0 | tr -s ' ' | cut -d ' ' -f 3 | sed 's|\(.*\)/.*|\1|')
```

In a separate terminal session, start a container with
```sh
docker run -it --rm --name socketcand-client --cap-add NET_ADMIN --env SOCKETCAND_SERVER socketcand
```
and in the resulting shell, run
```sh
ip link add dev can1 type vcan
ip link set up can1
socketcandcl --verbose --server $SOCKETCAND_SERVER --interfaces can1,can1 &
candump -L can1 &
cansend can1 123#4455
```

## cannelloni

It's been several years since I've last used cannelloni, and the thing that made it less desirable
was that it used SCTP rather than TCP. But SCTP wasn't supported by the Linux kernel for the
hardware device I was interacting with.

But nowadays it appears it supports TCP just fine.

Build and install cannelloni on the host

```sh
sudo apt install libsctp-dev
git clone https://github.com/mguentner/cannelloni.git
cd cannelloni/
cmake -B ./build/ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local/ .
cmake --build ./build/ --parallel --target install
```

Then do the same inside a Docker image with the following Dockerfile:

```dockerfile
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
```

built with

```sh
docker build -t cannelloni .
```

Then, on the host, create a `can1` network to share between the host and a Docker container

```sh
sudo modprobe vcan
sudo ip link add dev can1 type vcan
sudo ip link set up can1
```

### Option 1 - UDP

Run the Docker container
```sh
docker run  --interactive --name cannelloni-udp --tty --rm --publish 2000:2000/udp --cap-add=NET_ADMIN cannelloni:latest
ip link add dev can1 type vcan
ip link set up can1
cannelloni -I can1 -R 127.0.0.1 -p -l 2000 -r 3000 &
candump -L can1 &
```

Then run `cannelloni` on the host

```sh
export CANNELLONI_IP="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cannelloni-udp)"
cannelloni -I can1 -R $CANNELLONI_IP -r 2000 -l 3000 &
candump -L can1 &
```

```{dark}
Notice that the `-l` and `-r` arguments flipped!
```

Now send a CAN message in the Docker container!

```sh
docker exec -it cannelloni-udp cansend can1 123#001122
```

You should see it in the host's `candump -L can1` output. Likewise, you should be able to send a CAN
message from the host to the container.

### Option 2 - SCTP

Run `cannelloni` in the container
```sh
docker run  --interactive --tty --rm --publish 2000:2000/sctp --cap-add=NET_ADMIN --name cannelloni-sctp cannelloni:latest
ip link add dev can1 type vcan
ip link set can1 up
cannelloni -I can1 -S s &
candump -L can1 &
```

and on the host, run

```sh
export CANNELLONI_IP="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cannelloni-sctp)"
cannelloni -I can1 -R $CANNELLONI_IP -S c &
candump -L can1 &
docker exec -it cannelloni-sctp cansend can1 123#334455
cansend can1 456#7788
```

```{dark}
The docs suggest that just switching `-S s`/`-S c` to `-C s`/`-C c` is all that's necessary to use
TCP rather than SCTP.
```

# Bonus - using Docker compose

Take the following `docker-compose.yml` file.

```yaml
version: "3.9"
services:
    socketcand-server:
        image: socketcand
        networks:
            - socketcand-shared
        cap_add:
            - NET_ADMIN
        entrypoint:
            - bash
            - -c
            - "ip link add dev can1 type vcan && ip link set up can1 && socketcand --verbose --interfaces can1"

    socketcand-client:
        image: socketcand
        networks:
            - socketcand-shared
        cap_add:
            - NET_ADMIN
        entrypoint:
            - bash
            - -c
            - "ip link add dev can1 type vcan && ip link set up can1 && socketcandcl --verbose --server socketcand-server --interfaces can1,can1"

networks:
    socketcand-shared:
```

```{dark}
Notice that we did not have to specify any IP addresses, instead using `--server` to pass the
hostname of the `socketcand-server` container to `socketcandcl`.
```

After running `docker compose up`, we can start a shell in the running containers to run `candump`
and `cansend` to prove to ourselves that the two services are sharing a CAN network.

```sh
docker exec -it can-tunneling-socketcand-client-1 candump -L can1
docker exec -it can-tunneling-socketcand-server-1 cansend can1 123#4455
```

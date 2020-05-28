#!/bin/bash

# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md
# NOTE: In order to bind to port 53, the local DNS server must be disabled. Run the following:
# sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
# sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'
# sudo systemctl restart systemd-resolved.service
# sudo systemctl restart NetworkManager.service

docker run \
    --detach \
    --name pihole \
    --publish 53:53 \
    --publish 67:67 \
    --expose 80 \
    --expose 443 \
    --dns 127.0.0.1 \
    --restart=unless-stopped \
    --mount "type=bind,source=/srv/pihole/etc/pihole/,target=/etc/pihole/" \
    --mount "type=bind,source=/srv/pihole/etc/dnsmasq.d/,target=/etc/dnsmasq.d/" \
    --env TZ="America/Chicago" \
    --env "VIRTUAL_HOST=pihole.agill.xyz,pihole.local" \
    --env "LETSENCRYPT_HOST=pihole.agill.xyz" \
    --env "LETSENCRYPT_EMAIL=notgnoshi@gmail.com" \
    pihole/pihole:latest

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ]; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2>/dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ]; then
        echo -e "\nTimed out waiting for Pi-hole start, consult check your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done

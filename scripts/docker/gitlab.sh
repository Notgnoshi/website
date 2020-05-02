#!/bin/bash

docker run \
    --detach \
    --hostname git.agill.xyz \
    --publish 2200:22 \
    --name gitlab \
    --cpus=2 \
    --memory=4g \
    --restart unless-stopped \
    --volume /srv/gitlab/etc/gitlab:/etc/gitlab \
    --volume /srv/gitlab/var/log/gitlab:/var/log/gitlab \
    --volume /srv/gitlab/var/opt/gitlab:/var/opt/gitlab \
    --volume /home/git/.ssh/authorized_keys_proxy:/gitlab-data/ssh/authorized_keys \
    --volume /etc/localtime:/etc/localtime:ro \
    --env GITLAB_OMNIBUS_CONFIG="external_url 'https://git.agill.xyz'; nginx['listen_port']=80; nginx['listen_https']=false; nginx['proxy_set_headers']={'X-Forwarded-Proto' => 'https', 'X-Forwarded-Ssl' => 'on'}" \
    --env "VIRTUAL_HOST=git.agill.xyz" \
    --env "LETSENCRYPT_HOST=git.agill.xyz" \
    --env "LETSENCRYPT_EMAIL=notgnoshi@gmail.com" \
    gitlab/gitlab-ce:latest

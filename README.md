# WWW

Repository for [agill.xyz](https://agill.xyz) and all subdomains, as well as any shared content and Nginx configuration.

---

## Repository Layout

* `agill.xyz/` - Django project for [agill.xyz](https://agill.xyz).
* `research.agill.xyz` - Django project for [research.agill.xyz](https://research.agill.xyz).
* `shared_content/` - Static content and configuration shared across all Django projects. Things like CSS, headers, footers, etc. The `smylinks.py` script generates the necessary symlinks for each project to find this chared content.
* `nginx/` - Nginx and uWSGI configurations for each subdomain.
* `symlinks.py` - Script to create symlinks for shared static content and Nginx configurations as above.
* `deploy.py` - Deploys Nginx and uWSGI configurations to where they need to go.

## TODO

* What about large binary assets like PDFs, video, music, etc?
* Maybe make `deploy.py` detect if a config is already there and make a backup?
* Put sockets in `/run/`. Will require googling?
* Add uWSGI master process to Emperor?
* Add development Nginx configs that don't require SSL. Other option: Use `./manage.py runserver`
* Add rest of static subdomains (minecraft, todo)
* Add Nginx config for Pihole, Plex, Netdata, DokuWiki, Gogs, Blog, etc.
* Collect scripts into one.
* Figure out how to easily set up a development environment

## Deploying with Nginx and uWSGI

1. Run `sudo ./secret.py` to create a Django secret to `/etc/django/secret.txt`. Only needs to be ran once.
2. Run `./symlinks.py`
3. In each subdomain, run `./manage.py collectstatic`.
4. Then deploy the Nginx and uWSGI configurations by running the `deploy.py` script.

    ```shell
    sudo ./deploy.py --clean
    sudo ./deploy.py --enable --startup

    sudo systemctl daemon-reload
    sudo service nginx restart
    sudo service emperor start

    less /tmp/emperor.log
    less /var/log/nginx/error.log
    ```

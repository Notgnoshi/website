# WWW

Top level repository for [agill.xyz](https://agill.xyz) and all subdomains.

---

## Repository Layout

* `agill.xyz/` - Submodule containing the Django static site for [agill.xyz](https://agill.xyz).
* `research.agill.xyz` - Submodule containing the Django static site for [research.agill.xyz](https://research.agill.xyz).
* `shared_content/` - Static content and configuration shared across all subdomain submodule. Things like CSS, headers, footers, etc. The `smylinks.py` script generates the necessary symlinks for each submodule to find this chared content.
* `nginx/` - Nginx and uWSGI configurations for each subdomain.
* `symlinks.py` - Script to create symlinks for shared static content and Nginx configurations as above.
* `deploy.py` - After updating each submodule (can be done recursively from the top level), run the deploy script to reload Nginx, etc.

## TODO

* What about large binary assets like PDFs, video, music, etc?
* Maybe make `deploy.py` detect if a config is already there and make a backup?
* Put sockets in `/run/`. Will require googling?
* Add uWSGI master process to Emperor?
* Add development Nginx configs that don't require SSL. Other option: Use `./manage.py runserver`

## Deploying with Nginx and uWSGI

1. Run `sudo ./secret.py` to create a Django secret to `/etc/django/secret.txt`.
2. In each subdomain, run `./manage.py collectstatic`.
3. Then deploy the Nginx and uWSGI configurations by running the `deploy.py` script.

    ```shell
    ./deploy.py --clean --dryrun
    sudo ./deploy.py --clean
    ./deploy.py --enable --startup --dryrun
    sudo ./deploy.py --enable --startup

    sudo systemctl daemon-reload
    sudo systemctl restart nginx.service
    sudo systemctl start emperor.service

    less /tmp/emperor.log
    less /var/log/nginx/error.log
    ```

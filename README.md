# web

Top level repository for all subdomains on [agill.xyz](https://agill.xyz)

---

## Repository Layout

* `agill.xyz/` - Submodule containing the Django static site for [agill.xyz](https://agill.xyz).
* `shared_content/` - Static content and configuration shared across all subdomain submodule. Things like CSS, headers, footers, etc. A Git Submodule symlinked to `<subdomain>/<django_app>/pages/static/` for each subdomain.
* `nginx/` - Nginx configurations for each subdomain.
* `symlinks.sh` - Script to create symlinks for shared static content and Nginx configurations as above.
* `deploy.sh` - After updating each submodule (can be done recursively from the top level), run the deploy script to reload Nginx, etc.

## TODO

* What about large binary assets like PDFs, video, music, etc?
* Look at actual Nginx configs
* Add project secret key somewhere in `/etc/`. Read this key in each `settings.py` file, rather than hard-coding it. Follow the Django deployment checklist.
* Maybe make `deploy.py` detect if a config is already there and make a backup?
* Put sockets in `/run/`. Will require googling?
* Test on server.
* Add uWSGI master process to Emperor?

## Deploying with Nginx and uWSGI

First, in each subdomain, run `./manage.py collectstatic`. Then deploy the Nginx and uWSGI configurations by running the `deploy.py` script.

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

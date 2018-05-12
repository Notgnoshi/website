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

* Serve content with Nginx, not Django.

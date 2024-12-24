# Website

Repository for [agill.xyz](https://agill.xyz) and its Nginx configuration.

## Local development

To develop locally, do

```bash
./scripts/docker/web-nginx-proxy.sh
./scripts/docker/web-root.sh
```

and access the site at <http://localhost>.

> [!WARNING]
>
> You may also need to delete some of the auto-generated letsencrypt Nginx configuration before the
> `nginx-proxy` container will correctly proxy on `localhost`.

Alternatively, you can run _just_ `web-root.sh` and use

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-root
```

to find the IP address of the `nginx-root` container

### Rendering drafts

Run the script

```bash
# You probably want to do this in a venv
pip install -r requirements.txt
./scripts/drafts.sh
```

this will render each draft in `drafts/*.md` to HTML pages in `root/drafts/*.html` accessible at
<http://localhost/drafts>. When it comes time to publish a draft,

1. Move the generated HTML from `root/drafts/` to `root/`
2. Edit the `root/index.html` with a link and appropriate date/description

### Debugging URL rewrites

To debug Nginx redirection rules, you can modify/run

```bash
$ docker restart nginx-root && sleep 0.5 && ./scripts/check-redirects.sh
URL                                              Resolved URL                       HTTP Response
http://localhost                                 http://localhost/                  200
http://localhost/                                http://localhost/                  200
http://localhost/index.html                      http://localhost/                  200
http://localhost/index                           http://localhost/index             200
http://localhost/css                             http://localhost/css/              200
http://localhost/css/                            http://localhost/css/              200
http://localhost/css/index.html                  http://localhost/css/              200
http://localhost/vim                             http://localhost/vim               200
http://localhost/vim/                            http://localhost/vim/              200
http://localhost/vim/index.html                  http://localhost/vim/              200
http://localhost/vim/index                       http://localhost/vim/index         200
http://localhost/vim.html                        http://localhost/vim               200
http://localhost/vim/text-objects                http://localhost/vim/text-objects  200
http://localhost/vim/text-objects/               http://localhost/vim/text-objects  200
http://localhost/vim/text-objects.html           http://localhost/vim/text-objects  200
http://localhost/vim/text-objects/index.html     http://localhost/vim/text-objects  200
http://localhost/graphviz                        http://localhost/graphviz          200
http://localhost/graphviz/                       http://localhost/graphviz          200
http://localhost/graphviz.html                   http://localhost/graphviz          200
http://localhost/graphviz/index.html             http://localhost/graphviz          200
http://localhost/404.html                        http://localhost/404               404
http://localhost/blog/product-spaces             http://localhost/product-spaces    200
http://localhost/blog/product-spaces/            http://localhost/product-spaces    200
http://localhost/blog/product-spaces.html        http://localhost/product-spaces    200
http://localhost/blog/product-spaces/index.html  http://localhost/product-spaces    200
```

### RSS Feed

To update the `https://agill.xyz/rss.xml` RSS feed, run

```bash
./scripts/rss.sh
```

## Production

To deploy to production, clone the repository to a suitable host (one that `agill.xyz` resolves to),
and run

```bash
./scripts/docker/web-nginx-proxy.sh
./scripts/docker/web-nginx-https.sh
./scripts/docker/web-root.sh
```

and access the site at `https://agill.xyz`

To reload Nginx configuration, you may simply restart the `nginx-root` container started by
`web-root.sh`. The proxy and acme containers use shared Docker volumes to persist the SSL
certificates.

## Haiku generation API

If you want to deploy the haiku generation API container, you must first build the `notgnoshi/api`
container from https://github.com/Notgnoshi/research Then you can run

```bash
./scripts/docker/research.sh
```

to start the container. This requires https://github.com/Notgnoshi/research to be cloned to
`/srv/research`, and the repository data to be initialized.

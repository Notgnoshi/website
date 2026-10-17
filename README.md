# Website

Repository for [agill.xyz](https://agill.xyz) and its Nginx configuration.

## Local development

To develop locally, do

```bash
docker compose rm -f && docker compose up
```

and access the site at <http://localhost>.

## Production

The only difference between dev and prod is the ACME SSL certificate management.

```bash
docker compose --profile prod up -d
docker compose --profile prod logs -f
```

### Debugging URL rewrites

To debug Nginx redirection rules, you can modify/run

```bash
$ ./scripts/check-redirects.sh
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
```

### Virtual environment

Both the RSS feed generation and draft rendering scripts require Python dependencies.

```bash
python -m venv --prompt website .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### RSS Feed

To update the `https://agill.xyz/rss.xml` RSS feed, run

```bash
./scripts/rss.sh
```

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

## Access logs

To export the access logs for analysis, run

```bash
./scripts/export-logs.sh
```

It rotates `logs/access.log` and generates `logs/export-YYYY-MM-DD.tar.gz`.

To build a report, install GoAccess with `sudo dnf install goaccess` and run

```bash
./scripts/analyze-logs.sh logs/export-YYYY-MM-DD.tar.gz
```

It writes `logs/export-YYYY-MM-DD/report.html`.

#!/usr/bin/env python3
"""Parse the HTML and generate an RSS feed for agill.xyz."""
import argparse
import datetime
import logging
import operator
import pathlib
import sys
from typing import Iterable, Optional, Tuple

import lxml
from feedgen.feed import FeedGenerator

logger = logging.getLogger("generate-rss-feed.py")

REPO_ROOT = pathlib.Path(__file__).parent.parent
SITE_ROOT = REPO_ROOT / "root"
SITE_TITLE = "agill.xyz"
SITE_DOMAIN = "https://agill.xyz"
SITE_DESCRIPTION = "Another personal website"


def parse_args():
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        "--log-level",
        "-l",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the log level",
    )
    parser.add_argument(
        "--output",
        "-o",
        type=argparse.FileType("w"),
        default=sys.stdout,
        help="Script output. Defaults to stdout.",
    )

    return parser.parse_args()


def get_pages(root: pathlib.Path) -> Iterable[pathlib.Path]:
    logger.info("Getting site pages from %s", root)
    return root.glob("**/*.html")


def get_page_head(page: pathlib.Path) -> lxml.etree.ElementTree:
    parser = lxml.etree.HTMLParser()
    with page.open() as f:
        tree = lxml.etree.parse(f, parser)
    head = tree.getroot().cssselect("head")

    if head:
        return head[0]
    else:
        logger.warning("Failed to get <head>...</head> from %s", page)
        return None


def get_meta_content(meta: lxml.etree.Element) -> Optional[Tuple]:
    if "name" not in meta.keys() or "content" not in meta.keys():
        return None
    return meta.get("name"), meta.get("content")


def get_all_meta_content(metas: Iterable[lxml.etree.Element]) -> dict:
    metadata = {}
    for meta in metas:
        m = get_meta_content(meta)
        if m is not None:
            name, content = m
            if name in metadata:
                logger.warning(
                    "Duplicate metadata '%s'='%s' (duplicates '%s'='%s')",
                    name,
                    content,
                    name,
                    metadata[name],
                )
            else:
                metadata[name] = content
    return metadata


def get_page_relative_url(page: pathlib.Path) -> str:
    page = page.relative_to(SITE_ROOT)
    parent = page.parent
    name = page.stem

    url = "/"
    if parent != pathlib.Path("."):
        url += str(parent) + "/"

    if name != "index":
        url += name + "/"

    return url


def get_page_metadata(page: pathlib.Path) -> dict:
    logger.debug("Getting page metadata for %s", page)
    head = get_page_head(page)
    if head is None:
        return None

    metas = head.cssselect("meta")
    metadata = get_all_meta_content(metas)
    titles = head.cssselect("title")
    if titles:
        metadata["title"] = titles[0].text
    url = get_page_relative_url(page)
    metadata["relative_url"] = url

    # TODO: metadata["authors"] = [(name, email), ...]
    # TODO: keywords require a term, scheme, and label for each category

    return metadata


def get_all_metadata(pages: Iterable[pathlib.Path]) -> Iterable[dict]:
    logger.info("Getting metadata from pages")
    for page in pages:
        metadata = get_page_metadata(page)
        if metadata is not None:
            logger.debug("Got metadata: %s", metadata)
            yield metadata


def add_page_to_feed(feed: FeedGenerator, page: dict):
    if "relative_url" not in page:
        logger.warning("Attempted to add page to feed without relative URL")
        return
    if "description" not in page:
        logger.warning("Attempted to add %s to feed without description", page["relative_url"])
        return
    if "title" not in page:
        logger.warning("Attempted to add %s to feed without title", page["relative_url"])
        return

    # This should be guaranteed by filtering out pages missing this metadata ahead of time.
    if "dcterms.available" not in page:
        logger.error("Published date not found for pat %s", page["relative_url"])
        return

    entry = feed.add_entry()
    entry.title(page["title"])
    url = SITE_DOMAIN + page["relative_url"]
    entry.link(href=url)
    entry.id(url)
    entry.description(page["description"])

    if "authors" in page:
        # according to https://feedgen.kiesow.be/api.entry.html#feedgen.entry.FeedEntry.author,
        # email is required for RSS
        for author, email in page["authors"]:
            entry.author(author=author, email=email)

    # TODO: https://feedgen.kiesow.be/api.entry.html#feedgen.entry.FeedEntry.category is confusing
    # if "keywords" in page:
    #     categories = [{"term": t, "scheme": s, "label": l} for t, s, l in page["keywords"]]
    #     entry.category(categories)

    published_date = page["dcterms.available"]
    published_date = datetime.datetime.fromisoformat(published_date)
    # If the datetime doesn't have a timezone, add one.
    # TODO: What does this do when the published date is actually an ISO-8601 timestamp with seconds?
    published_date = published_date.astimezone()
    entry.published(published_date)

    modified_date = page.get("dcterms.modified", "")
    if modified_date and modified_date.lower() != "draft":
        modified_date = datetime.datetime.fromisoformat(modified_date)
        modified_date = modified_date.astimezone()
        entry.updated(modified_date)


def add_pages_to_feed(feed: FeedGenerator, pages: Iterable[dict]):
    for page in pages:
        add_page_to_feed(feed, page)


def generate_feed(pages: Iterable[dict]) -> FeedGenerator:
    fg = FeedGenerator()
    fg.title(SITE_TITLE)
    # TODO: Load this description from the index metadata?
    fg.description(SITE_DESCRIPTION)
    # TODO: Host this RSS file.
    fg.link(href=SITE_DOMAIN + "/rss.xml", rel="self")
    fg.link(href=SITE_DOMAIN, rel="alternate")

    logger.info("Adding page metadata to RSS feed.")
    add_pages_to_feed(fg, pages)

    return fg


def main(args):
    # 1. Get a list of site pages
    pages = get_pages(SITE_ROOT)
    # 2. Extract metadata from pages
    pages = get_all_metadata(pages)

    # Filter out pages without a published date.
    pages = (page for page in pages if "dcterms.available" in page)
    # Filter out draft pages
    pages = (page for page in pages if page["dcterms.available"].lower() != "draft")
    pages = list(pages)
    # 3. Sort pages by publish date.
    # NOTE: This does a lexicographical sort of the text representation of the date. But I have
    # control over what the dates look like, so I can guarantee an ISO-8601 format.
    pages.sort(key=operator.itemgetter("dcterms.available"))

    # 4. Pass metadata into feedgen
    feed = generate_feed(pages)

    rss = feed.rss_str(pretty=True, encoding="utf-8")
    args.output.write(rss.decode("utf-8"))


if __name__ == "__main__":
    args = parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s: %(message)s",
        level=args.log_level,
        stream=sys.stderr,
    )
    main(args)

#!/usr/bin/env python3
"""Convert markdown to HTML."""
import argparse
import logging
import sys

import mistune

LOG_LEVELS = {
    "CRITICAL": logging.CRITICAL,
    "ERROR": logging.ERROR,
    "WARNING": logging.WARNING,
    "INFO": logging.INFO,
    "DEBUG": logging.DEBUG,
}
DEFAULT_LEVEL = "INFO"


def parse_args():
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--log-level",
        "-l",
        type=str,
        default=DEFAULT_LEVEL,
        choices=LOG_LEVELS.keys(),
        help=f"Set the logging output level. Defaults to {DEFAULT_LEVEL}.",
    )
    group = parser.add_argument_group()
    group.add_argument(
        "--input",
        "-i",
        type=argparse.FileType("r"),
        default=sys.stdin,
        help="Markdown input path. Defaults to stdin.",
    )
    group.add_argument(
        "--output",
        "-o",
        type=argparse.FileType("w"),
        default=sys.stdout,
        help="HTML output path. Defaults to stdout.",
    )
    group = parser.add_argument_group()
    group.add_argument(
        "--page-template",
        "-p",
        type=argparse.FileType("r"),
        default=None,
        help="If given, the path to a Jinja2 template to use for the whole page.",
    )

    return parser.parse_args()


def main(args):
    parser = mistune.create_markdown()
    markdown = args.input.read()

    # TODO: Support markdown with frontmatter: https://github.com/lepture/mistune/issues/211
    html = parser(markdown)
    # TODO: Support writing the HTML to the {% content %} section of a Jinja2 template
    args.output.write(html)


if __name__ == "__main__":
    args = parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(module)s - %(levelname)s: %(message)s",
        level=LOG_LEVELS.get(args.log_level),
        stream=sys.stderr,
    )
    main(args)

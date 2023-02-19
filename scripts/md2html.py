#!/usr/bin/env python3
"""Convert markdown to HTML."""
import argparse
import logging
import sys

import frontmatter
import jinja2
import mistune

LOG_LEVELS = {
    "CRITICAL": logging.CRITICAL,
    "ERROR": logging.ERROR,
    "WARNING": logging.WARNING,
    "INFO": logging.INFO,
    "DEBUG": logging.DEBUG,
}
DEFAULT_LEVEL = "INFO"


class BootstrappedHtmlRenderer(mistune.HTMLRenderer):
    """A customized HTMLRenderer that adds Bootstrap classes and other customizations."""

    def __init__(self, escape=True, allow_harmful_protocols=None):
        super().__init__(escape, allow_harmful_protocols)

    def image(self, src, alt="", title=""):
        src = self._safe_url(src)
        alt = mistune.util.escape_html(alt)
        inline_title = f' title="{title}"' if title else ""
        inline_caption = (
            f'<figcaption class="figure-caption text-right">{title}</figcaption>' if title else ""
        )
        # TODO: This wraps the figure in <p></p> tags. Is that okay?
        return f'<figure class="figure d-block mx-auto w-100"><img class="figure-img img-fluid rounded w-100" src="{src}" alt="{alt}" {inline_title}/>{inline_caption}</figure>'

    def block_code(self, code, info=None):
        if info is not None:
            info = info.strip()
        lang = None
        if info:
            lang = info.split(None, 1)[0]
            lang = mistune.util.escape_html(lang)
        inline_lang = f"language-{lang} " if lang else ""
        code = mistune.util.escape(code)
        return f'<pre><code class="{inline_lang}pl-3">{code}</code></pre>\n'

    def block_quote(self, text):
        return f'<blockquote class="blockquote border-left border-2 pl-2">\n{text}</blockquote>\n'

    # TODO: Tables: https://mistune.readthedocs.io/en/latest/plugins.html#table
    # TODO: Admonitions: https://mistune.readthedocs.io/en/latest/directives.html#admonitions
    # TODO: LaTeX with KaTeX


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
    renderer = BootstrappedHtmlRenderer(escape=False)
    parser = mistune.create_markdown(renderer=renderer)
    metadata = frontmatter.load(args.input)
    html = parser(metadata.content)
    metadata["content"] = html

    if args.page_template:
        template = jinja2.Template(args.page_template.read())
        html = template.render(metadata)

    args.output.write(html)


if __name__ == "__main__":
    args = parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(module)s - %(levelname)s: %(message)s",
        level=LOG_LEVELS.get(args.log_level),
        stream=sys.stderr,
    )
    main(args)

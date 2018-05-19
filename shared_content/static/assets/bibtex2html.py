#!/usr/bin/env python3
import sys

import bibtexparser as bib


def main(bibtex):
    with open(bibtex) as b:
        db = bib.load(b)

    for entry in db.entries:
        print(f'<li class="source"><span class="bibtex-id"><code>{entry["ID"]}</code></span><a href="">{entry["title"].title()}</a></li>')

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0]} <sources.bib>')
    else:
        main(sys.argv[1])

#!/usr/bin/env python3
"""Downloads latest player skin renders, and generates HTML for player cards."""
import argparse
import json
import pathlib
import sys
import urllib.request

import jinja2

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
RENDERS_DIR = REPO_ROOT / "images" / "players"


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "-o",
        "--output",
        type=pathlib.Path,
        default=RENDERS_DIR,
        help="Directory to output the skin renders and HTML player cards.",
    )
    parser.add_argument(
        "--json",
        type=pathlib.Path,
        default=REPO_ROOT / "assets" / "players.json",
        help="Path to JSON metadata file defining which players to download skin renders and cards to generate.",
    )
    parser.add_argument(
        "--template",
        type=pathlib.Path,
        default=REPO_ROOT / "templates" / "player-cards-template.html",
        help="The path to the HTML player cards template.",
    )
    parser.add_argument(
        "--renders", action="store_true", default=False, help="Whether to player skin renders."
    )
    parser.add_argument(
        "--html", action="store_true", default=False, help="Whether to generate HTML player cards."
    )
    return parser.parse_args()


def renders(players: dict, outdir: pathlib.Path):
    """Retreive Minecraft player skin renders and save them in the given directory.

    :param players: dict containing an array of players
    :param outdir: The directory to save the skin renders to.
    """
    for player in players["players"]:
        urllib.request.urlretrieve(
            f"https://crafatar.com/renders/body/{player['uuid']}?overlay&scale=10&default=MHF_Steve",
            outdir / (player["uuid"] + ".png"),
        )


def html(players: dict, template_file: pathlib.Path):
    with template_file.open() as f:
        template = jinja2.Template(f.read())
    cards = template.render(players)
    print(cards)


def main(args):
    if not args.json.exists():
        print("JSON metadata file does not exist.")
        sys.exit(1)

    with args.json.open() as f:
        players = json.load(f)

    if args.renders:
        renders(players, args.output)
    if args.html:
        html(players, args.template)


if __name__ == "__main__":
    main(parse_args())

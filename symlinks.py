#!/usr/bin/env python3
import argparse
from pathlib import Path


# Paths are absolute or relative to this script.
SUBDOMAINS = [
    'agill.xyz',
    'research.agill.xyz',
    'mc.agill.xyz',
]

SHARED_CONTENT = {
    'shared_content/includes/': 'pages/templates/includes/',
    'shared_content/static/': 'pages/static/',
}


def parse_args():
    parser = argparse.ArgumentParser(description='Builds the symlinks between all of the shared content and each subdomain of agill.xyz')

    parser.add_argument('-n', '--dryrun',
                        action='store_true',
                        default=False,
                        help='Perform a verbose dry run.')

    return parser.parse_args()


def create_symlinks(content, dryrun):
    """
        Given a dictionary of src: dest paths, create the symlinks.

        Note that each dest is prepended by each subdomain.
    """
    for subdomain in SUBDOMAINS:
        for src, dest in content.items():
            src = Path(src)
            dest = Path(subdomain).joinpath(dest)

            print('LINKING:', str(src), '-->', str(dest))

            if dest.exists():
                print('NOTE:', str(dest), 'exists! Unlinking.')
                if not dryrun:
                    dest.unlink()

            if not dryrun:
                dest.symlink_to(src.resolve())

def main(args):
    if args.dryrun:
        print('Performing dry run. No symlinks will be created or unlinked.')
    create_symlinks(SHARED_CONTENT, args.dryrun)


if __name__ == '__main__':
    main(parse_args())

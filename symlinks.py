#!/usr/bin/env python3
import argparse
import sys
from pathlib import Path


# Paths are absolute or relative to this script.
SUBDOMAINS = [
    'agill.xyz/agill_xyz/',
]

SHARED_CONTENT = {
    'shared_content/includes/': 'pages/templates/includes/',
    'shared_content/static/': 'pages/static/',
}

NGINX_CONTENT = {

}


def parse_args():
    parser = argparse.ArgumentParser(description='Builds the symlinks between all of the shared content and each subdomain of agill.xyz')

    parser.add_argument('-n', '--dryrun',
                        action='store_true',
                        default=False,
                        help='Perform a verbose dry run.')
    parser.add_argument('--shared',
                        action='store_true',
                        default=False,
                        help='Symlink the shared content for each subdomain.')
    parser.add_argument('--nginx',
                        action='store_true',
                        default=False,
                        help='Symlink the Nginx configs for each subdomain. Requires sudo privileges.')

    args = parser.parse_args()
    if not args.shared or args.nginx:
        parser.print_help()
        sys.exit(0)
    return args


def create_symlinks(content, dryrun):
    """
        Given a dictionary of src: dest paths, create the symlinks.

        Note that each dest is prepended by each subdomain.
    """
    for subdomain in SUBDOMAINS:
        for src, dest in content.items():
            src = Path(src)
            dest = Path(subdomain + dest)

            print(f'LINKING: {src} --> {dest}')

            if dest.exists():
                print(f'NOTE: {dest} exists! Unlinking.')
                if not dryrun:
                    dest.unlink()

            if not dryrun:
                dest.symlink_to(src.resolve())

def main(args):
    if args.dryrun:
        print('Performing dry run. No symlinks will be created or unlinked.')
    if args.shared:
        create_symlinks(SHARED_CONTENT, args.dryrun)

    if args.nginx:
        create_symlinks(NGINX_CONTENT, args.dryrun)

if __name__ == '__main__':
    main(parse_args())

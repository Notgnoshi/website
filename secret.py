#!/usr/bin/env python3
import argparse
import os
import secrets
import sys
from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser(description='Generates and saves the Django secret key.')

    parser.add_argument('-n', '--dryrun',
                        action='store_true',
                        default=False,
                        help='Perform a verbose dry run.')

    parser.add_argument('--path',
                        type=str,
                        default='/etc/django/secret.txt',
                        help='The path to save the secret to.')

    return parser.parse_args()


def main(args):
    secret = secrets.token_hex(256)
    path = Path(args.path)

    if args.dryrun:
        print('NOTE: Dry run. Generated:', secret)
        if not path.parent.exists():
            print('NOTE:', str(path.parent), 'doesn\'t exist!')
    else:
        if not path.parent.exists():
            print('NOTE:', str(path.parent), 'doesn\'t exist! Making!')
            path.parent.mkdir()
        print('Writing secret!')
        with open(path, 'w') as f:
            f.write(secret + '\n')

if __name__ == '__main__':
    arguments = parse_args()

    # Only require sudo privileges if we're running the script for real.
    if not arguments.dryrun and os.getuid() != 0:
        print('Script must be ran as root.')
        sys.exit(0)

    main(arguments)

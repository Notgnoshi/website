#!/usr/bin/env python3
import argparse
import os
import sys
from pathlib import Path
from subprocess import call

# The subdomains whose Nginx configuration we are to set up.
SUBDOMAINS = [
    'agill.xyz',
    'research.agill.xyz',
]

UWSGI_VASSAL_PATH = Path('/etc/uwsgi/vassals/')
NGINX_CONFIG_PATH = Path('/etc/nginx/sites-available/')
NGINX_ENABLE_PATH = Path('/etc/nginx/sites-enabled/')


def parse_args():
    parser = argparse.ArgumentParser(description='Sets up the Nginx/WGSI configuration for each subdomain.')

    parser.add_argument('-n', '--dryrun',
                        action='store_true',
                        default=False,
                        help='Perform a verbose dry run.')

    parser.add_argument('--base-path',
                        type=str,
                        default=os.path.dirname(os.path.abspath(__file__)),
                        help='The base path for the main WWW repository.')

    parser.add_argument('--enable',
                        action='store_true',
                        default=False,
                        help='Enable configured Nginx sites? (Also restarts Nginx)')

    parser.add_argument('--startup',
                        action='store_true',
                        default=False,
                        help='Add uWSGI emperor mode to system startup using Systemd.')

    parser.add_argument('--clean',
                        action='store_true',
                        default=False,
                        help='Clean up any created files or symlinks.')

    return parser.parse_args()


def write_nginx_config(subdomain, base_path, dryrun):
    """
        Creates an available site Nginx config in /etc/nginx/sites-available.
    """
    print('='*80)
    print('Writing Nginx config for:', subdomain)

    available = NGINX_CONFIG_PATH.joinpath(subdomain + '.conf')
    src = Path(base_path).joinpath('nginx', subdomain, 'nginx.conf')

    # The actual config depends on where this repository was cloned. So add a magic string to the
    # configuration file and replace it with the actual value.
    with open(src, 'r') as f:
        config = f.read()
        config = config.replace('BASE_REPOSITORY_PATH', base_path)

    if dryrun:
        # Print out modified config to verify it's correct.
        print('NOTE: Dry run. Not writing config:')
        print('='*80)
        print(config)
        print('='*80)
        print('to', str(available))
    else:
        print('Writing Nginx config to', str(available))
        with open(available, 'w') as f:
            f.write(config)

    return available


def enable_nginx_config(available, subdomain, dryrun):
    """
        Given an available Nginx site, enable it by symlinking the config to /etc/nginx/sites-enabled
    """
    print('='*80)
    print('Enabling Nginx config for:', subdomain)

    enable = NGINX_ENABLE_PATH.joinpath(subdomain + '.conf')

    if dryrun:
        print('NOTE: Dry run. Not enabling config:', str(available), '-->', str(enable))
        if enable.exists():
            print('NOTE:', str(enable), 'exists! Dry run. Not unlinking!')
    else:
        print('Enabling Nginx config', str(available))
        if enable.exists():
            print('NOTE:', str(enable), 'exists! Unlinking!')
            enable.unlink()
        enable.symlink_to(available)

        print('Testing Nginx config')
        # If it's an option to test the config, why wouldn't you?!
        call(['/etc/init.d/nginx', 'configtest'])
        call(['/etc/init.d/nginx', 'restart'])


def write_uwsgi_vassal(subdomain, base_path, dryrun):
    """
        Write the uWSGI vassal and emperor configurations to /etc/uwsgi/.
    """
    print('='*80)
    print('Writing uWSGI vassal for:', subdomain)

    vassal = UWSGI_VASSAL_PATH.joinpath(subdomain + '.ini')
    vassal_src = Path(base_path).joinpath('nginx', subdomain, 'uwsgi.ini')
    emperor = Path('/etc/uwsgi/emperor.ini')
    emperor_src = Path(base_path).joinpath('nginx', 'emperor.ini')

    # The actual config depends on where this repository was cloned. So add a magic string to the
    # configuration file and replace it with the actual value.
    with open(vassal_src, 'r') as f:
        config = f.read()
        config = config.replace('BASE_REPOSITORY_PATH', base_path)

    if dryrun:
        print('NOTE: Dry run. Not writing vassal:')
        print('='*80)
        print(config)
        print('='*80)
        print('to', str(vassal))
        print('NOTE: Dry run. Not writing Emperor config to', str(emperor))

        if not vassal.parent.exists():
            print('NOTE:', str(vassal.parent), 'doesn\' exist!')
        if not emperor.exists():
            print('NOTE:', str(emperor), 'doesn\'t exist!')
    else:
        print('Writing uWSGI vassal to', str(vassal))
        if not vassal.parent.exists():
            print('NOTE:', str(vassal.parent), 'doesn\'t exist! Creating.')
            vassal.parent.mkdir(parents=True)
        with open(vassal, 'w') as f:
            f.write(config)

        print('Symlinking Emperor config:', str(emperor_src), '-->', str(emperor))
        if emperor.exists():
            print('NOTE: Emperor config exists! Unlinking!')
            emperor.unlink()
        emperor.symlink_to(emperor_src)


def set_uwsgi_startup(base_path, dryrun):
    """
        Symlink the emperor service to /etc/systemd/emperor.service
    """
    print('='*80)
    print('Enabling uWSGI Emperor on startup.')

    service = Path('/etc/systemd/system/emperor.service')
    service_src = Path(base_path).joinpath('nginx', 'emperor.service')

    if dryrun:
        print('NOTE: Dry run. Not symlinking', str(service_src), '-->', str(service))
        if service.exists():
            print('NOTE:', str(service), 'exists! Dry run. Not unlinking!')
    else:
        if service.exists():
            print('NOTE:', str(service), 'exists! Unlinking!')
            service.unlink()
        service.symlink_to(service_src)

        # If we've modified any services, reload them.
        call(['systemctl', 'daemon-reload'])
        call(['systemctl', 'restart', 'emperor.service'])


def clean_up(dryrun):
    """
        Cleans up after script. Removes any generated symlinks or files.
    """
    print('Cleaning up generated files')
    for subdomain in SUBDOMAINS:
        # Clean up Nginx configs
        enable = NGINX_ENABLE_PATH.joinpath(subdomain + '.conf')
        print('Cleaning:', str(enable))
        available = NGINX_CONFIG_PATH.joinpath(subdomain + '.conf')
        print('Cleaning:', str(available))
        # Clean up uWSGI vassals
        vassal = UWSGI_VASSAL_PATH.joinpath(subdomain + '.ini')
        print('Cleaning:', str(vassal))

        if not dryrun:
            for f in [enable, available, vassal]:
                if f.exists():
                    f.unlink()

    # Clean up uWSGI Emperor
    emperor = Path('/etc/uwsgi/emperor.ini')
    print('Cleaning:', str(emperor))
    # Clean up Systemd service
    service = Path('/etc/systemd/system/emperor.service')
    print('Cleaning:', str(service))

    if not dryrun:
        print('Stopping Emperor service')
        call(['systemctl', 'stop', 'emperor.service'])

        for f in [emperor, service]:
            if f.exists():
                f.unlink()
        print('Reloading Systemd services')
        call(['systemctl', 'daemon-reload'])
        print('Restarting Nginx')
        call(['systemctl', 'restart', 'nginx.service'])


def main(args):
    if args.dryrun:
        print('Performing dry run. Not modifying any existing configurations.')

    print('Using base repository path:', args.base_path)
    if args.clean:
        clean_up(args.dryrun)
        sys.exit(0)

    for subdomain in SUBDOMAINS:
        available = write_nginx_config(subdomain, args.base_path, args.dryrun)

        if args.enable:
            enable_nginx_config(available, subdomain, args.dryrun)

        write_uwsgi_vassal(subdomain, args.base_path, args.dryrun)

    if args.startup:
        set_uwsgi_startup(args.base_path, args.dryrun)

    print('='*80)
    print('Now use one of:')
    print('`sudo uwsgi --ini /etc/uwsgi/emperor.ini`')
    print('`sudo systemctl start emperor.service`')
    print('To start uWSGI Emperor')


if __name__ == '__main__':
    arguments = parse_args()

    # Only require sudo privileges if we're running the script for real.
    if not arguments.dryrun and os.getuid() != 0:
        print('Script must be ran as root.')
        sys.exit(0)

    main(arguments)

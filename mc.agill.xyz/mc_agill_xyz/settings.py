"""
Django settings for mc_agill_xyz project.

Generated by 'django-admin startproject' using Django 2.0.5.

For more information on this file, see
https://docs.djangoproject.com/en/2.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/2.0/ref/settings/
"""

import os
from pathlib import Path

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/2.0/howto/deployment/checklist/

with open('/etc/django/secret.txt', 'r') as f:
    SECRET_KEY = f.read().strip()

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ALLOWED_HOSTS = ['mc.localhost', 'mc.agill.xyz']

APPEND_SLASH = True

# Application definition

INSTALLED_APPS = (
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'pages',
)

TEMPLATES = [
    {
        # Or use 'django.template.backends.jinja2.Jinja2' for Jinja2...
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'mc_agill_xyz.constants.domain_constants',
                'mc_agill_xyz.constants.subdomain_constants',
            ]
        }
    },
]

MIDDLEWARE = (
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.security.SecurityMiddleware',
)
MESSAGE_STORAGE = 'django.contrib.messages.storage.cookie.CookieStorage'
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
X_FRAME_OPTIONS = 'DENY'
SECURE_SSL_REDIRECT = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_SECONDS = 1024
SECURE_HSTS_PRELOAD = True
# Some subdomains will not have SSL
SECURE_HSTS_INCLUDE_SUBDOMAINS = False
ROOT_URLCONF = 'mc_agill_xyz.urls'
WSGI_APPLICATION = 'mc_agill_xyz.wsgi.application'
STATIC_URL = '/static/'
# path relative to manage.py
STATIC_ROOT = str(Path('../shared_content/staticroot/').resolve())
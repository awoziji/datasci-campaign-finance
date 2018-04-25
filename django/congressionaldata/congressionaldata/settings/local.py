"""
Local settings for congressionaldata project.

Generated by 'django-admin startproject' using Django 2.0.2.

For more information on this file, see
https://docs.djangoproject.com/en/2.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/2.0/ref/settings/
"""

from congressionaldata.settings.common import *

ALLOWED_HOSTS = []
CORS_ORIGIN_WHITELIST = ('localhost:8080', '127.0.0.1:8080')

# Database
# https://docs.djangoproject.com/en/2.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ['LOCAL_POSTGRES_DATABASE_NAME'],
        'USER': os.environ['LOCAL_POSTGRES_USER'],
        'PASSWORD': os.environ['LOCAL_POSTGRES_PASSWORD'],
        'HOST': 'localhost',
        'PORT': '',
    }
}

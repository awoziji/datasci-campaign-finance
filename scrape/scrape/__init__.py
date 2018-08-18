"""Scrape."""
import logging
import pkg_resources

__version__ = pkg_resources.require(__package__)[0].version
__api_version__ = __version__.split('.')[0]

logging.basicConfig(level=logging.DEBUG)
logging.info('Scrape version: %s, api_version: %s',
             __version__, __api_version__)

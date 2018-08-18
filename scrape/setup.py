import setuptools

try: # for pip >= 10
    from pip._internal.req import parse_requirements
except ImportError: # for pip <= 9.0.3
    from pip.req import parse_requirements

requirements = parse_requirements('install_requirements.txt', session=False)

def readme():
    with open('README.md') as f:
        return f.read()

setuptools.setup(
    name='scrape',
    version='0.0.1',  # PEP-440
    description='scraper',
    long_description=readme(),
    url='https://github.com',
    license='MIT',

    entry_points = {
        'console_scripts': [
            'scrape = scrape.__main__:main',
        ],
    },

    packages = setuptools.find_packages(exclude=['tests', 'tests.*']),

    # Requirements
    install_requires = [str(x.req) for x in requirements],

    zip_safe = False,  # install source files not egg
    include_package_data = True,  # copy html and friends
)

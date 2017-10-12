"""
Universal Office Converter - Convert between any document format supported by LibreOffice/OpenOffice.

See:
https://github.com/dagwieers/unoconv
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages
# To use a consistent encoding
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))
# Get the long description from the README file
with open(path.join(here, 'README.adoc'), encoding='utf-8') as f:
    long_description = f.read()

setup(name = "unoconv",
      version = "0.7",
      author = "Dag Wieers",
      author_email = "dag.wieers@gmail.com",
      url = "https://github.com/dagwieers/unoconv",
      description = "Universal Office Converter - Convert between any document format supported by LibreOffice/OpenOffice.",
      scripts = ["unoconv"],
      # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
      classifiers = [
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Intended Audience :: Education',
        'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3',
        'Topic :: Documentation',     
        'Topic :: Office/Business :: Office Suites',
        'Topic :: Utilities',

      ]
)

from setuptools import setup, find_packages
from io import open


def adoc2rst(text):
    levels = '=-~.^'
    lines = text.split('\n')
    result = []
    for line in lines:
        # Get rid of extra whitespace
        line = line.strip()

        if not line:
            result.append(line)
        elif line[0] == '=':
            # This is a header
            header = line.rstrip('=')
            level = len(line) - len(header)
            header = header.strip()
            result.append(header)
            result.append(levels[level] * len(header))

    return '\n'.join(result)


with open('README.adoc', 'rt', encoding='UTF-8') as f:
    long_description = adoc2rst(f.read())


setup(name = "unoconv",
      version = "0.8",
      author = "Dag Wieers",
      author_email = "dag.wieers@gmail.com",
      url = "https://github.com/dagwieers/unoconv",
      description = "Universal Office Converter - Office document conversion",
      long_description = long_description,
      scripts = ["unoconv"],
      license = 'GPLv2',
      keywords = 'openoffice uno office conversion',
      classifiers = [
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Topic :: Office/Business :: Office Suites',
        'Topic :: Utilities',
      ],
      zip_safe = False
)

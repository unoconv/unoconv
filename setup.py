from setuptools import setup, find_packages
from io import open


def adoc2rst(text):
    levels = '=-~.^'
    lines = text.split('\n')
    # Flags:
    codeblock = 0
    bullet = ''
    indent = 0

    result = []
    for line in lines:
        # Get rid of extra whitespace
        line = line.rstrip()
        new_indent = len(line) - len(line.strip())

        if not line.strip():
            if not result or result[-1].strip():
                result.append(line)
            continue
        elif line[0] == '=':
            # This is a header
            header = line.rstrip('=')
            level = len(line) - len(header)
            header = header.strip('= ')
            result.append(header)
            result.append(levels[level] * len(header))
            result.append('')
            indent = 0
            codeblock = 0
            continue
        elif line == '----':
            # Code block

            if codeblock == 0:
                codeblock = 1
                result.append('.. code-block::')
                result.append('')
            elif codeblock == 1:
                # End of code
                codeblock = 0
            elif codeblock == 2:
                # We have a '----' codeblock after a '::' codeblock:
                codeblock = 1

            continue
        elif line.strip()[0] in '-*+':
            # Bullet list
            # It's NOT code, even if the line before ended in colon
            if codeblock == 2:
                codeblock = 0
                for x in (-1, -2):
                    if result[x].endswith(':'):
                        result[x] = result[x][:-1]

            new_bullet = line.strip()[0]
            if not bullet or bullet[-1] != new_bullet:
                # New list
                bullet = bullet + new_bullet
        elif new_indent < indent:
            # Outdent (but not a bullet)
            if bullet:
                if bullet != line.strip()[0]:
                    bullet = bullet[:-1]
                    # Bullets must end with a blank line:
                    result.append('')
                indent = new_indent
            if new_indent == 0:
                codeblock = 0

        if new_indent > indent:
            indent = new_indent

        if codeblock:
            line = '    ' + line

        if line and line[-1] == ':':
            line += ':'
            codeblock = 2 # Type 2 codeblock

        result.append(line)

    return '\n'.join(result)


with open('README.adoc', 'rt', encoding='UTF-8') as f:
    long_description = adoc2rst(f.read())


setup(name = "unoconv",
      version = "0.8.2",
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

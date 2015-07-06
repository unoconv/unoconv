try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

long_desc = [
    "unoconv converts between any document format that OpenOffice understands. It uses OpenOffice's UNO bindings for non-interactive conversion of documents.",
    "Supported document formats include Open Document Format (.odt), MS Word (.doc), MS Office Open/MS OOXML (.xml), Portable Document Format (.pdf), HTML, XHTML, RTF, Docbook (.xml), and more.",
]

setup(
    name='unoconv',
    version='0.6',
    url='https://github.com/dagwieers/unoconv',
    license='GPLv2',
    author='Dag Wieers',
    author_email='dag@wieers.com',
    maintainer='Shuge Lee',
    maintainer_email='shuge.lee@gmail.com',
    description='unoconv: Convert between any document format supported by OpenOffice',
    long_description='\n'.join(long_desc),
    scripts=[
        "unoconv",
    ],

    classifiers=[
        'Environment :: Console',
        "Topic :: Utilities",
        "Topic :: Office/Business :: Office Suites",
        "License :: OSI Approved :: GNU General Public License v2 (GPLv2)",
    ],
)

# coding: utf-8

from setuptools import setup
unoconv = __import__("unoconv")

setup(
	name="unoconv",
	version=unoconv.__version__,
	py_modules=["unoconv"],
	entry_points={
        'console_scripts': [
            'unoconv = unoconv:run_unoconv'
            ]
        }
    )

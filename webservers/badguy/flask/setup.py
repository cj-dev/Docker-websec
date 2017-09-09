from setuptools import setup

setup(
    name='Evil app',
    version='0.1',
    long_description=__doc__,
    packages=['evilapp'],
    include_package_data=True,
    zip_safe=False,
    install_requires=['Flask']
)

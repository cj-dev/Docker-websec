from setuptools import setup

setup(
    name='Morally Conflicted Flask App',
    version='0.1',
    long_description=__doc__,
    packages=['app'],
    include_package_data=True,
    zip_safe=False,
    install_requires=['Flask', 'pyopenssl']
)

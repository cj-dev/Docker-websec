FROM python

COPY flask /var/www/flask
RUN cd /var/www/flask && python setup.py install

WORKDIR /var/www/flask/evilapp
CMD ["python", "application.py"]

FROM python

COPY flask /opt/flask
RUN cd /opt/flask && python setup.py install

WORKDIR /opt/flask/app
CMD ["python", "application.py"]

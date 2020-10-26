FROM python:3.6

RUN useradd --create-home --home /home/opc --shell /bin/bash --uid 1001 --user-group opc\
  && pip install opcua cryptography lxml pytz pyyaml coloredlogs

USER opc
RUN mkdir /home/opc/python
COPY --chown=opc:opc ./server.py /home/opc/python/
COPY --chown=opc:opc ./logger_conf.yml /home/opc/python/
WORKDIR /home/opc/python

CMD ["/bin/bash", "-c", "sleep 1000000000"]
#CMD ["python", "server.py"]

FROM debian:stretch

RUN apt-get update 

RUN apt-get install -y python-pip

RUN pip install speedtest-cli influxdb

RUN mkdir -p /speedtest

COPY rpi-speedtest-influx.py /speedtest

ENTRYPOINT ["/usr/bin/python", "-u", "/speedtest/rpi-speedtest-influx.py"]




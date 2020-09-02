# How to use it 

#### 1.Bring up a stack of influxDB nd grafana.
You can use for example the following `docker-compose.yml` example:
```
version: "2"
services:
  grafana:
    image: grafana/grafana
    container_name: grafana
    restart: always
    ports:
      - 3000:3000
    networks:
      - monitoring
    volumes:
      - grafana-volume:/vol01/Docker/monitoring
  influxdb:
    image: influxdb
    container_name: influxdb
    restart: always
    ports:
      - 8086:8086
    networks:
      - monitoring
    volumes:
      - influxdb-volume:/vol01/Docker/monitoring
    environment:
      - INFLUXDB_DB=speedtests
      - INFLUXDB_USER=speedtest
      - INFLUXDB_ADMIN_ENABLED=true
      - INFLUXDB_ADMIN_USER=admin
      - INFLUXDB_ADMIN_PASSWORD=admin 
networks:
  monitoring:
volumes:
  grafana-volume:
  influxdb-volume:

```

#### 2. Run a speedtest 
To run a signle speedtest you can run:
```
docker run --network=host lalx/speedtest-cli
```
#### 3. View the records in influxDB

```
$ docker exec -ti influxdb influx -database  speedtests;
Connected to http://localhost:8086 version 1.8.2
InfluxDB shell version: 1.8.2
> select * from speedtests;
name: speedtests
time                download          ping  upload
----                --------          ----  ------
1599038921480419000 88196688.51191604 7.326 225055634.1590819
1599041825612471000 89772344.58611958 8.351 245223047.7208988
```

#### 4. Schedule periodic testing

You can use a cronjob to run a test on specific time.

Example of yaml definition to run a  crojob in k8s/k3s
```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: speedtest-job
spec:
  schedule: "1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          hostNetwork: true
          containers:
          - name: speedtest
            image: lalx/speedtest-cli:latest
          restartPolicy: OnFailure
```

#### 5. Use grafana 

You can use grafana to plot the speedtests 


## Credits
https://simonhearne.com/2020/pi-speedtest-influx/

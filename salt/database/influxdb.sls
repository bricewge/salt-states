# * Install
influxdb-repo:
  pkgrepo.managed:
    - humanname: Influxdb
    - name: deb [ arch=amd64 ] https://repos.influxdata.com/debian jessie stable
    - file: /etc/apt/sources.list.d/influxdb.list
    - key_url: https://repos.influxdata.com/influxdb.key

influxdb-install:
  pkg.installed:
    - name: influxdb
    - require: 
      - pkgrepo: influxdb-repo

# * Configure
influxdb-config:
  file.managed:
    - name: /etc/influxdb/influxdb.conf
    - source: salt://database/influxdb.conf
    - user: root
    - group: root
    - mode: 644
  
# * Service
influxdb-service:
  service.running:
    - name: influxdb
    - enable: true
    - watch:
      - pkg: influxdb-install
      - file: influxdb-config

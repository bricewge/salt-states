include:
  - database.influxdb
  
# * Install
telegraf-install:
  pkg.installed:
    - name: telegraf
    - require: 
      - pkgrepo: influxdb-repo

# * Configure
# SNMP file to translate OIDs to names
telegraf-oids:
    file.managed:
    - name: /etc/telegraf/oids.txt
    - source: salt://monitoring/telegraf/oids.txt
    - user: root
    - group: root
    - mode: 644

telegraf-plugin:
    file.recurse:
    - name: /etc/telegraf/plugin
    - source: salt://monitoring/telegraf/plugin/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

telegraf-config:
  file.managed:
    - name: /etc/telegraf/telegraf.conf
    - source: salt://monitoring/telegraf/telegraf.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: telegraf-oids
      - file: telegraf-plugin

# * Databases
telegraf-db-user:
  influxdb_user.present:
    - name: telegraf
    - passwd: telegraf
    - host: 127.0.0.1
    - port: 8086
    - require:
      - service: influxdb-service

telegraf-db-telegraf:
  influxdb_database.present:
    - name: telegraf
    - host: 127.0.0.1
    - port: 8086
    - require:
      - influxdb_user: telegraf-db-user

telegraf-db-snmp:
  influxdb_database.present:
    - name: snmp
    - host: 127.0.0.1
    - port: 8086
    - require:
      - influxdb_user: telegraf-db-user

# * Service
telegraf-service:
  service.running:
    - name: telegraf
    - enable: true
    - watch:
      - pkg: telegraf-install
      - file: telegraf-config

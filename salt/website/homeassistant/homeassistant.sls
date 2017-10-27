include:
  - database.influxdb
  - mqtt.mosquitto

# * Install
# pip instalation in broken for now [2015-12-31 jeu.]
homeassistant.install:
  pkg.installed:
    - name: python3-pip
  pip.installed:
    - name: homeassistant
    - bin_env: /usr/bin/pip3
    - require:
      - pkg: homeassistant.install

# * User
homeassistant.group:
  group.present:
    - name: homeassistant
    - gid: 508

homeassistant.user:
  user.present:
    - name: homeassistant
    - shell: /bin/bash
    - home: /srv/homeassistant
    - uid: 508
    - gid_from_name: True
    - empty_password: True
    - require:
      - group: homeassistant.group

# * Config
homeassistant.config:
  file.managed:
    - name: /srv/homeassistant/configuration.yaml
    - source: salt://website/homeassistant/files/configuration.yaml
    - user: homeassistant
    - group: homeassistant
    - mode: 644
    - require:
      - user: homeassistant.user

homeassitant.db:
  influxdb_user.present:
    - name: homeassitant
    - passwd: homeassitant
    - host: 127.0.0.1
    - port: 8086
    - require:
      - service: influxdb-service
  influxdb_database.present:
    - name: homeassitant
    - host: 127.0.0.1
    - port: 8086
    - user: telegraf
    - password: telegraf
    - require:
      - service: influxdb-service
      # - influxdb_user: homeassitant.db

# * Service
homeassistant.service:
  file.managed:
    - name: /etc/systemd/system/homeassistant.service
    - source: salt://website/homeassistant/files/homeassistant.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: homeassistant.install
      - file: homeassistant.config
  service.running:
    - name: homeassistant
    - enable: True
    - watch:
        - pip: homeassistant.install
        - file: homeassistant.service
        - file: homeassistant.config

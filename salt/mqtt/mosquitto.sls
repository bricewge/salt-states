include:
  - tls
  
# * Install
mosquitto.repo:
  pkgrepo.managed:
    - humanname: Mosquitto
    - name: deb http://repo.mosquitto.org/debian jessie main
    - keyid: 61611AE430993623
    - keyserver: hkps.pool.sks-keyservers.net
    - file: /etc/apt/sources.list.d/mosquitto.list

mosquitto.install:
  pkg.installed:
    - pkgs:
      - mosquitto
      - mosquitto-clients
    - fromrepo: stable
    - require:
      - pkgrepo: mosquitto.repo

# * Configuration
mosquitto.config:
  file.managed:
    - name: /etc/mosquitto/mosquitto.conf
    - source: salt://mqtt/mosquitto.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: mosquitto.install

# * Service
mosquitto.service:
  service.running:
    - name: mosquitto
    - enable: True
    - reload: True
    - watch:
      - file: mosquitto.config

# * Certificates
# ** cert
mosquitto.cert:
  cmd.run:
    - name: |
        /bin/systemctl stop nginx && \
        /opt/letsencrypt/letsencrypt-auto certonly --standalone --agree-tos \
        --email brice.wge@gmail.com -d mqtt.bricewge.fr ; \
        /bin/systemctl start nginx
    - creates: /etc/letsencrypt/live/mqtt.bricewge.fr/fullchain.pem
    - user: root
    - group: root
    - cwd: /opt/letsencrypt
    - require:
      - cmd: letsencrypt-install

# ** chain-ca
# Needed for mosquitto, concatenation of chain.pem with the root certificate
mosquitto.cert.chain-ca:
  cmd.run:
    - name: |
        cat /etc/letsencrypt/live/mqtt.bricewge.fr/chain.pem \
        /etc/ssl/certs/DST_Root_CA_X3.pem > \
        /etc/letsencrypt/live/mqtt.bricewge.fr/chain-ca.pem
    - creates: /etc/letsencrypt/live/mqtt.bricewge.fr/chain-ca.pem
    - require:
      - cmd: mosquitto.cert

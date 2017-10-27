# Lychee

# * TODO Install
lychee.repo:
  pkgrepo.managed:
    - humanname: Lychee
    - name: deb [ arch=amd64 ] https://repos.influxdata.com/debian jessie stable
    - file: /etc/apt/sources.list.d/lychee.list
    - key_url: https://repos.influxdata.com/lychee.key

lychee.install:
  pkg.installed:
    - name: lychee
    - require: 
      - pkgrepo: lychee.repo

# * TODO Configure
# lychee.config:
#   file.managed:
#     - name: /etc/lychee/lychee.ini
#     - source: salt://server/lychee/lychee.ini
#     - user: root
#     - group: root
#     - mode: 644
  
# * TODO Service
lychee.service:
  service.running:
    - name: lychee
    - enable: true
    - require:
      - pkg: lychee.install
    - watch:
      - pkg: lychee.install
#      - file: lychee.config

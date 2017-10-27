# * Install
# Grafana repository
grafana-repo:
  pkgrepo.managed:
    - humanname: Grafana
    - name: deb https://packagecloud.io/grafana/stable/debian/ jessie main
    - file: /etc/apt/sources.list.d/grafana.list
    - key_url: https://packagecloud.io/gpg.key
    - require:
      - pkg: grafana-repo
  pkg.installed:
    - pkgs:
      - debian-archive-keyring
      - apt-transport-https

# Install Grafana
grafana-install:
  pkg.installed:
    - name: grafana
    - require: 
      - pkgrepo: grafana-repo

# * Configure
# grafana.config:
#   file.managed:
#     - name: /etc/grafana/grafana.ini
#     - source: salt://server/grafana/files/grafana.ini
#     - user: root
#     - group: root
#     - mode: 644
  
# * Service
grafana-service:
  service.running:
    - name: grafana-server
    - enable: true
    - watch:
      - pkg: grafana-install
#      - file: grafana.config

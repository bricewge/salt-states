# * Install
letsencrypt-install:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - certbot

letsencrypt-create-cert:
  file.managed:
    - name: /usr/local/bin/create-certificate.sh
    - source: salt://tls/files/create-certificate.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: letsencrypt-install

# * Service
# Renewal of the certificates every month.
# This is currently a workaround until the nginx plugin will be stable,
# it stop nginx during the renewal and restart it after.

letsencrypt-service:
  file.managed:
    - name: /etc/systemd/system/letsencrypt.service
    - source: salt://tls/files/letsencrypt.service
    - user: root
    - group: root
    - mode: 644

letsencrypt-timer:
  file.managed:
    - name: /etc/systemd/system/letsencrypt.timer
    - source: salt://tls/files/letsencrypt.timer
    - user: root
    - group: root
    - mode: 644
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: letsencrypt-service
      - file: letsencrypt-timer
  service.running:
    - name: letsencrypt.timer
    - enable: True
    - require:
      - pkg: letsencrypt-install
      - file: letsencrypt-service
      - file: letsencrypt-timer

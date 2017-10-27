# * Install gandyn
gandyn-deps:
  pkg:
    - installed
    - pkgs:
        - python3
        - git
gandyn-install:
  git.latest:
    - name: https://github.com/bricewge/gandyn.git
    - target: /opt/gandyn
    - rev: patch-1
    - require:
      - pkg: gandyn-deps
# Secure the repository
  file.directory:
    - name: /opt/gandyn
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

# * Configure gandyn
gandyn-config:
  file.managed:
    - name: /opt/gandyn/gandyn.conf
    - source: salt://dns/files/gandyn.conf
    - mode: 600
    - template: jinja
    - require:
      - git: gandyn-install

# * Run gandyn every 5 minutes
gandyn-service:
  file.managed:
    - name: /etc/systemd/system/gandyn.service
    - source: salt://dns/files/gandyn.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: gandyn-config

gandyn-timer:
  file.managed:
    - name: /etc/systemd/system/gandyn.timer
    - source: salt://dns/files/gandyn.timer
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: gandyn-service
      - file: gandyn-timer
  service.running:
    - name: gandyn.timer
    - enable: True
    - watch:
      - file: gandyn-service
      - file: gandyn-timer

# Disable the old config from cron
gandyn-cron:
  cron.absent:
    - identifier: gandyn

# * TODO
# ** dependencies
# - python3 for gandyn.py
# - python2 for setup (not used here)
# ** change multiple records
# ** get the ip from another source

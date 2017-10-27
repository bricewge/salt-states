# * User and group
include:
  - nfs.server

flexget-user:
  group.present:
    - name: flexget
    - gid: 503
  user.present:
    - name: flexget
    - uid: 503
    - gid_from_name: True
    - home: /opt/flexget
    - group:
      - nfs
    - require:
      - sls: server.nfs
      - group: flexget-user

# * Install Flexget and dependencies
flexget-deps:
  pkg.installed:
    - pkgs:
      - python-dev
      - python-pip
      - python-virtualenv

flexget-virtualenv:
  file.directory:
    - name: /opt/flexget/virtualenv
    - user: flexget
    - group: flexget
    - dir_mode: 755
    - require:
      - user: flexget-user
  virtualenv.managed:
    - name: /opt/flexget/virtualenv
    - requirements: salt://torrent/files/flexget.pip
    - user: flexget
    - require:
      - pkg: flexget-deps
      - file: flexget-virtualenv

# * Config
flexget-config:
  file.managed:
    - name: /etc/flexget/config.yml
    - source: salt://torrent/files/flexget.conf
    - user: flexget
    - group: flexget
    - mode: 600
    - makedirs: True
    - dir_mode: 755
    - template: jinja
    - require:
      - user: flexget-user
  # Test if the new configuration is working
  cmd.run:
    - name: /opt/flexget/virtualenv/bin/flexget -c /etc/flexget/config.yml execute --test
    - user: flexget
    - group: flexget
    - env:
      - LC_ALL: 'fr_FR.UTF-8'
    - cwd: /opt/flexget/
    - onchanges:
      - file: flexget-config

flexget-log:
  file.directory:
    - name: /var/log/flexget
    - user: flexget
    - group: flexget
    - mode: 755
    - require:
      - user: flexget-user

# ** Service
flexget-service:
  file.managed:
    - name: /etc/systemd/system/flexget.service
    - source: salt://torrent/files/flexget.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja

flexget-timer:
  file.managed:
    - name: /etc/systemd/system/flexget.timer
    - source: salt://torrent/files/flexget.timer
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchages:
      - file: flexget-service
      - file: flexget-timer
  service.running:
    - name: flexget.timer
    - enable: True
    - watch:
      - file: flexget-service
      - file: flexget-timer

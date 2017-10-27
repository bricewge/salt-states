# * Installation
transmission-install:
  pkg.installed:
    - name: transmission-daemon

transmission-user:
  user.present:
    - name: debian-transmission
    - optional_groups: nfs
    - require:
      - pkg: transmission-install

# * Config
transmission-config:
  file.managed:
    - name: /etc/transmission-daemon/settings.json
    - source: salt://torrent/files/settings.json
    - replace: false
    - user: root
    - group: debian-transmission
    - mode: 640
    - template: jinja
    - require:
      - pkg: transmission-install

# Fix the issue
# https://yatta.wordpress.com/2014/08/02/transmission-daemon-failing-on-debian-jessie/
transmission-sysctl:
  file.append:
    - name: /etc/sysctl.conf
    - text:
      - "net.core.rmem_max = 4194304"
      - "net.core.wmem_max = 1048576"

# ** Authentication
# File to keep the password for transmission-remote
transmission-authentication:
  file.managed:
    - name: /var/lib/transmission-daemon/.config/transmission-daemon/netrc
    - source: salt://torrent/files/netrc
    - user: debian-transmission
    - group: debian-transmission
    - mode: 600
    - template: jinja

# * Service
transmission-service:
  service.running:
    - name: transmission-daemon
    - enable: True
    - reload: True
    - watch:
      - file: transmission-config
      - pkg: transmission-install

# * Blocklist
# update blocklist once a week
transmission-blocklist-service:
  file.managed:
    - name: /etc/systemd/system/transmission-blocklist.service
    - source: salt://torrent/files/transmission-blocklist.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja

transmission-blocklist-timer:
  file.managed:
    - name: /etc/systemd/system/transmission-blocklist.timer
    - source: salt://torrent/files/transmission-blocklist.timer
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: transmission-blocklist-service
      - file: transmission-blocklist-timer
  service.running:
    - name: transmission-blocklist.timer
    - enable: True
    - watch:
      - file: transmission-blocklist-service
      - file: transmission-blocklist-timer

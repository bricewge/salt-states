include:
  - nfs.server

sonarr-repo:
  pkgrepo.managed:
    - humanname: Sonarr repo
    - name: deb http://apt.sonarr.tv/ master main
    - file: /etc/apt/sources.list.d/sonarr.list
    - keyid: FDA5DFFC
    - keyserver: keyserver.ubuntu.com
    - require:
      - pkg: sonarr-repo
  pkg.installed:
    - name: apt-transport-https

sonarr-install:
  pkg.installed:
    - name: nzbdrone
    - require:
      - pkg: sonarr-repo

sonarr-user:
  group.present:
    - name: sonarr
    - gid: 511
  user.present:
    - name: sonarr
    - uid: 511
    - gid_from_name: True
    - home: /srv/sonarr
    - shell: /bin/false
    - empty_password: True
    - optional_groups:
      - nfs
    - require:
      - group: sonarr-user
      - group: nfs-group

sonarr-service:
  file.managed:
    - name: /etc/systemd/system/sonarr.service
    - source: salt://media/sonarr/sonarr.service
    - mode: 644
    - user: root
    - group: root
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: sonarr-service
  service.running:
    - name: sonarr.service
    - enable: True
    - watch:
      - file: sonarr-service
      - pkg: sonarr-install
    - require:
      - user: sonarr-user

# TODO Make independant from NFS
include:
  - nfs.server

emby-install:
  pkgrepo.managed:
    - humanname: Emby repo
    - name: deb http://download.opensuse.org/repositories/home:/emby/Debian_8.0/ /
    - file: /etc/apt/sources.list.d/emby.list
    - key_url: http://download.opensuse.org/repositories/home:emby/Debian_8.0/Release.key
  pkg.installed:
    - pkgs:
      - emby-server
#      - ffmpeg # Not availaibile in Debian 8 for the moment

emby-user:
  group.present:
    - name: emby
    - gid: 514
  user.present:
    - name: emby
    - uid: 514
    - gid_from_name: True
    - home: /var/lib/emby-server
    - shell: /bin/false
    - empty_password: True
    - optional_groups:
      - nfs
    - require:
      - group: emby-user
      - group: nfs-group

emby-config:
  file.managed:
    - name: /etc/emby-server.conf
    - source: salt://media/emby/emby.conf
    - user: root
    - group: root
    - mode: 644

emby-service:
  service.running:
    - name: emby-server
    - enable: true
    - watch:
      - pkg: emby-install
      - file: emby-config
    - require:
      - user: emby-user

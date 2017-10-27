# Dependencies
nfs-deps:
  pkg.installed:
    - pkgs:
        - nfs-kernel-server
        - rpcbind

imdmapd-config:
  file.managed:
    - name: /etc/idmapd.conf
    - source: salt://nfs/files/idmapd.conf
    - user: root
    - group: root
    - mode: 644

nfs-config:
  file.managed:
    - name: /etc/default/nfs-common
    - source: salt://nfs/files/nfs-common
    - user: root
    - group: root
    - mode: 644


nfs-group:
  group.present:
    - name: nfs
    - gid: 4003

# Bind mount
nfs-mount:
  mount.mounted:
    - name: /srv/nfs4/media
    - device: /mnt/media
    - fstype: none
    - opts: bind
    - mkmnt: True
    - dump: 0
    - pass_num: 0
    - persist: True

# Folders to export
nfs-exports:
  file.managed:
    - name: /etc/exports
    - source: salt://nfs/files/exports
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nfs-deps

# Service
nfs-service:
  service.running:
    - name: nfs-kernel-server
    - enable: True
    - reload: True
    - watch:
      - pkg: nfs-deps
      - file: imdmapd-config
      - file: nfs-exports
    - require:
      - file: nfs-exports

# IPFS
# * User
ipfs-group:
  group.present:
    - name: ipfs
    - gid: 507
  
ipfs-user:
  user.present:
    - name: ipfs
    - shell: /bin/false
    - home: /srv/ipfs
    - createhome: True
    - uid: 507
    - gid_from_name: True
    - empty_password: True
    - require:
      - group: ipfs-group

# * Install
ipfs-install:
  archive.extracted:
    - name: /opt
    - source: https://dist.ipfs.io/go-ipfs/v0.4.1/go-ipfs_v0.4.1_linux-amd64.tar.gz
    - source_hash: sha256=145b32f49e971eeb1545dc36321ae52e7b4ae4362b5b8aca6e4f6ab407aa5498
    - archive_format: tar
    - tar_options: v
    - if_missing: /opt/go-ipfs/
  file.symlink:
    - name: /usr/local/bin/ipfs
    - target: /opt/go-ipfs/ipfs

ipfs-config:
  file.managed:
    - name: /srv/ipfs/.ipfs/config
    - source: salt://ipfs/ipfs.conf
    - user: ipfs
    - group: ipfs
    - mode: 600
    - template: jinja
    - require:
      - user: ipfs-user

# * Service
ipfs-service:
  file.managed:
    - name: /etc/systemd/system/ipfs.service
    - source: salt://ipfs/ipfs.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: ipfs-config
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: ipfs-service
  service.running:
    - name: ipfs.service
    - enable: True
    - watch:
        - file: ipfs-install
        - file: ipfs-service




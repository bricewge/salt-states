# * Autofs
# # ** Instalation
# autofs.install:
#   pkg.installed:
#     - name: autofs

# # ** Configuration
# autofs.misc:
#   file.managed:
#     - name: /etc/autofs/auto.misc
#     - source: salt://nfs/files/auto.misc
#     - mode: 644
#     - user: root
#     - group: root

# autofs.master:
#   file.managed:
#     - name: /etc/autofs/auto.master
#     - source: salt://nfs/files/auto.master
#     - mode: 644
#     - user: root
#     - group: root

# # ** Service
# autofs.service:
#   module.wait:
#     - name: service.systemctl_reload
#     - watch:
#       - file: autofs.misc
#       - file: autofs.master
#   service.running:
#     - name: autofs
#     - enable: True
#     - watch:
#       - file: autofs.misc
#       - file: autofs.master
#     - require:
#       - file: autofs.misc
#       - file: autofs.master

# * NFS
nfs.install:
  pkg.installed:
    - pkgs:
      - nfs-utils
      - ntp

nfs.rpcbind:
  service.running:
    - name: rpcbind
    - enable: True
    - require:
      - pkg: nfs.install

nfs.client:
  service.running:
    - name: nfs-client.target
    - enable: True
    - require:
      - pkg: nfs.install

nfs.remote:
  service.running:
    - name: remote-fs.target
    - enable: True
    - require:
      - pkg: nfs.install

nfs-network:
  service-running:
    - name: NetworkManager-wait-online.service
    - enable: True

nfs-client-mount:
  file.directory:
    - name: /mnt/durian
    - user: root
    - group: root
  mount.mounted:
    - name: /mnt/durian
    - device: durian.bricewge.fr:/srv/nfs4/media
    - fstype: nfs
    - opts:
      - auto
      - x-systemd.automount
      - x-systemd.device-timeout=10
      - timeo=14
      - x-systemd.idle-timeout=1min
    - dump: 0
    - pass_num: 0
    - require:
      - file: nfs-client-mount
  service.running:
    - name: mnt-durian.automount
    - enable: True
    - reload: True
    - watch:
      - mount: nfs-client-mount
    - require:
      - service: nfs-network

# ** TODO Hide pNFS warning
# https://bbs.archlinux.org/viewtopic.php?id=190681
# systemctl mask nfs-blkmap.service

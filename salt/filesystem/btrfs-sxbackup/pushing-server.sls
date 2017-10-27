include:
  - ssh.server
  - .user

btrfs-sxbackup-pushing-server-mount:
  file.managed:
    - name: /etc/systemd/system/mnt-backup.mount
    - source: salt://filesystem/btrfs-sxbackup/files/mnt-backup.mount
    - mode: 644
    - user: root
    - group: root

# btrfs-sxbackup-pushing-server-keys:
#   ssh:
    


# * Mount point
backup-mount:
  file.directory:
    - name: /mnt/backup
    - user: root
    - group: root
    - mode: 755
  mount.mounted:
    - name: /mnt/backup
    - device: LABEL="backup"
    - fstype: btrfs
    - opts:
      - noauto
      - noatime
      - space_cache
      - compress=lzo
      - autodefrag
      - nodev
      - nosuid
      - noexec
    - mkmnt: True
    - dump: 0
    - pass_num: 0
    - persist: True
    - match_on: name
    - require:
      - file: backup-mount

# * Plug and backup
btrfs-sxbackup-udev:
  file.managed:
    - name: /etc/udev/rules.d/99-backup.rules
    - source: salt://filesystem/btrfs-sxbackup/files/99-backup.rules
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: udevadm control --reload-rules
    - onchanges:
      - file: btrfs-sxbackup-udev

# * Execute
btrfs-sxbackup-service:
  file.managed:
    - name: /etc/systemd/system/backup-attic.service
    - source: salt://filesystem/btrfs-sxbackup/files/backup-attic.service
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: btrfs-sxbackup-service


btrfs-sxbackup-script:
  file.managed:
    - name: /usr/local/bin/backup-attic.sh
    - source: salt://filesystem/btrfs-sxbackup/files/backup-attic.sh
    - user: root
    - group: root
    - mode: 755

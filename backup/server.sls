# * Install attic and SSH
include:
  - ssh.sshd

# * Backup location
borg-mount:
  file.directory:
    - name: /srv/borg
    - user: 502
    - group: 502
    - mode: 750
  mount.mounted:
    - name: /srv/borg
    - device: LABEL="durian-data"
    - fstype: btrfs
    - opts:
      - noatime
      - space_cache
      - compress=lzo
      - autodefrag
      - nodev
      - nosuid
      - noexec
      - subvol=borg
    - dump: 0
    - pass_num: 0
    - persist: True
    - match_on: name
    - require:
      - file: borg-mount

# * borg user and autorized keys
borg-group:
  group.present:
    - name: borg
    - gid: 502
  
borg-user:
  user.present:
    - name: borg
    - shell: /bin/bash
    - home: /srv/borg
    - uid: 502
    - gid_from_name: True
    - groups:
      - ssh
    - empty_password: True
    - require:
      - group: borg-group

borg-ssh:
  file.managed:
    - name: /srv/borg/.ssh/authorized_keys 
    - source: salt://backup/files/borg-user_ca.pub
    - user: borg
    - group: borg
    - mode: 600
    - makedirs: True
    - template: jinja
    - require:
      - user: borg-user

# * Backup borg repositories
# Backup the borg repositories
# ** Mount point
borg-backup-directory:
  file.directory:
    - name: /mnt/backup
    - user: root
    - group: root
    - mode: 755

borg-backup-fstab:
  file.line:
    - name: /etc/fstab
    - content: LABEL="backup" /mnt/backup btrfs noauto,noatime,space_cache,compress=lzo,autodefrag,nodev,nosuid,noexec 0 0
    - mode: Replace
    - match: .*/mnt/backup.*
    - require:
      - file: borg-backup-directory
    
# borg-backup-mount:
#   file.directory:
#     - name: /mnt/backup
#     - user: root
#     - group: root
#     - mode: 755
#   mount.mounted:
#     - name: /mnt/backup
#     - device: LABEL="backup"
#     - fstype: btrfs
#     - opts:
#       - noauto
#       - noatime
#       - space_cache
#       - compress=lzo
#       - autodefrag
#       - nodev
#       - nosuid
#       - noexec
#     - mkmnt: True
#     - dump: 0
#     - pass_num: 0
#     - persist: True
#     - match_on: name
#     - require:
#       - file: borg-backup-mount

# ** Dependencies
borg-backup-sxbackup:
  pkg.installed:
    - pkgs:
      - pv
      - sendmail-bin
      - lzop
  pip.installed:
    - requirements: salt://backup/files/btrfs-sxbackup.pip
    - user: root
    - bin_env: /usr/bin/pip3
    - require:
      - pkg: borg-backup-sxbackup

# ** Script
borg-backup-script:
  file.managed:
    - name: /usr/local/bin/backup-borg.sh
    - source: salt://backup/files/backup-borg.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - pip: borg-backup-sxbackup

# ** Service
borg-backup-service:
  file.managed:
    - name: /etc/systemd/system/backup-borg.service
    - source: salt://backup/files/backup-borg.service
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - file: borg-backup-script
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: borg-backup-service

# ** Connect external HDD to start a backup
backup-borg-udev:
  file.managed:
    - name: /etc/udev/rules.d/99-backup.rules
    - source: salt://backup/files/99-backup.rules
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: borg-backup-service
  cmd.run:
    - name: udevadm control --reload-rules
    - onchanges:
      - file: backup-borg-udev

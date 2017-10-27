btrfs-sxbackup-group:
  group.present:
    - name: backup
    - gid: 515
  
btrfs-sxbackup-user:
  user.present:
    - name: backup
    - shell: /bin/false
    - uid: 515
    - gid_from_name: True
    - empty_password: True
    - groups:
      - backup
    - require:
      - group: btrfs-sxbackup-group

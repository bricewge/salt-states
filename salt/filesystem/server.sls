include:
  - .btrfs.install

# * Mount
# ** root
root-mount:
  mount.mounted:
    - name: /
    - device: LABEL="durian-root"
    - fstype: btrfs
    - opts: defaults
    - mkmnt: True
    - dump: 0
    - pass_num: 1
    - persist: True

# ** ESP
esp-mount:
  mount.mounted:
    - name: /boot/efi
    - device: LABEL="ESP"
    - fstype: vfat
    - opts: defaults
    - mkmnt: True
    - dump: 0
    - pass_num: 2
    - persist: True

# ** data
data-mount:
  mount.mounted:
    - name: /mnt/data
    - device: LABEL="durian-data"
    - fstype: btrfs
    - opts:
      - noatime
      - space_cache
      - compress=lzo
      - autodefrag
      - nodev
    - mkmnt: True
    - dump: 0
    - pass_num: 0
    - persist: True
    - match_on: name

data-dupremove-service:
  file.managed:
    - name: /etc/systemd/system/duperemove.service
    - source: salt://filesystem/files/duperemove.service
    - user: root
    - group: root
    - mode: 644

# *** backup
backup-mount:
  mount.mounted:
    - name: /mnt/backup
    - device: LABEL="durian-data"
    - fstype: btrfs
    - opts:
      - noatime
      - space_cache
      - compress=lzo
      - autodefrag
      - nodev
      - subvol=backup
    - mkmnt: True
    - dump: 0
    - pass_num: 0
    - persist: True
    - match_on: name

# *** media
media-mount:
  mount.mounted:
    - name: /mnt/media
    - device: LABEL="durian-data"
    - fstype: btrfs
    - opts:
      - noatime
      - space_cache
      - compress=lzo
      - autodefrag
      - nodev
      - subvol=media
    - mkmnt: True
    - dump: 0
    - pass_num: 0
    - persist: True
    - match_on: name

media-strucure:
  file.recurse:
    - name: /mnt/media
    - source: salt://filesystem/files/media
    - user: nobody
    - group: nfs
    - dir_mode: 2775 # SETGID on the direcotry
    - include_empty: True
    - require:
      - mount: media-mount

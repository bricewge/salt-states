btrfs-install:
  pkg.installed:
    - name: btrfs-progs

# Provide btrfs-check to the ramdisk
btrfs-mkinitcpio:
  file.replace:
    - name: /etc/mkinitcpio.conf
    - repl: "BINARIES=\"/usr/bin/btrfs\""
    - pattern: "BINARIES=\"\""
    - count: 1
    - require:
      - pkg: btrfs-install
  cmd.run:
    - name: mkinitcpio -p linux
    - onchanges:
      - file: btrfs-mkinitcpio

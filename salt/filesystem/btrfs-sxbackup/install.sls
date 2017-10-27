include:
  - .user

btrfs-sxbackup-install:
  pkg.installed:
    - pkgs:
      - bash
      - btrfs-progs
      - python3
      - pv
      - sendmail
      - lzop
  # Pip is broken with saltstack 2016.3.3
  # pip.installed:
  #   - name: btrfs-sxbackup
  #   - user: root
  #   - bin_env: /usr/bin/pip3
  #   - require:
  #     - pkg: btrfs-sxbackup-install



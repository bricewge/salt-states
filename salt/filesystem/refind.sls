# * rEFInd
# ** config
refind-conf:
  file.managed:
    - name: /boot/EFI/refind/refind.conf
    - source: salt://filesystem/files/refind.conf
    - user: root
    - group: root
    - mode: 755


# ** auto update
# When rEFInd is updated it update the rEFInd setup and the new config file is put under the same direcotry as =refind.conf= under the name =refind.conf-sample=.
refind-update-service:
  file.managed:
    - name: /etc/systemd/system/refind-update.service
    - source: salt://filesystem/files/refind-update.service
    - user: root
    - group: root
    - file_mode : 755

refind-update-path:
  file.managed:
    - name: /etc/systemd/system/refind-update.path
    - source: salt://filesystem/files/refind-update.path
    - user: root
    - group: root
    - file_mode : 755
  service.running:
    - name: refind-update.path
    - enable: True
    - require:
      - file : refind-update-path

# ** theme
refind-theme-minimal:
  git.latest:
    - target: /boot/EFI/refind/rEFInd-minimal
    - name: https://github.com/EvanPurkhiser/rEFInd-minimal.git
    - rev: master

# ** microcode update
microcode-update:
  pkg.installed:
    - name: intel-ucode

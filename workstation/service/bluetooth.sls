
# * Instalation
bluetooth.install:
  pkg.installed:
    - pkgs:
      - bluez
      - bluez-utils
      - pulseaudio-bluetooth

# * Service
bluetooth-service:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: bluetooth.sap
  service.running:
    - name: bluetooth
    - enable: True
    - watch:
      - file: bluetooth.sap
    - require:
      - pkg: bluetooth.install
      - file: bluetooth.sap

# * Configuration
# Fix sap errors https://bugs.archlinux.org/task/41247
bluetooth.sap:
  file.managed:
    - name: /etc/systemd/system/bluetooth.service.d/customexec.conf
    - source: salt://workstation/service/file/customexec.conf
    - mode: 644
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: 755

bluetooth.switch-on-connect:
  file.append:
    - name: /etc/pulse/default.pa
    - text: |
        # Automatically switch to newly-connected devices
        load-module module-switch-on-connect

# This seems to be fixed [2015-12-19]
# # Fix https://bbs.archlinux.org/viewtopic.php?id=194006 (GDM bug)
# # By delaying the loading of module-bluetooth-discover by pulseaudio
# # Plus switch to newly connected device automatically
# bluetooth.default.pa:
#   file.comment:
#     - name: /etc/pulse/default.pa
#     - regex: load-module module-bluetooth-discover
#     - char: #

# bluetooth.pulseaudio:
#   file.managed:
#     - name: /usr/bin/start-pulseaudio-x11
#     - source: salt://workstation/service/file/start-pulseaudio-x11
#     - mode: 755
#     - user: root
#     - group: root

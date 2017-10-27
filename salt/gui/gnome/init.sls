# Looks like saltstack doesn't know how to handle package group
# gnome.install:
#   pkg.installed:
#     - name: gnome
gdm:
  service.running:
    - name: gdm
    - enable: True
    - require:
        - file: /etc/gdm/custom.conf
#        - pkg: gnome.install

gnome.utils:
  pkg.installed:
    - pkgs:
      - file-roller
      - gedit
      - gnome-music
      - gnome-sound-recorder
      - gnome-tweak-tool
      - vinagre
      - gnome-calendar
      - gnome-clocks
      - gnome-maps
      - gnome-photos
      - rygel

# Disable wayland for GDM
/etc/gdm/custom.conf:
  file.managed:
    - name: /etc/gdm/custom.conf
    - source: salt://gui/gnome/custom.conf
    - user: root
    - group: root
    - mode: 644
#    - require:
#      - pkg: gnome.install

networkmanager-pkg:
  pkg.installed:
    - pkgs:
      - networkmanager
      - networkmanager-openvpn

NetworkManager:
  service.running:
    - enable: True
  require:
    - service: gnome
    - pkg: networkmanager-pkg

NetworkManager-wait-online.service:
  service.running:
    - enable: True
  
wpa_supplicant:
  service.disabled:
    - name: wpa_supplicant
    - require:
      - service: NetworkManager

# # Needed on mba4,2. From the AUR
# gnome.autobrightness:
#   pkg.installed:
#     - name: iio-sensor-proxy

gnome-keyring-disable:
  file.absent:
    - name: /etc/xdg/autostart/gnome-keyring-ssh.desktop

gnome-nautilus:
  pkg.installed:
    - pkgs:
      - nautilus
      - nautilus-actions

gnome-terminal:
  pkg.removed:
    - name: gnome-terminal

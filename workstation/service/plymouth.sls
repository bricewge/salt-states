# Waiting for a easy to have a seamless transition from boot to
# graphical. And not 3-4 flashes of transition in 5 s.
# plymouth.install:
#   pkg.installed:
#     - pkgs:
#       - gdm-pymouth
#       - plymouth-theme-paw-arch

plymouth.mkinitcpio:
  /etc/mkinitcpio.conf:

# systemctl mask plymouth-quit-wait.service
plymouth.quit.wait:
  file.symlink:
    - name: /etc/systemd/system/plymouth-quit-wait.service 
    - target: /dev/null
    - user: root
    - group: root

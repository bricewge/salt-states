# * Install
syncthing.install:
  pkg.installed:
    - pkgs:
      - syncthing
      - syncthing-inotify

# * TODO Config
# * Service
sycnthing.service:
  service.enbaled:
    - name: syncthing-inotfy@bricewge.service
    - running: True
    - require:
      - pkg: syncthing.install

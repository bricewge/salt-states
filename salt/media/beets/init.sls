# Beets
# * Install
beets-deps:
  pkg:
    - installed
    - pkgs:
      - python-pip
      - python-gi
      - libchromaprint-tools
      - python-gst0.10-dev
      - gstreamer0.10-plugins-good
      - gstreamer0.10-plugins-bad
      - gstreamer0.10-plugins-ugly
      - gstreamer0.10-chromaprint

beets-install:
  pip.installed:
    - name: beets
    - user: root
    - require:
      - pkg: beets-deps

beets-plugins-install:
  pip.installed:
    - pkgs:
      - pyacoustid         # chroma
      - requests           # fetchart
      - discogs-client     # discogs
      - pylast             # lastgenre
      - flask              # web
    - user: root
    - upgrade: True
    - require:
      - pip: beets-install

# * User
beets-group:
  group.present:
    - name: beets
    - gid: 506
  
beets-user:
  user.present:
    - name: beets
    - shell: /bin/bash
    - home: /srv/beets
    - uid: 506
    - gid_from_name: True
    - empty_password: True
    - groups:
      - nfs
    - require:
      - group: beets-group
        
# * Config
beets-config:
  file.managed:
    - name: /srv/beets/config.yaml
    - source: salt://server/beets/config.yaml
    - user: beets
    - group: beets
    - mode: 644
    - makedirs: True
    - dir_mode: 755
    - template: jinja

# * Service
# beets-service:
#   file.managed:
#     - name: /etc/systemd/system/isso.service
#     - source: salt://server/nikola/isso.service
#     - user: root
#     - group: root
#     - mode: 644
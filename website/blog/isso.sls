#  Isso: comment server
# * Install
isso-deps:
  pkg.installed:
    - pkgs:
      - python-dev
      - sqlite3
      - gunicorn
      - build-essential

isso-install:
  pip.installed:
    - name: isso
    - user: root
    - require:
      - pkg: isso-deps
      - user: isso-user

# * User
isso-group:
  group.present:
    - name: isso
    - gid: 505
  
isso-user:
  user.present:
    - name: isso
    - shell: /bin/bash
    - home: /srv/isso
    - uid: 505
    - gid_from_name: True
    - empty_password: True
    - require:
      - group: isso-group

# * Config
isso-config:
  file.managed:
    - name: /etc/isso/isso.conf
    - source: salt://website/blog/files/isso.conf
    - user: isso
    - group: isso
    - mode: 600
    - dir_mode: 755
    - makedirs: True
    - template: jinja
    - require:
      - user: isso-user

isso-db:
  file.directory:
    - name: /var/lib/isso
    - user: isso
    - group: isso
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: isso-user

# * Service
isso-service:
  file.managed:
    - name: /etc/systemd/system/isso.service
    - source: salt://website/blog/files/isso.service
    - user: root
    - group: root
    - mode: 644
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/isso.service
  service.running:
    - name: isso
    - enable: True
    - reload: True
    - require:
      - file: isso-db
    - watch:
      - file: isso-service
      - file: isso-config

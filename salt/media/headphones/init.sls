headphones-user:
  group.present:
    - name: headphones
    - gid: 510
  user.present:
    - name: headphones
    - uid: 510
    - gid_from_name: True
    - home: /srv/headphones
    - shell: /bin/false
    - empty_password: True
    - optional_groups:
      - nfs
    - require:
      - group: headphones-user

headphones-deps:
  pkg.installed:
    - pkgs:
      - git

headphones-repo:
  file.directory:
    - name: /opt/headphones
    - user: headphones
    - group: headphones
    - require:
      - user: headphones-user
  git.latest:
    - name: https://github.com/rembo10/headphones.git
    - target: /opt/headphones
    - user: headphones
    - require:
      - file: headphones-repo
      - pkg: headphones-deps

headphones-config:
  file.managed:
    - name: /etc/headphones/headphones.ini
    - source: salt://media/headphones/headphones.conf
    - replace: False
    - user: headphones
    - group: headphones
    - mode: 600
    - dir_mode: 755
    - makedirs: True
    - require:
      - user: headphones-user
  # The service need to be dead before modifying the config otherwise
  # the service will rewrite it with it's current running config.
  service.dead:
    - name: headphones.service
    - prereq:
      - file: headphones-config

headphones-service:
  file.managed:
    - name: /etc/systemd/system/headphones.service
    - source: salt://media/headphones/headphones.service
    - force: True
    - mode: 644
    - user: root
    - group: root
    - require:
      - git: headphones-repo
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: headphones-service
  service.running:
    - name: headphones.service
    - enable: True
    - watch:
      - file: headphones-service
      - git: headphones-repo
    - require:
      - file: headphones-config

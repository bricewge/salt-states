include:
  - nfs.server

couchpotato-deps:
  pkg.installed:
    - pkgs:
      - python
      - git

couchpotato-user:
  group.present:
    - name: couchpotato
    - gid: 512
  user.present:
    - name: couchpotato
    - uid: 512
    - gid_from_name: True
    - home: /srv/couchpotato
    - shell: /bin/false
    - empty_password: True
    - optional_groups:
      - nfs
    - require:
      - group: couchpotato-user
      - group: nfs-group

couchpotato-repo:
  file.directory:
    - name: /opt/couchpotato
    - user: couchpotato
    - group: couchpotato
    - require:
      - user: couchpotato-user
  git.latest:
    - name: https://github.com/CouchPotato/CouchPotatoServer.git
    - target: /opt/couchpotato
    - user: couchpotato
    - require:
      - file: couchpotato-repo
      - pkg: couchpotato-deps
        
couchpotato-service:
  file.managed:
    - name: /etc/systemd/system/couchpotato.service
    - source: salt://media/couchpotato/couchpotato.service
    - force: True
    - mode: 644
    - user: root
    - group: root
    - require:
      - git: couchpotato-repo
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: couchpotato-service
  service.running:
    - name: couchpotato.service
    - enable: True
    - watch:
      - file: couchpotato-service
      - git: couchpotato-repo
    - require:
      - pkg: couchpotato-deps

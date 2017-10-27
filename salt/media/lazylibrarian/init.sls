lazylibrarian-user:
  group.present:
    - name: lazylibrarian
    - gid: 513
  user.present:
    - name: lazylibrarian
    - uid: 513
    - gid_from_name: True
    - home: /srv/lazylibrarian
    - shell: /bin/false
    - empty_password: True
    - optional_groups:
      - nfs
    - require:
      - group: lazylibrarian-user

lazylibrarian-repo:
  file.directory:
    - name: /opt/lazylibrarian
    - user: lazylibrarian
    - group: lazylibrarian
    - mode: 755
    - require:
      - user: lazylibrarian-user
  git.latest:
    - name: https://github.com/DobyTang/LazyLibrarian.git
    - target: /opt/lazylibrarian
    - force_reset: True
    - force_fetch: True
    - user: lazylibrarian
    - require:
      - file: lazylibrarian-repo

lazylibrarian-service:
  file.managed:
    - name: /etc/systemd/system/lazylibrarian.service
    - source: salt://media/lazylibrarian/lazylibrarian.service
    - force: True
    - mode: 644
    - user: root
    - group: root
    - require:
      - git: lazylibrarian-repo
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: lazylibrarian-service
  service.running:
    - name: lazylibrarian.service
    - enable: True
    - watch:
      - file: lazylibrarian-service
      - git: lazylibrarian-repo

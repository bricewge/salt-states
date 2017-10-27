# * Install
sshd-install:
  pkg.installed:
    - pkgs:
      - openssh-server
      - openssh-client

# * Config
sshd-config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://ssh/sshd.conf
    - user: root
    - group: root
    - file_mode : 644

# * Service
sshd-service:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - pkg: sshd-install
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - pkg: sshd-install
      - file: sshd-config

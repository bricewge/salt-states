include:
  - .install

# * Configure SSH
# ** Config
borg-config:
  file.managed:
    - name: /root/.ssh/config
    - source: salt://backup/files/borg-ssh.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 600
    - template: jinja

# ** Generate keys
# Note: May need some more entropy
ssh-keys:
  cmd.run:
    - name: ssh-keygen -b 4096 -f /root/.ssh/borg-{{ grains['localhost'] }} -q -N ""
    - user: root
    - group: root
    - creates: /root/.ssh/borg-{{ grains['localhost'] }}
    - require:
      - file: borg-config

# ** Sign keys
# Sign ssh key with a certificate

# * Configure borg
# ** Initialize repository
# Can't get this state working properly
borg-init:
  cmd.run:
    - name: borg init borg:/srv/borg/{{ grains['localhost'] }}
    - user: root
    - group: root
    - creates: /root/.borg/keys/borg__srv_borg_{{ grains['localhost'] }}
    # Don't run if a respository with the exact same name already exist
    - unless: ssh -o BatchMode=yes borg ls ./ | grep "^{{ grains['localhost'] }}$"
  require:
    - cmd: borg

# ** Service
borg-service:
  file.managed:
    - name: /etc/systemd/system/borg.service
    - source: salt://backup/files/borg.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja

borg-timer:
  file.managed:
    - name: /etc/systemd/system/borg.timer
    - source: salt://backup/files/borg.timer
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: borg-service
      - file: borg-timer
  service.running:
    - name: borg.timer
    - enable: True
    - reload: True
    - require:
      - file: borg-service
    - watch:
      - file: borg-timer


# * Master
salt.master:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/master
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: salt-master
    - enable: True
    - require:
      - file: /etc/salt/master
    - watch:
      - file: /etc/salt/master

# Synchronise file_roots
# https://groups.google.com/forum/#!topic/salt-users/-IAamZP7t38
salt.file_roots:
  file.recurse:
    - name: /srv/salt
    - source: salt://.file_roots
    - exclude_pat: .file_roots/*

# * Minion
# Apply new minion config and restart it
salt.minion:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/minion
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: |
        exec 0>&- # close stdin
        exec 1>&- # close stdout
        exec 2>&- # close stderr
        nohup /bin/sh -c 'sleep 10 && salt-call --local service.restart salt-minion' &
    - python_shell: True
    - order: last
    - onchanges:
      - file: /etc/salt/minion

# * Cloud
salt.cloud.providers:
  file.recurse:
    - source: salt://salt/cloud.providers.d/
    - name: /etc/salt/cloud.providers.d/
    - clean: True

salt.cloud.profiles:
  file.recurse:
    - source: salt://salt/cloud.profiles.d/
    - name: /etc/salt/cloud.profiles.d/
    - clean: True

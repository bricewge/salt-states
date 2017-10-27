systemd-conf:
  file.managed:
    - name: /etc/system/system.conf
    - source: salt://base/systemd/system.conf
    - user: root
    - group: root
    - mode: 644

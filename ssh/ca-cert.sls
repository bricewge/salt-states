ssh-ca-cert:
  file.managed:
    - name: /etc/ssh/ca_keys
    - source: salt://ssh/ca_keys
    - template: jinja
    - mode: 644
    - user: root
    - group: root

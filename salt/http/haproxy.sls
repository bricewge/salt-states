haproxy-install:
  pkg.installed:
    - name: haproxy

haproxy-config:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://http/haproxy/config
    - template: jinja
    - user: root
    - group: root
    - mode: 644

haproxy-service:
  service.running:
    - name: haproxy
    - enable: True
    - reload: True
    - watch:
      - file: haproxy-config
      - pkg: haproxy-install

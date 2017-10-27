# * Install
nginx-install:
  pkg.installed:
    - name: nginx-full
    - fromrepo: jessie-backports

# * Configuration
nginx-config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://http/nginx/nginx.conf
    - user: root
    - group: root
    - mode: 644

# * TLS
nginx-diffie-hellman:
  file.directory:
    - name: /etc/nginx/ssl/
    - user: root
    - group: root
    - dir_mode: 755
  cmd.run:
    - name: openssl dhparam -out /etc/nginx/tls/dhparam.pem 2048
    - creates: /etc/nginx/ssl/dhparam.pem
    - runas: root
    - require:
      - file: nginx-diffie-hellman

# ** Force HTTPS
nginx-force-https-availaible:
  file.managed:
    - name: /etc/nginx/sites-available/http-to-https.conf
    - source: salt://http/nginx/http-to-https.conf
    - user: root
    - group: root
    - mode: 644

nginx-force-https-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/http-to-https.conf
    - target: /etc/nginx/sites-available/http-to-https.conf
    - user: root
    - group: root
    - require:
      - file: nginx-force-https-availaible

# * Service
nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: nginx-config
    - require:
      - cmd: nginx-diffie-hellman

# # ** Nginx reload configuration
# nginx-reload-service:
#   file.managed:
#     - name: /etc/systemd/system/nginx-reload.service
#     - source: salt://http/nginx/nginx-reload.service
#     - user: root
#     - group: root
#     - mode: 644

# nginx-reload-path:
#   file.managed:
#     - name: /etc/systemd/system/nginx-reload.path
#     - source: salt://http/nginx/nginx-reload.path
#     - user: root
#     - group: root
#     - mode: 644
#   module.run:
#     - name: service.systemctl_reload
#     - onchnages:
#       - file: nginx-reload-service
#       - file: nginx-reload-path
#   service.enabled:
#     - name: nginx-reload.path
#     - require:
#       - file: nginx-reload-service
#       - file: nginx-reload-path

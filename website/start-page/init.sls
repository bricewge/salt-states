include:
  - http.nginx
  - tls.letsencrypt

start-page-directory:
  file.directory:
    - name: /srv/nginx/start.bricewge.fr
    - user: bricewge
    - group: bricewge

# * Nginx
start-page-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/start.bricewge.fr.conf
    - source: salt://website/start-page/nginx.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

start-page-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/start.bricewge.fr.conf
    - target: /etc/nginx/sites-available/start.bricewge.fr.conf
    - mode: 777
    - require:
      - file: start-page-nginx-available
      - cmd: start-page-cert
  module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: start-page-nginx-available
      - file: start-page-nginx-enabled

# * TLS
start-page-cert:
  cmd.run:
    - name: |
        /usr/bin/certbot certonly \
        --standalone \
        --non-interactive \
        --agree-tos \
        --email brice.wge@gmail.com \
        --preferred-challenges http-01 \
        --pre-hook "/bin/systemctl stop nginx.service" \
        --post-hook "/bin/systemctl start nginx.service" \
        --domain start.bricewge.fr
    - creates: /etc/letsencrypt/live/start.bricewge.fr/fullchain.pem
    - runas: root
    - require:
      - file: letsencrypt-create-cert

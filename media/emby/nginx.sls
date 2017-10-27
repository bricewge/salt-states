include:
  - .init
  - http.nginx
  - tls.letsencrypt
  
# * Nginx
emby-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/emby.conf
    - source: salt://media/emby/nginx.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

emby-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/emby.conf
    - target: /etc/nginx/sites-available/emby.conf
    - mode: 777
    - require:
      - file: emby-nginx-available
      - cmd: emby-cert
      - service: emby-service
  module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: emby-nginx-available
      - file: emby-nginx-enabled

# * TLS
emby-cert:
  cmd.run:
    - name: /usr/local/bin/create-certificate.sh {{ salt['pillar.get']('media:emby:domain') }}
    - creates: /etc/letsencrypt/live/{{ salt['pillar.get']('media:emby:domain') }}/fullchain.pem
    - runas: root
    - require:
      - file: letsencrypt-create-cert

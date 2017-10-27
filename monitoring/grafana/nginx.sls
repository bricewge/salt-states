include:
  - monitoring.grafana
  - http.nginx
  - tls.letsencrypt
  
# * Nginx
grafana-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/grafana.conf
    - source: salt://monitoring/grafana/files/nginx.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

grafana-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/grafana.conf
    - target: /etc/nginx/sites-available/grafana.conf
    - mode: 777
    - require:
      - file: grafana-nginx-available
      - cmd: grafana-cert
      - service: grafana-service
  module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: grafana-nginx-available
      - file: grafana-nginx-enabled

# * TLS
grafana-cert:
  cmd.run:
    - name: |
        /usr/bin/certbot certonly \
        --standalone \
        --agree-tos \
        --email brice.wge@gmail.com \
        --http-01-port 80 \
        --pre-hook "/bin/systemctl stop nginx.service" \
        --post-hook "/bin/systemctl start nginx.service" \
        --domain {{ salt['pillar.get']('monitoring:grafana:domain') }}
    - creates: /etc/letsencrypt/live/{{ salt['pillar.get']('monitoring:grafana:domain') }}/fullchain.pem
    - runas: root
    - require:
      - file: letsencrypt-create-cert

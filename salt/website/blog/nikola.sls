include:
  - tls.letsencrypt

# * Install
nikola-deps:
  pkg.installed:
    - pkgs:
      - python
      - python-dev
      - python-pip
      - libxml2-dev
      - libxslt1-dev
      - zlib1g-dev

nikola-install:
  pip.installed:
    - requirements: salt://website/blog/files/nikola.pip
    - user: root
    - require:
      - pkg: nikola-deps

# * Nginx
nikola-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/blog.bricewge.fr
    - source: salt://website/blog/files/blog-nginx.conf
    - user: root
    - group: root
    - mode: 644

nikola-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/blog.bricewge.fr
    - target: /etc/nginx/sites-available/blog.bricewge.fr
    - user: root
    - group: root
    - require:
      - file: nikola-nginx-available
      - cmd: nikola-cert
    module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: nikola-nginx-available
      - file: nikola-nginx-enabled

# * TLS
nikola-cert:
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
        --domain bricewge.fr \
        --domain blog.bricewge.fr \
        --domain www.bricewge.fr        
    - creates: /etc/letsencrypt/live/bricewge.fr/fullchain.pem
    - runas: root
    - require:
      - file: letsencrypt-create-cert



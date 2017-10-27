include:
  - http.nginx
  - tls.letsencrypt

# * Install
wallabag-deps:
  pkg.installed:
    - pkgs:
        - composer
        - php-fpm
        - php-common
        - php-json
        - php-gd
        - php-mbstring
        - php-xml
        - php-tidy
        - php-curl
        - php-gettext
        - php-bcmath
        - php-mysql
        - php-sqlite3
        - php-pgsql
    - fromrepo: testing

wallabag-repo:
  git.latest:
    - name: https://github.com/wallabag/wallabag.git
    - target: /srv/nginx/wallabag
    - rev: 2.1.1
    - user: www-data

wallabag-install:
  cmd.run:
    - name: |
        composer install --no-dev -o --prefer-dist --no-interaction &&\
        php bin/console wallabag:install --env=prod
    - env: 
      - SYMFONY_ENV: 'prod'
    - cwd: /srv/nginx/wallabag
    - creates: /srv/nginx/wallabag/vendor
    - user: www-data
    - watch:
      - git: wallabag-repo
    - require:
      - pkg: wallabag-deps
      - file: wallabag-config
# * Asynchronous tasks
wallabag-async-install:
  pkg.installed:
    - name: redis-server

wallabag-async-service:
  service.running:
    - name: redis.service
    - enable: True
    - watch:
      - pkg: wallabag-async-install

wallabag-async-worker:
  file.managed:
    - name: /etc/systemd/system/wallabag-async-worker@.service
    - source: salt://website/wallabag/wallabag-async-worker@.service
    - mode: 644
    - user: root
    - group: root
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: wallabag-async-worker

{% for worker in ['pocket', 'wallabag_v2', 'firefox', 'chrome'] %}
wallabag-async-{{ worker }}:
  service.running:
    - name: wallabag-async-worker@{{ worker }}.service
    - enable: True
    - watch:
      - file: wallabag-async-worker
      - service: wallabag-async-service
{% endfor %}

# * Config
wallabag-config:
  file.managed:
    - name: /srv/nginx/wallabag/app/config/parameters.yml
    - source: salt://website/wallabag/wallabag.conf
    - mode: 644
    - user: www-data
    - group: www-data

# * Nginx
wallabag-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/wallabag.conf
    - source: salt://website/wallabag/nginx.conf
    - mode: 644
    - user: root
    - group: root

wallabag-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/wallabag.conf
    - target: /etc/nginx/sites-available/wallabag.conf
    - mode: 777
    - require:
      - file: wallabag-nginx-available
      - file: wallabag-config
      - cmd: wallabag-cert
  module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: wallabag-nginx-available
      - file: wallabag-nginx-enabled

# * TLS
wallabag-cert:
  cmd.run:
    - name: |
        /bin/systemctl stop nginx && \
        /usr/bin/certbot certonly --standalone --agree-tos \
        --email brice.wge@gmail.com -d save.bricewge.fr; \
        /bin/systemctl start nginx
    - creates: /etc/letsencrypt/live/save.bricewge.fr/fullchain.pem
    - runas: root
    - require:
      - pkg: letsencrypt-install

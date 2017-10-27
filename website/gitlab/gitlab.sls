include:
  - http.nginx
  - tls.letsencrypt
  
# * Install
# Install GitLab dependencies
gitlab-deps:
  pkg.installed:
    - pkgs:
      - postfix
      - openssh-server
      - ca-certificates

# GitLab repository
gitlab-repo:
  pkgrepo.managed:
    - humanname: GitLab repo
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/debian/ jessie main
    - file: /etc/apt/sources.list.d/gitlab.list
    - key_url: https://packages.gitlab.com/gpg.key
    - require:
      - pkg: gitlab-repo
  pkg.installed:
    - name: apt-transport-https

# Install GitLab
gitlab-install:
  pkg.installed:
    - name: gitlab-ce
    - require: 
      - pkg: gitlab-deps
      - pkg: gitlab-repo

# * Configure
# Configure GitLab and apply the GitLab configuration
gitlab-config:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://website/gitlab/gitlab.rb
    - makedirs: True
    - user: root
    - group: root
    - dir_mode: 700
    - mode: 600
    - template: jinja
  cmd.run:
    - name: gitlab-ctl reconfigure
    - onchanges:
      - file: gitlab-config

# * Nginx
gitlab-nginx-group:
  group.present:
    - name: gitlab-www
    - addusers:
      - www-data
    - require:
      - pkg: gitlab-install

gitlab-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/gitlab.conf
    - source: salt://website/gitlab/gitlab-nginx.conf
    - template: jinja
    - mode: 644
    - user: root

gitlab-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/gitlab.conf
    - target: /etc/nginx/sites-available/gitlab.conf
    - mode: 777
    - require:
      - file: gitlab-nginx-available
      - file: gitlab-config
      - service: gitlab-service
      - cmd: gitlab-cert
  module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: gitlab-nginx-available
      - file: gitlab-nginx-enabled

# * Service
gitlab-service:
  service.running:
    - name: gitlab-runsvdir
    - enable: True
    - watch:
      - pkg: gitlab-install
      - cmd: gitlab-config

# * TLS
gitlab-cert:
  cmd.run:
    - name: /usr/local/bin/create-certificate.sh {{ salt['pillar.get']('website:gitlab:domain') }}
    - creates: /etc/letsencrypt/live/{{ salt['pillar.get']('website:gitlab:domain') }}/fullchain.pem
    - user: root
    - require:
      - file: letsencrypt-create-cert

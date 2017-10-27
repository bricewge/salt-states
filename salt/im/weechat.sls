include:
  - http.nginx
  - tls.letsencrypt

# * Install
weechat-install:
  pkg.installed:
    - pkgs:
      - weechat
      - tmux
      - lua-cjson
      - git

# * Plugin
weechat-python:
  file.directory:
    - name: /home/bricewge/.weechat/python/autoload
    - user: bricewge
    - group: bricewge
    - mode: 755
    - makedirs: True

weechat-slack:
  pkg.installed:
    - name: python-websocket
  git.latest:
    - name: https://github.com/rawdigits/wee-slack.git
    - target: /home/bricewge/.weechat/plugin/wee-slack
    - rev: master
    - user: bricewge
    - require:
      - pkg: weechat-slack
  file.symlink:
    - name: /home/bricewge/.weechat/python/autoload/wee_slack.py
    - target: /home/bricewge/.weechat/plugin/wee-slack/wee_slack.py
    - user: bricewge
    - require:
      - git: weechat-slack
      - file: weechat-python

weechat-otr:
  pkg.installed:
    - name: python-potr

# weechat-emoji:
#   git.latest:
#     - name: https://github.com/kattrali/weemoji.git
#     - target: /home/bricewge/.weechat/plugin/weemoji
#     - rev: master
#     - user: bricewge
#   file.symlink:
#     - name: /home/bricewge/.weechat/python/autoload/weemoji.py
#     - target: /home/bricewge/.weechat/plugin/weemoji/weemoji.py
#     - user: bricewge
#     - require:
#       - git: weechat-emoji
#       - file: weechat-python

# * Service
# TODO Find a nice way to manage the passwords for weechat
weechat-service:
  file.managed:
    - name: /etc/systemd/system/weechat@.service
    - source: salt://im/weechat@.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: weechat-install
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: weechat-service
  service.running:
    - name: weechat@bricewge
    - enable: True
    - watch:
      - file: weechat-service

# * Nginx
weechat-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/weechat.conf
    - source: salt://im/nginx.conf
    - mode: 644
    - user: root
    - group: root

weechat-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/weechat.conf
    - target: /etc/nginx/sites-available/weechat.conf
    - mode: 777
    - require:
      - file: weechat-nginx-available
      - cmd: weechat-cert
      - service: weechat-service
  module.run:
    - name: service.reload
    - m_name: nginx.service
    - onchanges:
      - file: weechat-nginx-available
      - file: weechat-nginx-enabled

# * TLS
weechat-cert:
  cmd.run:
    - name: |
        /bin/systemctl stop nginx && \
        /usr/bin/certbot certonly --standalone --agree-tos \
        --email brice.wge@gmail.com -d im.bricewge.fr; \
        /bin/systemctl start nginx
    - creates: /etc/letsencrypt/live/im.bricewge.fr/fullchain.pem
    - runas: root
    - require:
      - pkg: letsencrypt-install
      
# TODO Generate certificate
# openssl req -nodes -newkey rsa:4096 -keyout /home/bricewge/.weechat/ssl/relay.pem -x509 -days 365 -out /home/bricewge/.weechat/ssl/relay.pem -subj "/CN=irc.bricewge.fr/CN=bricewge.fr"
#

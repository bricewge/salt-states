include:
  - tor

nikola-tor-instance:
  cmd.run:
    - name: tor-instance-create blog
    - creates: /etc/tor/instances/blog/torrc
    - user: root
    - require:
      - pkg: tor-install

nikola-tor-config:
  file.append:
    - name: /etc/tor/instances/blog/torrc
    - text: |
        HiddenServiceDir /var/lib/tor-instances/blog
        HiddenServicePort 80 127.0.0.1:80
    - require:
      - cmd: nikola-tor-instance

nikola-tor-service:
  service.running:
    - name: tor@blog.service
    - enable: True
    - reload: True
    - watch:
      - pkg: tor-install
      - file: nikola-tor-config

nikola-tor-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/blog-tor.conf
    - source: salt://website/blog/files/tor-nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    # Need /var/lib/tor-instances/blog/hostname created by nikola-tor-service
    - require:
      - service: nikola-tor-service

nikola-tor-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/blog-tor.conf
    - target: /etc/nginx/sites-available/blog-tor.conf
    - require:
      - file: nikola-tor-nginx-available
      - file: nikola-tor-config
  service.running:
    - name: nginx.service
    - reload: True
    - watch:
      - file: nikola-tor-nginx-enabled
      - file: nikola-tor-nginx-available


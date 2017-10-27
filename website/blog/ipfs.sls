include:
  - ipfs
  - .nikola

nikola-ipfs-blog-service:
  file.managed:
    - name: /etc/systemd/system/blog-ipfs.service
    - source: salt://website/blog/files/blog-ipfs.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: ipfs-service
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: nikola-ipfs-blog-service

nikola-ipfs-blog-path:
  file.managed:
    - name: /etc/systemd/system/blog-ipfs.path
    - source: salt://website/blog/files/blog-ipfs.path
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: nikola-ipfs-blog-service
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: nikola-ipfs-blog-path
  service.running:
    - name: blog-ipfs.path
    - enable: True
    - require:
      - file: nikola-ipfs-blog-path

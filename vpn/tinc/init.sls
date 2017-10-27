tinc.install:
  pkg.installed:
    - name: tinc

tinc.panier.genkeys:
  cmd.run:
    - name: tincd -n panier -K
    - creates: /etc/tinc/panier/rsa_key.priv
    - require:
      - pkg: tinc.install

tinc.panier.conf:
  file.recurse:
    - name: /etc/tinc/panier/
    - source: salt://server/tinc/panier/
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - makedirs: True
    - template: jinja
    - require:
      - pkg: tinc.install

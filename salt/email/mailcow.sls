mailcow-install:
  pkg.archive:
    - name:
    - source: https://github.com/andryyy/mailcow/archive/v0.14.tar.gz

mailcow-remove:
  pkg.absent:
    - pkgs:
      - sendmail
      - exim4*
# mailcow-config:
#   file.managed:
#     - name: /srv/mailcow/mailcow.config
#     - source: salt://email/mailcow/config
#     - mode: 644
#     - require:
#       - pkg: mailcow-install

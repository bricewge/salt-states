# Odoo repository
odoo-repo:
  pkgrepo.managed:
    - humanname: Odoo repo
    - name: deb http://nightly.odoo.com/9.0/nightly/deb/ ./
    - file: /etc/apt/sources.list.d/odoo.list
    - key_url: https://nightly.odoo.com/odoo.key
    - require:
      - pkg: odoo-repo
  pkg.installed:
    - name: apt-transport-https

# Install Odoo
odoo-install:
  pkg.installed:
    - name: odoo
    - require: 
      - pkg: odoo-repo

# TODO Fix the creation of the database
# https://www.odoo.com/forum/help-1/question/dataerror-new-encoding-utf8-is-incompatible-with-the-encoding-of-the-template-database-sql-ascii-52124#answer_63158

# # * Config
# odoo-config:
#   file.managed:
#     - name: /etc/odoo/openerp-server.conf
#     - source: salt://odoo/config
#     - user: odoo
#     - group: odoo
#     - mode: 644

# * Datbase
odoo-database:
  postgres_user.present:
    - name: odoo
    - createdb: True

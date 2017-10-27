# * Install
sogo-repo:
  pkgrepo.managed:
    - humanname: Sogo
    - name: deb https://packages.inverse.ca/SOGo/nightly/3/debian/ jessie jessie
    - file: /etc/apt/sources.list.d/sogo.list
    - keyid: 0x810273c4
    - keyserver: keys.gnupg.net

sogo-install:
  pkg.installed:
    - name: sogo
    - require: 
      - pkgrepo: sogo-repo

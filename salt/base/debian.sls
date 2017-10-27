include:
  - .systemd

apt-preferences:
  file.managed:
    - name: /etc/apt/preferences
    - source: salt://base/files/preferences

apt-sources:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://base/files/sources.list
    - require:
      - file: apt-preferences

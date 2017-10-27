cups.install:
  pkg.installed:
    - pkgs:
      - cups
      - hplip
      - python-pyqt4
  service.running:
    - name: org.cups.cupsd
    - enable: True

cups.config:
  file.managed:
    - name: /etc/cups/cups-files.conf
    - source: salt://workstation/service/file/cups-files.conf
    - user: root
    - group: lp
    - mode: 640
    - require:
      - pkg: cups.install
  group.present:
    - name: printadmin
    - system: True

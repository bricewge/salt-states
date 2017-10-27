# * Snoopy server
snoopy-server:
  file.managed:
    - name: /etc/systemd/system/snoopy-server.service
    - source: salt://hack/files/snoopy-server.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: /etc/systemd/system/snoopy-server.service
  service.running:
    - name: snoopy-server
    - enable: True
    - reload: True
    - require:
      - file: snoopy-server
    - watch:
      - file: snoopy-server

# ** TODO auto snoopy-auth
# * XFCE
xfce4:
  pkg.installed

# * Maltego
# Maltego crash a couple of secondes after launch with openjdk
# maltego-deps:
#   pkg.installed:
#     - name: openjdk-8-jre

java-download:
  cmd.run:
    - name: "wget --no-check-certificate --no-cookies --header 'Cookie: oraclelicenseccept-securebackup-cookie' download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz"
    - cwd: /tmp
    - creates: /tmp/jre-8u60-linux-x64.tar.gz

java-build:
  pkgrepo.managed:
    - name: deb http://httpredir.debian.org/debian jessie main contrib
  pkg.installed:
    - pkgs:
      - java-package
      - build-essential
      - libxslt1-dev
  cmd.run:
    - name: yes | make-jpkg jre-8u60-linux-x64.tar.gz
    - user: vagrant
    - cwd: /tmp
    - creates: /tmp/oracle-java8-jre_8u60_amd64.deb
    - require:
      - cmd: java-download

java-install:
  pkg.installed:
    - sources:
        - make-jpkg: /tmp/oracle-java8-jre_8u60_amd64.deb
    - require:
      - cmd: java-build
    - unless: java -h

maltego:
  pkg.installed:
    - sources:
      - maltego: https://www.paterva.com/malv36/community/MaltegoChlorineCE.3.6.0.6640.deb
    - require:
      - pkg: java-install
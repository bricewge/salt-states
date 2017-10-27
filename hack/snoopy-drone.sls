# * Snoopy drone
snoopy-drone:
  file.managed:
    - name: /etc/systemd/system/snoopy-drone.service
    - source: salt://hack/files/snoopy-drone.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: /etc/systemd/system/snoopy-drone.service
  service.running:
    - name: snoopy-drone
    - enable: True
    - reload: True
    - require:
      - file: snoopy-drone
    - watch:
      - file: snoopy-drone

# * Mana
kali-repo:
  pkgrepo.managed:
    - humanname: kali
    - name: deb http://http.kali.org/kali sana main non-free contrib
    - file: /etc/apt/sources.list.d/kali.list
    - keyid: ED444FF07D8D0BF6
    - keyserver: pgp.mit.edu
    - refresh_db: True

mana-kali:
  pkg.installed:
    - pkgs:
      - sslsplit
      - metasploit-framework
      - python-scapy
    - fromrepo: sana
    - require:
      - pkgrepo: kali-repo

mana-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - git
      - libnl-3-dev
      - libnl-genl-3-dev
      - isc-dhcp-server
      - tinyproxy
      - libssl-dev
      - apache2
      - macchanger
      - python-dnspython
      - python-pcapy
      - python-twisted-web
      - dsniff
      - stunnel4
      - rfkill
      - tcpdump
      - usbutils
      - pciutils
      - aircrack-ng

mana-git:
  git.latest:
    - name: https://github.com/sensepost/mana.git
    - target: /opt/mana
    - rev: master
    - submodules: True
  # file.comment:
  #   - name: /opt/mana/hostapd-mana/hostapd/.config
  #   - regex: CONFIG_LIBNL32=y
  #   - char: '#'

mana-install:
  cmd.run:
    - name: make ; make install
    - cwd: /opt/mana/
    - require:
      - git: mana-git
    - unless: test -f /usr/share/mana-toolkit/run-mana/mana-menu.sh

# * Delorean
delorean-git:
  git.lateste:
    - name: https://github.com/PentesterES/Delorean.git
    - target: /opt/delorean
    - rev: master
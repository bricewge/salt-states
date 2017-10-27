# * Snoopy
snoopy-deps:
  pkg.installed:
    - pkgs:
      - git
      - python-libpcap # Fixed by https://github.com/sensepost/snoopy-ng/pull/63
      - psmisc         # Provide killall
      - bluez-tools    # Possibily form blutooth module
      - bluez          # Possibily form blutooth module
      - dnsmasq
      - python-twisted
  
snoopy-git:
  git.latest:
    - name: https://github.com/sensepost/snoopy-ng.git
    - target: /opt/snoopy-ng
    - require:
      - pkg: snoopy-deps

snoopy-install:
  cmd.run:
    - name: |
        yes | bash install.sh
        yes | snoopy

    - cwd: /opt/snoopy-ng
    - unless: snoopy -h
    - require:
      - git: snoopy-git


        




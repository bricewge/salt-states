tor-repo:
  pkgrepo.managed:
    - humanname: Tor Project
    - name: deb http://deb.torproject.org/torproject.org jessie main
    - file: /etc/apt/sources.list.d/torproject.list
    - keyid: A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
    - keyserver: keys.gnupg.net
  
tor-install:
  pkg.installed:
    - name: tor
    - require:
      - pkgrepo: tor-repo

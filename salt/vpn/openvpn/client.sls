# Prevent DNS leak, need additional config in each 
{% if grains['os'] == 'Arch' %}
openvpn-client-arch:
  pkg.installed:
    - pkgs:
      - openresolv
  file.managed:
    - name: /etc/openvpn/update-resolv-conf.sh
    - source: https://raw.githubusercontent.com/masterkorp/openvpn-update-resolv-conf/994574f36b9147cc78674a5f13874d503a625c98/update-resolv-conf.sh
    - source_hash: sha256=a3a5e2b8fa844c619f4ad30dc605c3d531dfdcbed6cbce901dcdf1bcd5207f2c
    - user: root
    - group: root
    - mode: 755
{% endif %}

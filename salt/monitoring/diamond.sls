# * Install
diamond.deps:
  pkg.installed:
    - name: python-pip

diamond.install:
  pip.installed:
    - name: diamond
    - require:
      - pkg: diamond.deps

# * User
diamond.user:
  group.present:
    - name: diamond
    - gid: 509
  user.present:
    - name: diamond
    - uid: 509
    - gid_from_name: True
    - require:
      - group: diamond.user
        
# * Config
diamond.config:
  file.recurse:
    - name: /etc/diamond/
    - source: salt://server/website/grafana/files/diamond
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - makedirs: True
    - include_empty: True

diamond.log:
  file.directory:
    - name: /var/log/diamond/
    - user: diamond
    - group: diamond
    - mode: 755

# * Service
diamond.service:
  file.managed:
    - name: /etc/systemd/system/diamond.service
    - source: salt://server/website/grafana/files/diamond.service
    - user: root
    - group: root
    - mode: 644
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: diamond.service
  # service.running:
  #   - name: diamond
  #   - enable: True
  #   - require:
  #     - file: diamond.install
  #     - file: diamond.log
  #   - watch:
  #     - file: diamond.service

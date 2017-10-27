# * LXC
include :
  - salt
#   - .network
  
lxc.install:
  pkg.installed:
    - pkgs:
      - lxc
      - bridge-utils
      - libvirt-bin
      - debootstrap
      - virt-what

# * Cgroup
lxc.cgmanager.install:
  pkg.installed:
    - name: cgmanager

lxc.cgmanager.service:
  file.managed:
    - name: /etc/systemd/system/cgmanager.service
    - source: salt://vm/files/cgmanager.service
    - user: root
    - group: root
    - mode: 744
  service.running:
    - name: cgmanager.service
    
      
# Activate cgroup memory
lxc.cgroup.memory:
  file.replace:
    - name: /etc/default/grub
    - pattern: '^GRUB_CMDLINE_LINUX=""$'
    - repl: 'GRUB_CMDLINE_LINUX="cgroup_enable=memory"'
  cmd.run:
    - name: update-grub2
    - onchanges:
      - file: lxc.cgroup.memory


# * Unprivileged
# ** Config
# La plage de subUID de root est la 100°: (65536*100)+100000
# Root peut avoir 50 (50*65536) machines virtuelles avec des UID différents
lxc.root.subuid:
  file.append:
    - name: /etc/subuid
    - text: 'root:6653600:3276800'
    - mode: 600

lxc.root.subgid:
  file.append:
    - name: /etc/subgid
    - text: 'root:6653600:3276800'
    - mode: 600

lxc.conf:
  file.managed:
    - name: /etc/lxc/lxc.conf
    - source: salt://vm/files/lxc.conf
      
lxc.jessie.unprivileged:
  file.managed:
    - name: /etc/lxc/jessie-unprivileged.conf
    - source: salt://vm/files/jessie-unprivileged.conf
  
# ** Workaround
# Unprivileged LXC containers with systemd aren't supported in Jessie. What
# follow is a try to make it work
# http://myles.sh/configuring-lxc-unprivileged-containers-in-debian-jessie/
lxc.systemd:
  pkg.installed:
    - name: systemd
#    - fromrepo: testing

lxc.download.template:
  file.replace:
    - name: /usr/share/lxc/templates/lxc-download
    - pattern: 'DOWNLOAD_COMPAT_LEVEL'
    - repl: 'DOWNLOAD_COMPAT_LEVEL'

# * Containers
#lxc.test1:
#  cloud.profile:
#    - name: test1
#    - profile: durian-test
#    - running: True

# beets-lxc:
#   lxc.present:
#     - profile: default-lxc
#     - running: True

# beets-lxc:
#   cloud.profile:
#     - profile: default-lxc

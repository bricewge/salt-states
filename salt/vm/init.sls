# * VirtualBox
virtualbox:
  pkg:
    - installed
    - pkgs:
      - virtualbox
      - virtualbox-host-modules
  file.managed:
    - name: /etc/modules-load.d/virtualbox.conf
    - contents: "vboxdrv"
    - user: root
    - group: root
    - mode: 644
    - create: True
    - require:
      - pkg: virtualbox
  # Eanble USB sharing iwth guest for those users
  group.present:
    - members:
      - bricewge
    - require:
      - pkg: virtualbox
  kmod.present:
    - name: "vboxdrv"
    - unless:
      - lsmod | grep vboxguest
    - require:
      - file: virtualbox
  # require:
  #   - pkg: gnome
# TODO Changer la touche pour sortir de Virtualbox, par défautl c'est Ctrl droit, touche qui n'existe pas sur un clavier de Macbook français

# * Qemu
qemu:
  pkg.installed
  # require:
  #   - pkg: gnome

# * Vagrant
vagrant:
  pkg.installed
  # require:
  #   - pkg: gnome

vagrant-libvirt:
  # Fix needed for the instalation of vagrant-libvirt
  # https://bbs.archlinux.org/viewtopic.php?pid=1387378#p1387378
  cmd.run:
    - name: "vagrant plugin install vagrant-libvirt"
    - user: bricewge
    - unless:
    - require:
      - pkg: libvirt

# AUR package
# veewee:
#   cmd.run:
#     - name: "yaourt -S --noconfirm ruby-veewee ruby-libvirt"
#     - unless: "pacman -Qk ruby-veewee" # If already installed don't reinstall.
#     - require:
#       - pkg: yaourt
# May need arp in net-tools and opdeps ruby-libvirt for kvm

# * libvirt
# Need libvirt 1.2.7-1 until https://bugs.archlinux.org/task/41898 is fixed
libvirt:
  pkg.installed:
    - name: libvirt
  group.present:
    - name: libvirt
    - members:
      - bricewge
    - require:
      - pkg: libvirt

libvirt-depends:
  pkg.installed:
    - pkgs:
      - ebtables
      - dnsmasq
      - bridge-utils
      - openbsd-netcat
      - dmidecode

# Edit the file /etc/libvirt/libvirtd.conf
# #unix_sock_group = "libvirt"
# #unix_sock_ro_perms = "0770"
# #unix_sock_rw_perms = "0770"
# #auth_unix_ro = "none"
# #auth_unix_rw = "none"
      
include:
  - .systemd

# * repositories
archlinux.archlinuxfr:
  file.append:
    - name: /etc/pacman.conf
    - text:
      - "[archlinuxfr]"
      - "SigLevel = Never"
      - "Server = http://repo.archlinux.fr/$arch"

archlinux.multilib:
  file.append:
    - name: /etc/pacman.conf
    - text:
      - "[multilib]"
      - "Include = /etc/pacman.d/mirrorlist"

# * utils
pacman.utils:
  pkg.installed:
    - pkgs:
      - expac
      - namcap
      - pkgbuild-introspection
      - pkgfile
      - srcpac

pacman.pkgfile:
  service.running:
    - name: pkgfile-update.timer
    - enable: True
    - require:
      - pkg: pacman.utils

downgrade:
  pkg.installed:
    - name: downgrade
  require:
    - file: archlinux.archlinuxfr

yaourt:
  pkg.installed:
    - refresh: True
  require:
    - file: archlinux.archlinuxfr

# Is in  AUR
# archlinux.pacaur:
#   pkg.installed:
#     - name: pacaur

# * config
archlinux.makeflags:
  file.replace:
    - name: /etc/makepkg.conf
    - pattern: '^#MAKEFLAGS.*$'
    - repl: 'MAKEFLAGS="-j$(nproc)"'

archlinux.makepkg:
  file.managed:
    - name: /etc/makepkg.conf
    - source: salt://base/files/makepkg.conf
    - user: root
    - group: root
    - mode: 644

archlinux.pacaur:
  file.managed:
    - name: /etc/xdg/pacaur/config
    - source: salt://base/files/pacaur.conf
    - user: root
    - group: root
    - mode: 644
    # - require:
    #   - pkg: archlinux.pacaur

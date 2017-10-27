# * most used
vlc:
  pkg.installed:
    - pkgs:
      - vlc
      - npapi-vlc

firefox:
  pkg:
    - installed
    - pkgs:
      - firefox
      - firefox-i18n-fr
      - firefox-i18n-en-us

flash-install:
  pkg.installed:
    - name: flashplugin
    - require:
      - pkg: firefox

flash-config:
  file.managed:
    - name: /etc/adobe/mms.cfg
    - source: salt://gui/gui-app/flashplugin.conf
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: flash-install

# Fix flash fullscreen issues
# SaltStack doesn't want to edit a binary file...
# http://christianiversen.dk/2013/07/flash-is-terrible-how-to-fix-fullscreen-flash/
flash-patch:
  cmd.wait:
    - name: sed -i -re s/_NET_ACTIVE_WINDOW/XNET_ACTIVE_WINDOW/ /usr/lib/mozilla/plugins/libflashplayer.so
    - watch:
      - pkg: flash-install
    - require:
      - pkg: flash-install

# Same as with termite
# transmission-remote-gtk:
#   cmd.run:
#     # Termite need a patched vte3, so we removed it before to avoid inter-conflicts.
#     - name: "yaourt -S --noconfirm transmission-remote-gtk"
#     - unless: "pacman -Qk transmission-remote-gtk" # If already installed don't reinstall.
#     - user: bricewge
#     - group: bricewge
#     - require:
#       - pkg: yaourt

# * fonts
fonts-pkg:
  pkg.installed:
    - pkgs:
      - cairo
      - fontconfig
      - freetype2
      - ttf-linux-libertine
#       AUR package
#       - fonts-meta-extended-lt
#       - ttf-ms-fonts #AUR

fonts-conf-lcd:
  file.symlinlk:
    - name:  /etc/fonts/conf.d/11-lcdfilter-default.conf
    - target: /etc/fonts/conf.avail/11-lcdfilter-default.conf
    - require:
      - pkg: fonts-pkg

font-conf-subpixel:
  file.symlink:
    - name:  /etc/fonts/conf.d/10-sub-pixel-rgb.conf
    - target: /etc/fonts/conf.avail/10-sub-pixel-rgb.conf
    - require:
      - pkg: fonts-pkg

font-conf-infinality:
  file.symlink:
    - name:  /etc/fonts/conf.d/30-infinality-aliases.conf
    - target: /etc/fonts/conf.avail/30-infinality-aliases.conf
    - require:
      - pkg: fonts-pkg

# * misc
misc-apps:
  pkg.installed:
    - pkgs:
      - xorg-xkill
      - xorg-xev
      - bleachbit

# * graphic
gimp:
  pkg.installed

inkscape:
  pkg.installed

# * office
libreoffice:
  pkg.installed:
    - pkgs:
      - libreoffice-fresh
      - libreoffice-fresh-fr
      - libreoffice-fresh-en-GB

scanner:
  pkg.installed:
    - pkgs:
      - simple-scan
      - hplip
  file.uncomment:
    - name: /etc/sane.d/dll.conf
    - regex: hpaio

# * CAD
openscad-pkg:
  pkg.installed:
    - name: openscad

freecad-pkg:
  pkg.installed:
    - name: freecad

# * game
steam:
  pkg.installed

playonlinux-pkg:
  pkg.installed:
    - pkgs:
      - playonlinux
      - lib32-mesa-libgl

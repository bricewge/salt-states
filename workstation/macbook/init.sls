# * Intel HD Graphics
# ** Drivers
intel-drivers:
  pkg.installed:
    - pkgs:
      - mesa-libgl

i915-kms:
  file.replace:
    - name: /etc/mkinitcpio.conf
    - repl: "MODULES=\"i915\""
    - pattern: "MODULES=\"\""
    - count: 1
    - require:
      - pkg: intel-drivers
  cmd.run:
    - name: mkinitcpio -p linux
    - onchanges:
      - file: i915-kms

# ** Hardware acceleration
hwacceleration-pkg:
  pkg.installed:
    - pkgs:
      - libva-intel-driver
      - mesa
      - libvdpau-va-gl

hwacceleration-config:
  file.append:
    - name: /etc/profile
    - text: export VDPAU_DRIVER=va_gl

# * Keyboard
# ** Keymap
# Install keymap for AZERTY mba42 and set it as default
keymap-mba42:
  file.managed:
    - name: /usr/local/share/kbd/keymaps/mba42-azerty.map
    - source: salt://workstation/macbook/mba42-azerty.map
    - user: root
    - group: root
    - mode: 644
    - dir_mode: 755
    - makedirs: True
  keyboard.system:
    - name: /usr/local/share/kbd/keymaps/mba42-azerty.map
    - require:
      - file: keymap-mba42
  
# ** SysRq
# Set the the multimediakey for F3 to SysRq/PrtSc
kbd-mba42:
  file.managed:
    - name: /etc/udev/hwdb.d/90-apple-mb42.hwdb
    - source: salt://workstation/macbook/90-apple-mb42.hwdb
    - user: root
    - group: root
    - mode: 644

# Enable all the sysrq functions
sysrq-config:
  file.managed:
    - name: /etc/sysctl.d/90-sysrq.conf
    - source: salt://workstation/macbook/90-sysrq.conf
    - user: root
    - group: root
    - mode: 644
    - dir_mode: 755
    - makedirs: True

# * Touchpad
# =libinput= is now the prefered input driver to use
macbook-touchpad:
  pkg.installed:
    - name: xf86-input-libinput
macbook-touchpad-old:
  pkg.removed:
    - pkgs:
      - xf86-input-evdev
      - xf86-input-synaptics

# * Fan

# mbpfan-install:
#   pkg.installed:
#     - mbpfan-git (AUR)

mbpfan-service:
  service.running:
    - name: mbpfan
    - enable: True
#     - require:
#       - pkg: mbpfan-install

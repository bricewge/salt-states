# * Languages
locale-english:
  locale.present:
  - name: en_US.UTF-8 UTF-8 

locale-french:
  locale.present:
  - name: fr_FR.UTF-8 UTF-8  

locale-default:
  locale.system:
    - name: fr_FR.UTF-8
    - require:
      - locale: locale-french

# * Keyboard
{% if grains['localhost'] != 'noisette' %}
keymap-system:
  keyboard.system:
    - name: fr
# Debian derived distributions don't follow the systemd way to set
# the keymap for the console. https://github.com/saltstack/salt/issues/36239
{% if grains['os_family'] == 'Debian' %}
  pkg.installed:
    - pkgs:
      - console-data
      - console-setup
  cmd.run:
    - name: setupcon
    - require:
      - pkg: keymap-system
    - watch:
      - keyboard: keymap-system        
{%endif%}
{% endif %}

# * Time
timezone:
  timezone.system:
    - name: Europe/Paris
    - utc: False

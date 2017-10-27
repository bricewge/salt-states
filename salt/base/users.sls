# Use formulas configured from pillar
include:
  - users
  - sudoers

zsh:
  pkg:
    - installed

  
# * Umask
# Set umask to 002
{% if grains['os'] == 'Arch'%}
/etc/profile:
  file.replace:
  - name: /etc/profile
  - pattern: "umask 022"
  - repl: "umask 002"
{% elif grains['os'] == 'Debian' %}
/etc/login.defs:
  file.managed:
    - name: /etc/login.defs
    - source: salt://base/files/login.defs
    - user: root
    - group: root
    - mode: 644

/etc/pam.d/common-session:
  file.managed:
    - name: /etc/pam.d/common-session
    - source: salt://base/files/common-session
    - user: root
    - group: root
    - mode: 644
{% endif %}
# For Debian look in "/etc/login.defs", but looks like it also set a newly create user home to the umask default (ex: umask=002 -> home=775)

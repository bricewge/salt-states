# * Others
misc-cli-tools:
  pkg.installed:
    - pkgs:
      - pass
      - youtube-dl
      - pv
      - gptfdisk
      - htop
      - sshuttle

latex-tools:
  pkg.installed:
    - pkgs:
      - texlive-core
#      - texlive-most # Group package
  
## Aur packages
#
# trash-cli:
#   pkg.installed
#
# nikola-pkg:
#   pkg.installed:
#     - pkgs:
#       - python-nikola
#       - python-nikola-doc
#       - python-pyphen
#       - python-typogrify
#       - python-webassets
#       - python-micawber
#       - python-ws4py
#       - python-watchdog
#       - python-pygal
#       - pygmentize

# * Networking
netwotking-tools:
  pkg.installed:
    - pkgs:
      - dialog
      - wpa_supplicant
      - httpie
      - whois

# * Programming
r-pkg:
  pkg.installed:
    - name: r

# AUR recipe      
# arduino:
#   pkg.installed

python2-pkg:
  pkg.installed:
    - pkgs:
      - python2
      - python2-pandas
      - python2-numpy
      - python2-scipy
      - python2-matplotlib
      - ipython2
      - ipython2-notebook

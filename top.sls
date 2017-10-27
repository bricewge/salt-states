base:
  '*':
    - base
#    - tls.pki-cert
  'os:Debian':
    - match: grain
    - base.debian
  'os:Arch':
    - match: grain
    - base.archlinux
  'durian*':
#    - backup.attic-server
    - ipfs
    - vm.lxc
    - torrent.transmission
    - dns.gandyn
    - filesystem.server
    - http.nginx
    - im.weechat
    - monitoring
    - mqtt
    - network.server
    - nfs.server
    - tls.letsencrypt
    - website
#    - tls.pki-ca
  'noisette*':
    - workstation
    - backup.attic-client
    - pki.privkey
    - ssh
    - gui
    - termite
    - offlineimap
    - filesystem.refind
    - filesystem.btrfs
    - nfs.client
    - vpn.openvpn.client
#    - vm

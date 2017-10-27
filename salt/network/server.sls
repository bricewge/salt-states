system:
    network.system:
      - enabled: True
      - hostname: durian
      - require_reboot: True

eth0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.10.2
    - netmask: 255.255.255.0
    - gateway: 192.168.10.1
#    - bridge: lxcbr0

# lxcbr0:
#   network.managed:
#     - enabled: True
#     - type: bridge
#     - proto: dhcp
#     - bridge: lxcbr0
#     - delay: 0
#     - ports: eth0
#     - bypassfirewall: True
#     - use:
#       - network: eth0
#     - require:
#       - network: eth0

durian.forward:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1

# Needed for the ethernet chipset r8169
firmware-realtek:
  pkg.installed
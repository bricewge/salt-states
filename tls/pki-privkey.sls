# Create private key then requests a certificate signed by CA
# according to the signing policy.

pki-privkey-key:
  x509.private_key_managed:
    - name: /etc/pki/{{ grains['localhost'] }}.key
    - bits: 4096
    - require:
      - file: pki-privkey-key
  file.directory:
    - name: /etc/pki
    - user: root
    - group: root
    - mode: 755

pki-privkey-certificate:
  x509.certificate_managed:
    - name: /etc/pki/{{ grains['localhost'] }}.crt
    - ca_server: durian
    - signing_policy: durian-test
    - public_key: /etc/pki/{{ grains['localhost'] }}.key
    - CN: www.example.com
    - days_remaining: 30
    - backup: True

pki-privkey-key-mqtt:
  x509.private_key_managed:
    - name: /etc/pki/mqtt-{{ grains['localhost'] }}.key
    - bits: 4096
    - require:
      - file: pki-privkey-key-mqtt
  file.directory:
    - name: /etc/pki
    - user: root
    - group: root
    - mode: 755

pki-privkey-certificate-mqtt:
  x509.certificate_managed:
    - name: /etc/pki/mqtt-{{ grains['localhost'] }}.crt
    - ca_server: durian
    - signing_policy: mqtt
    - public_key: /etc/pki/mqtt-{{ grains['localhost'] }}.key
    - CN: www.example.com
    - days_remaining: 365
    - backup: True

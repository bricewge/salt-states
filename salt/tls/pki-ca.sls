# Put in place signing policy, generate CA key and certificate of the CA.
 
pki-ca-signing_policies:
  file.managed:
    - name: /etc/salt/minion.d/signing_policies.conf
    - source: salt://tls/files/signing_policies.conf
  service.running:
    - name: salt-minion
    - listen:
      - file: pki-ca-signing_policies 

pki-ca-key:
  file.directory:
    - name: /etc/pki/issued_certs
    - makedirs: True
    - user: root
    - group: root
    - mode: 755
  x509.private_key_managed:
    - name: /etc/pki/ca-{{ grains['localhost'] }}.key
    - bits: 4096
    - backup: True
    - require:
      - file: pki-ca-key
        
pki-ca-certificate:
  x509.certificate_managed:
    - name: /etc/pki/ca-{{ grains['localhost'] }}.crt
    - signing_private_key: /etc/pki/ca-{{ grains['localhost'] }}.key
    - CN: ca.example.com
    - C: US
    - ST: Utah
    - L: Salt Lake City
    - basicConstraints: "critical CA:true"
    - keyUsage: "critical cRLSign, keyCertSign"
    - subjectKeyIdentifier: hash
    - authorityKeyIdentifier: keyid,issuer:always
    - days_valid: 3650
    - days_remaining: 0
    - backup: True
    - require:
      - x509: /etc/pki/ca-{{ grains['localhost'] }}.key
  module.run:
    - name: mine.send
    - func: x509.get_pem_entries
    - kwargs:
        glob_path: /etc/pki/ca-{{ grains['localhost'] }}.crt
    - onchanges:
      - x509: pki-ca-key
    - order: 50

pki-certificate-mqtt:
  module.run:
    - name: mine.send
    - func: x509.get_pem_entries
    - kwargs:
        glob_path: /etc/letsencrypt/live/mqtt.bricewge.fr/cert.pem

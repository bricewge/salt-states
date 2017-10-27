# Put CA certificate in place

# TODO Get certificate of all CA based on their role (pki.ca)

/usr/local/share/ca-certificates:
  file.directory: []

pki-cert-ca-durian:
  x509.pem_managed:
    - name: /usr/local/share/ca-certificates/ca-durian.crt
    - text: {{ salt['mine.get']('durian', 'x509.get_pem_entries')['durian']['/etc/pki/ca-durian.crt']|replace('\n', '') }}

pki-cert-mqtt:
  x509.pem_managed:
    - name: /usr/local/share/ca-certificates/mqtt.crt
    - text: {{ salt['mine.get']('durian', 'x509.get_pem_entries')['durian']['/etc/letsencrypt/live/mqtt.bricewge.fr/cert.pem']|replace('\n', '') }}

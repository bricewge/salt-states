#!/bin/bash

# Create an initial certificates from letsencrypt

DOMAIN="$1"

/bin/systemctl stop nginx
/usr/bin/certbot certonly \
		 --standalone \
		 --agree-tos \
		 --email {{ salt['pillar.get']('tls:letsencrypt:email') }} \
		 --domain $DOMAIN
/bin/systemctl start nginx

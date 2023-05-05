#!/bin/bash

#SSL certifate with Let's Encrypt
DOMAIN='diamond.kubace.com'

#Install certbot
#apt install certbot python3-certbot-nginx -y

#Confirming Nginx's conf
FILE="/etc/nginx/sites-available/${DOMAIN}"
STRING="server_name ${DOMAIN} ${DOMAIN}"

if [[ -z $(grep "${STRING}" "${FILE}") ]]
	then
		echo 'Nginx conf confirmed'
	else
		echo 'Nginx conf not confirmed'
fi

echo

nginx -t

echo

systemctl reload nginx

#Obtaining an SSL certificate
sudo certbot --nginx -d ${DOMAIN}


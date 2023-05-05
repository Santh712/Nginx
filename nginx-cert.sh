#!/bin/bash

DOMAIN_NAME="${1}"

#Updating and installing Nginx.
sudo apt update
sudo apt install nginx -y

#Checking the webserver status
systemctl status nginx

#Setting up server blocks.
mkdir -p /var/www/${DOMAIN_NAME}/html
chown -R $USER:$USER /var/www/${DOMAIN_NAME}
chmod -R 755 /var/www/${DOMAIN_NAME}

#Editing index.html
cd /var/www/${DOMAIN_NAME}/html/
echo '<html>
<head>
<title>Creating Nginx and certifcate!</title>
</head>
<body>' > index.html
echo "<h1>The sript for ${DOMAIN_NAME} was successful in executing!!</h1>" >> index.html
echo '</body>
</html>' >> index.html

#Adding configuration block.
cd /etc/nginx/sites-available/
echo "server {listen 80; listen [::]:80; root /var/www/${DOMAIN_NAME}/html; index index.html; server_name ${DOMAIN_NAME} www.${DOMAIN_NAME}; location / {try_files \$uri \$uri/ =404;} }" > ${DOMAIN_NAME}

#Creating link between sites-available and sites-enabled
ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/

#Modifying nginx.conf file
sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' /etc/nginx/nginx.conf

#Test to make sure that there are no syntax errors
nginx -t

#restarting the system
systemctl reload nginx

echo "'$?"

#Install certbot
apt install certbot python3-certbot-nginx -y

#Confirming Nginx's conf
FILE="/etc/nginx/sites-available/${DOMAIN_NAME}"
STRING="server_name ${DOMAIN_NAME} ${DOMAIN_NAME}"

if [[ -z $(grep "${STRING}" "${FILE}") ]]
        then
                echo 'Nginx conf confirmed'
        else
                echo 'Nginx conf not confirmed'
fi

echo

#Obtaining an SSL certificate
sudo certbot --nginx -d ${DOMAIN_NAME}

#Test to make sure that there are no syntax errors
nginx -t

#restarting the system
systemctl reload nginx

echo "'$?"


#!/bin/bash

sed -i "s/{NGINX_VHOST}/$NGINX_VHOST/g" 	       /etc/nginx/conf.d/default.conf
sed -i "s/{NGINX_FASTCGI_HOST}/$NGINX_FASTCGI_HOST/g"  /etc/nginx/conf.d/default.conf

echo -n "Executing Arguments..."
exec "$@"

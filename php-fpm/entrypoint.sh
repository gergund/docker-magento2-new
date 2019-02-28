#!/bin/bash

if [ "$ENABLE_XDEBUG" = "true" ]; then
        echo -n "Enabling XDebug..."
        docker-php-ext-enable xdebug
fi

if [ "$ENABLE_SENDMAIL" == "true" ]; then
	echo -n "Executing Sendmail..."
	line=$(head -n 1 /etc/hosts)
	line2=$(echo $line | awk '{print $2}')
	echo "$line $(hostname)  $line2.localdomain" >> /etc/hosts
	/etc/init.d/sendmail start
fi

if [ "$COPY_MAGENTO_VOLUME" = "true" ]; then
	echo -n 'Clean Volume and COPY Magento code...'
	rm -Rf /var/www/html/*
	cp -r /magento-code/* /var/www/html/
	chown -R www-data:www-data /var/www/html/
	echo -n "Done..."
fi

if [ "$INSTALL_MAGENTO" = "true" ]; then
        echo -n "Changing owner of the Magento code..."
	chown -R www-data:www-data /var/www/html/
	echo -n "Composer install..."
	cd /var/www/html/
	sudo -u www-data composer install
	
	sudo -u www-data php bin/magento setup:install --db-host=$MAGENTO_MYSQL_HOST --db-name=$MAGENTO_MYSQL_DB --db-user=$MAGENTO_MYSQL_USER --db-password=$MAGENTO_MYSQL_PASSWORD --base-url=$MAGENTO_URL --backend-frontname=admin --admin-user=$MAGENTO_ADMIN_USER --admin-password=$MAGENTO_ADMIN_PASSWORD --admin-email=$MAGENTO_ADMIN_EMAIL --admin-firstname=Admin --admin-lastname=Admin --language=en_US --currency=USD --timezone=America/Chicago --skip-db-validation --session-save=redis --session-save-redis-host=$MAGENTO_SESSION_REDIS_HOST --cache-backend=redis --cache-backend-redis-server=$MAGENTO_CACHE_REDIS_HOST --page-cache=redis --page-cache-redis-server=$MAGENTO_FPC_REDIS_HOST
	echo -n "Done..."
fi

if [ "$RESET_MAGENTO_MODE" = "true" ]; then 
	echo -n "Configuring MAGENTO MODE:"
	sudo -u www-data php bin/magento deploy:mode:set $MAGENTO_MODE
	echo -n "Done"
fi

echo -n "Executing Arguments..."
exec "$@"

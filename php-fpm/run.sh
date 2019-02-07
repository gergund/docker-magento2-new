#!/bin/bash
docker run --name php-fpm --hostname php-fpm.magento.loc --env-file=../.env -d php-fpm

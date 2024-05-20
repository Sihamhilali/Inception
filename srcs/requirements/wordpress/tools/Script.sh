#!/bin/bash
sleep 15

if [ -f /var/www/html/wp-config.php ]; then
    echo "wordpress already installed"
else
mkdir -p /var/www/html

cd /var/www/html


rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

chmod +x wp-cli.phar 

mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root
wp config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb
wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=supervisor --admin_password=strongpassword --admin_email=info@example.com --allow-root
sed -i "s/^listen = .*/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf
service php7.4-fpm stop

# wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
fi
php-fpm7.4 -F
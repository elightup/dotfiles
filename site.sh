#!/bin/bash

echo -n "Enter a domain name: "
read domain

createVhost() {
	echo "Creating vỉrtual host..."

	echo "<VirtualHost *:80>
	    ServerName $domain
	    DocumentRoot /var/www/$domain
	    LogLevel error
	    <Directory /var/www/$domain>
	        Options FollowSymLinks
	        AllowOverride All
	    </Directory>
	</VirtualHost>" > "/etc/apache2/sites-available/$domain.conf"

	a2ensite $domain > /dev/null

	mkdir -p "/var/www/$domain"

	service apache2 restart
}

createDb() {
	echo "Creating database..."

	echo -n "Enter MySQL root password (optional): "
	read root_pwd

	db=${domain/./_}
	user_pwd=$(echo $RANDOM | base64)

	if [ -n $root_pwd ]
	then
		mysql -u root -p"$root_pwd" -e "CREATE DATABASE $db;" > /dev/null
		mysql -u root -p"$root_pwd" -e "CREATE USER '$db'@'localhost' IDENTIFIED BY '$user_pwd';" > /dev/null
		mysql -u root -p"$root_pwd" -e "GRANT ALL PRIVILEGES ON $db.* TO '$db'@'localhost';"
	else
		mysql -u root -e "CREATE DATABASE $db;" > /dev/null
		mysql -u root -e "CREATE USER '$db'@'localhost' IDENTIFIED BY '$user_pwd';" > /dev/null
		mysql -u root -e "GRANT ALL PRIVILEGES ON $db.* TO '$db'@'localhost';"
	fi
}

installWp() {
	echo "Installing WordPress..."
}

createVhost
createDb
installWp

echo "Done!"
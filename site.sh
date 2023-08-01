#!/bin/bash

###############################################################################
# The VPS management script
#
# - Install LAMP with Git, WP-CLI, Composer, Let's Encrypt, mailutils and unzip
# - Add domains (virtual host)
# - Add SSL
# - Add WordPress sites
# - Create a database
###############################################################################

# The main (entry) function.
main() {
	checkRoot
	outputMenu
}

# Output the main menu and prompt user to select an item.
outputMenu() {
	clear
	welcome
	echo "How can I help you?"
	outputLine
	echo "1. Install the system
2. Add a WordPress site
3. Add a domain
4. Create a database
5. Add SSL with Let's Encrypt (Certbot)
6. Quit"
	outputLine
	echo ""

	read -p "Enter a choice [1-6]: " choice
	echo ""

	case $choice in
		1)
			install
			backToMenu
			;;
		2)
			read -p "Enter a domain name: " domain

			# Setup variables.
			path="/var/www/$domain"
			db_name=${domain/./_}
			db_pwd=$(echo $RANDOM | base64)
			admin_pwd=$(echo $RANDOM | base64)
			wp="wp --allow-root --path=$path --quiet"

			createVhost
			createDb
			installWp
			backToMenu
			;;
		3)
			read -p "Enter a domain name: " domain

			# Setup variables.
			path="/var/www/$domain"

			createVhost
			backToMenu
			;;
		4)
			read -p "Enter the database/user name: " db_name
			read -p "Enter the user password: " db_pwd

			createDb
			backToMenu
			;;
		5)
			certbot --apache
			backToMenu
			;;
	esac
}

# Go back to the main menu.
backToMenu() {
	echo ""
	# -n: Defines the required character count to stop reading
	# -s: Hide the user's input
	# -r: Cause the string to be interpreted "raw" (without considering backslash escapes)
	read -rsn1 -p "Press any key to go back to the main menu or Ctrl-C to exit..."
	outputMenu
}

# Install the system
install() {
	echo "# Installing the system"

	echo "  - Updating the system"
	# -qq: Don't output anything excepts errors.
	apt-get -qq update

	echo "  - Installing Apache"
	# -y: Automatic yes to prompts.
	apt-get install -qqy apache2 libapache2-mod-fcgid

	echo "  - Installing MariaDB"
	apt-get install -qqy mariadb-server mariadb-client libmysqlclient-dev

	echo "  - Installing PHP"
	apt-get install -qqy php-fpm php-json php-mysqli php-imagick php-curl php-mbstring php-xml php-zip php-intl

	echo "  - Installing Memcached"
	apt-get install -qqy memcached php-memcached php-memcache

	echo "  - Installing Git"
	apt-get install -qqy git

	echo "  - Installing mailutils and unzip"
	apt-get install -qqy mailutils unzip

	echo "  - Installing WP-CLI"
	# -s: Silent mode.
	# -O: Write output to file.
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	echo "  - Installing Composer"
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar /usr/local/bin/composer

	echo "  - Installing Let's Encrypt (Certbot)"
	snap install core
	snap refresh core
	snap install --classic certbot
	ln -s /snap/bin/certbot /usr/bin/certbot

	echo "  - Enabling Apache modules"
	# -q: Quiet mode.
	a2enmod -q rewrite expires headers proxy_fcgi setenvif
	a2enconf -q php8.1-fpm

	echo "  - Restarting Apache"
	service apache2 restart

	# -e: Enable interpretation of backslash escapes.
	echo -e "\nDONE"
}

createVhost() {
	echo -e "\n# Creating virtual host"

	echo "  - Adding configuration file"
	echo "<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot $path
    LogLevel error
    <Directory $path>
        Options FollowSymLinks
        AllowOverride All
    </Directory>

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
    RewriteRule ^(.*)$ https://%1$1 [R=301,L]
</VirtualHost>" > "/etc/apache2/sites-available/$domain.conf"

	echo "  - Enabling the site"
	# -q: Quiet mode.
	a2ensite -q $domain > /dev/null

	echo "  - Creating site directory"
	mkdir -p $path

	echo "  - Restarting Apache"
	service apache2 restart

	echo -e "\nDONE\n"

	echo "The document root directory for the domain $domain is: $path"
}

createDb() {
	echo -e "\n# Creating database"

	# read -p "  - Enter MySQL root password (optional): " root_pwd
	# root_pwd=""

	# if [ -n $root_pwd ]
	# then
	# 	# -s: Silent mode.
	# 	# -e: Execute the statement and quit.
	# 	mysql -u root -p"$root_pwd" -s -e "CREATE DATABASE $db_name;"
	# 	mysql -u root -p"$root_pwd" -s -e "CREATE USER '$db_name'@'localhost' IDENTIFIED BY '$db_pwd';"
	# 	mysql -u root -p"$root_pwd" -s -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_name'@'localhost';"
	# else
		echo "  - Creating database"
		mysql -u root -s -e "CREATE DATABASE $db_name;"
		echo "  - Creating user"
		mysql -u root -s -e "CREATE USER '$db_name'@'localhost' IDENTIFIED BY '$db_pwd';"
		echo "  - Granting user privileges"
		mysql -u root -s -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_name'@'localhost';"
	# fi

	echo -e "\nDONE\n"

	echo "# Database information:"
	echo "  - Database name: $db_name"
	echo "  - Username:      $db_name"
	echo "  - Password:      $db_pwd"
}

installWp() {
	echo -e "\n# Installing WordPress"

	echo "  - Downloading WordPress"
	$wp core download --skip-content --force

	echo "  - Updating wp-config.php file"
	mv "$path/wp-config-sample.php" "$path/wp-config.php"
	sed -i "s/database_name_here/$db_name/" "$path/wp-config.php"
	sed -i "s/username_here/$db_name/" "$path/wp-config.php"
	sed -i "s/password_here/$db_pwd/" "$path/wp-config.php"

	echo "  - Installing WordPress"
	$wp core install --url="$domain" --title="$domain" --admin_user=admin --admin_password="$admin_pwd" --admin_email="admin@$domain"

	echo -e "\nDONE\n"

	echo "# WordPress admin account information:"
	echo "  - Admin URL: http://$domain/wp-admin/"
	echo "  - Username:  admin"
	echo "  - Password:  $admin_pwd"
}

# Output a message and die.
die() {
	echo "ERROR: $*" >&2
	exit 1
}

# Output the welcome message.
welcome() {
	echo -e "Welcome to eLightUp VPS management script v0.0.1.\n"
}

# Output a horizontal line with 80 characters width.
outputLine() {
	echo "--------------------------------------------------------------------------------"
}

# Check if the current user is a super user.
checkRoot() {
	if [ `id -u` -ne 0 ]; then
		die "You should have superuser privileges to continue. Try to run the script again with sudo."
	fi
}

main

#!/bin/bash

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
2. Add a WordPress site"
	outputLine
	echo ""

	read -p "Enter a choice [1-2]: " choice
	echo ""

	case $choice in
		1)
			install
			backToMenu
			;;
		2)
			read -p "Enter a domain name: " domain
			createVhost $domain
			createDb $domain
			backToMenu
			;;
		*)
			echo "Invalid choice"
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
	apt-get install -qqy php-fpm php-mysql php-mysqli php-imap php-json php-gd php-curl php-mbstring php-xml php-zip mailutils unzip git

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

	echo "  - Enabling Apache modules"
	# -q: Quiet mode.
	a2enmod -q rewrite expires headers proxy_fcgi setenvif
	a2enconf -q php7.4-fpm

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
		DocumentRoot /var/www/$domain
		LogLevel error
		<Directory /var/www/$domain>
			Options FollowSymLinks
			AllowOverride All
		</Directory>
	</VirtualHost>" > "/etc/apache2/sites-available/$domain.conf"

	echo "  - Enabling the site"
	# -q: Quiet mode.
	a2ensite -q $domain > /dev/null

	echo "  - Creating site directory"
	mkdir -p "/var/www/$domain"

	echo "  - Restarting Apache"
	service apache2 restart
}

createDb() {
	echo -e "\n# Creating database"

	# read -p "  - Enter MySQL root password (optional): " root_pwd
	# root_pwd=""

	db_name=${domain/./_}
	db_pwd=$(echo $RANDOM | base64)

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
	echo -e "\nInstalling WordPress"
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
#!/bin/bash

###############################################################################
# The database backup script
#
# - Automatic backup all databases in format $database-$Y-$m-$d.sql.gz
# - Send backups to Dropbox
#
# Uses: https://github.com/andreafabrizi/Dropbox-Uploader
# Link: https://deluxeblogtips.com/vps-backup-wordpress/
###############################################################################

# The main function
main() {
	local server=servername
	local folder=./backup
	local today=$(date +%F)
	local user=root
	local dump="mysqldump --skip-extended-insert --force"
	local file
	local database

	echo "# Backup databases";

	# Get list of all databases
	local databases=$(echo "SHOW databases" | mysql -u $user)

	for database in $databases; do

		# Skip if this is the default built-in MySQL database
		if [ "$database" = "Database" ] || [ "$database" = "information_schema" ] || [ "$database" = "mysql" ] || [ "$database" = "performance_schema" ] || [ "$database" = "sys" ]
		then
			continue
		fi

		# Backup
		echo "  - Backing up the database $database";
		file="$folder/$database-$today.sql.gz"
		$dump -u $user $database | gzip -9 > $file

		# Upload to Dropbox
		echo "  - Uploading the database $database to Dropbox";
		upload $file $server-$database.sql.gz

	done

	echo ""

	echo "# Cleaning up the backup folder"
	cleanup $folder
}

# Upload a file to Dropbox
#
# @param $1 File to upload
# @param $2 File to store on Dropbox
upload() {
	./dropbox_uploader.sh upload $1 $2
}

# Cleanup the backup folder, remove backups older than 30 days
cleanup() {
	find "$1"/* -mtime +30 -exec rm {} \;
}

# Call the main function
main

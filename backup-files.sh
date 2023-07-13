#!/bin/bash

###############################################################################
# The files backup script
#
# - Automatic backup all files in a folder in format $folder-$Y-$m-$d.gz
# - Send backups to a remote server
#
# Note: remember to change the domain and the remote server
###############################################################################

# The main function
main() {
	local domain=metabox.io
	local folder=./backup-files
	local today=$(date +%F)
	local file="$folder/metabox.io-$today.tar.gz"
	local server="evolution"

	echo "# Backup files";

	echo "  - Backing up files";

	# -z: gzip
	# -c: create the archive file
	# -f: output is a file
	# -C /: set root path "/" to ignore "Removing leading '/' from member names"
	# --warning=no-file-changed: ingore the warning of "files changed as we read it"
	tar -zcf $file -C /var/www --warning=no-file-changed $domain

	echo "  - Uploading the backup file to the remote server"

	rsync -e "ssh -o StrictHostKeyChecking=no" $file "$server:/root/$domain-backup/"

	echo "# Cleaning up the backup folder"
	cleanup $folder
}

# Cleanup the backup folder, remove backups older than 30 days
cleanup() {
	find "$1"/* -mtime +30 -exec rm {} \;
}

# Call the main function
main

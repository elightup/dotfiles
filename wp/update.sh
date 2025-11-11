#!/bin/bash

# Go to the site directory
# cd ~/sites/
# cd $1

# Update: WordPress, plugins, themes & languages
echo ''
echo 'Updating WordPress, plugins, themes, languages...'
wp core update
wp plugin update --all
wp theme update --all
wp language core update
wp language plugin update --all
wp language theme update --all

# Cleanup
# - Remove auto-draft, trash & revision posts
# - Remove spam, trash & pings comments
echo ''
echo 'Cleaning up posts, comments...'
wp post delete $(wp post list --post_status=auto-draft --format=ids) --force
wp post delete $(wp post list --post_status=trash --format=ids) --force
wp post delete $(wp post list --post_type=revision --format=ids) --force

wp comment delete $(wp comment list --status=spam --format=ids) --force
wp comment delete $(wp comment list --status=trash --format=ids) --force
wp comment delete $(wp comment list --type=pings --format=ids) --force

# Optimize DB
echo ''
echo 'Optimizing database...'
wp db optimize

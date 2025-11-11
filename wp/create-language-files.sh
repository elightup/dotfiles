#!/bin/bash

# Create POT file
wp i18n make-pot . "languages/$1.pot"

# Create JSON files for all languages
wp i18n make-json languages --no-purge

# Loop through all .po files in the languages directory and generate corresponding PHP files.
for po_file in languages/*.po; do
    # Check if the glob didn't match any files and skip if so
    [ -e "$po_file" ] || continue

    # Generate PHP translation file for each .po file
    wp i18n make-php "$po_file"
done

# Remove .mo files as they are not needed
rm languages/*.mo
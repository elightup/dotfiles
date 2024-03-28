<?php
// Environment type.
define( 'WP_ENVIRONMENT_TYPE', 'production' );

// Disable debug mode.
define( 'WP_DEBUG', false );

// No crons. Set up crons via Cloudflare Workers.
define( 'DISABLE_WP_CRON', true );

// Disable theme/plugin edit/update/install.
define( 'DISALLOW_FILE_EDIT', true );
define( 'DISALLOW_FILE_MODS', true );

// No revisions.
define( 'WP_POST_REVISIONS', false );

// No trash.
define( 'EMPTY_TRASH_DAYS', 0 );

// Block external requests.
// define( 'WP_HTTP_BLOCK_EXTERNAL', true );
// define( 'WP_ACCESSIBLE_HOSTS', 'api.wordpress.org' );

// Disable updates.
define( 'AUTOMATIC_UPDATER_DISABLED', true );
define( 'WP_AUTO_UPDATE_CORE', false );

<?php
// Environment type.
define( 'WP_ENVIRONMENT_TYPE', 'local' );

define( 'WP_DISABLE_FATAL_ERROR_HANDLER', true );

// Enable debug mode.
define( 'WP_DEBUG', true );

// Always log errors.
define( 'WP_DEBUG_LOG', true );

// Show errors.
@ini_set( 'display_errors', 1 );
define( 'WP_DEBUG_DISPLAY', true );

// Debug scripts.
define( 'SCRIPT_DEBUG', true );
define( 'CONCATENATE_SCRIPTS', false );

// Save queries for analysis.
define( 'SAVEQUERIES', true );

// No crons.
define( 'DISABLE_WP_CRON', true );

// No index.
define( 'DISALLOW_INDEXING', true );

// Reactivate WordPress Reset plugin.
define( 'REACTIVATE_WP_RESET', true );
<?php
add_filter( 'login_message', function( $message ) {
	$login = '<p>Use the account below to access the demo</p>';
	$login .= '<p>Username: demo</p>';
	$login .= '<p>Password: demo</p>';

	$login = wp_get_admin_notice( $login, ['type' => 'info', 'paragraph_wrap' => false] );

	return $message . $login;
} );

<?php
function d( ...$args ) {
	echo '<pre>';
	foreach ( $args as $arg ) {
		print_r( $arg );
	}
	echo '</pre>';
}

function dd( ...$args ) {
	d( ...$args );
	die;
}

function v( ...$args ) {
	echo '<pre>';
	foreach ( $args as $arg ) {
		var_dump( $arg );
	}
	echo '</pre>';
}

function vd( ...$args ) {
	v( ...$args );
	die;
}

function l( ...$args ) {
	foreach ( $args as $arg ) {
		error_log( print_r( $arg, true ) );
	}
}

function vl( ...$args ) {
	ob_start();
	foreach ( $args as $arg ) {
		var_dump( $arg );
	}
	error_log( ob_get_clean() );
}

function lqm( $args ) {
	do_action( 'qm/debug', $args );
}

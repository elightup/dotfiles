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
	array_walk( $args, 'var_dump' );
	error_log( ob_get_clean() );
}

function lqm( ...$args ) {
	foreach ( $args as $arg ) {
		do_action( 'qm/debug', $arg );
	}
}

function once( callable $callback ) {
	static $run = false;
	if ( ! $run ) {
		call_user_func( $callback );
		$run = true;
	}
}

function show_hook_callbacks( string $hook_name, ?int $priority = 10 ): void {
	global $wp_filter;
	if ( $priority === null ) {
		d( $wp_filter[ $hook_name ] );
	} else {
		d( $wp_filter[ $hook_name ][ $priority ] );
	}
}
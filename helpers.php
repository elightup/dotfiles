<?php
function d(...$args) {
	echo '<pre>';
	foreach ( $args as $arg ) {
		print_r( $arg );
	}
	echo '</pre>';
}

function dd(...$args) {
	d( ...$args );
	die;
}

function v(...$args) {
	echo '<pre>';
	foreach ( $args as $arg ) {
		var_dump( $arg );
	}
	echo '</pre>';
}

function vd(...$args) {
	v( ...$args );
	die;
}

function l(...$args) {
	foreach ( $args as $arg ) {
		error_log( print_r( $arg, true ) );
	}
}

function vl(...$args) {
	ob_start();
	foreach ( $args as $arg ) {
		var_dump( $arg );
	}
	error_log( ob_get_clean() );
}


function my_acf_google_map_api( $api ){
    $api['key'] = 'AIzaSyBk7S0vI8PcICRD2wFVGCMUSWfkAIu2KaM';
    return $api;
}
add_filter('acf/fields/google_map/api', 'my_acf_google_map_api');
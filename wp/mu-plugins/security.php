<?php
// Show general error for login.
add_filter( 'login_errors', function () {
	return __( 'There is something wrong. Please try again.', 'elightup' );
} );

// Restrict file uploads.
add_filter( 'upload_mimes', function () {
	return [ 
		'jpg|jpeg' => 'image/jpeg',
		'gif'      => 'image/gif',
		'png'      => 'image/png',
		'svg'      => 'image/svg+xml',
		'mp4'      => 'video/mp4',
		'pdf'      => 'application/pdf',
		'docx'     => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
		'xlsx'     => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		'pptx'     => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
	];
} );

add_action( 'template_redirect', function () {
	$scripts = [ 
		'https://hoalac-school.fpt.edu.vn/',
		'https://static.cloudflareinsights.com/',
		'https://googleads.g.doubleclick.net',
		'https://ssl.google-analytics.com',
		'https://www.googletagmanager.com',
		'http://unpkg.com',
		'http://cdnjs.cloudflare.com',
		'https://images.dmca.com',
		'https://analytics.tiktok.com',
		'https://connect.facebook.net',
		'https://widget.subiz.net',
		'https://storage.googleapis.com',
		'https://app.sbz.workers.dev',
		'https://subiza1b9.com',
		'https://vcdn.subiz-cdn.com',
		'https://www.google-analytics.com/',
		'https://www.googleadservices.com',
	];
	$style   = [ 
		'https://cdnjs.cloudflare.com ',
		'https://unpkg.com ',
		'https://fonts.googleapis.com',
	];
	$fonts   = [ 
		'https://cdnjs.cloudflare.com/ ',
		'https://fonts.gstatic.com ',
	];
	$img     = [ 
		'https://i.ytimg.com/ ',
		'https://thpt.fpt.edu.vn/',
		'https://secure.gravatar.com/',
		'https://vcdn.subiz-cdn.com ',
		'https://www.googletagmanager.com ',
		'https://www.google.com.vn ',
		'https://www.google.com ',
		'https://ssl.google-analytics.com ',
		'http://1.gravatar.com ',
		'https://i0.wp.com ',
		'https://hanoi.fpt.edu.vn ',
		'https://www.facebook.com',
		'https://public-gcs.subiz-cdn.com',
		'https://googleads.g.doubleclick.net',
		'https://demo1.elightup.com',
	];
	$connect = [ 
		'https://analytics.tiktok.com',
		'https://api.sbz.vn ',
		'https://www.google-analytics.com ',
		'https://analytics.google.com',
	];
	$frame   = [ 
		'https://td.doubleclick.net',
		'https://web.facebook.com/',
		'https://www.facebook.com/',
	];

	header(
		"Content-Security-Policy: default-src 'self'; " .
		"script-src 'self' 'unsafe-inline' " . implode( ' ', $scripts ) . " data:; " .
		"style-src 'self' 'unsafe-inline' " . implode( ' ', $style ) . "; " .
		"font-src 'self' " . implode( ' ', $fonts ) . " data:; " .
		"img-src 'self' " . implode( ' ', $img ) . " data:; " .
		"connect-src 'self' " . implode( ' ', $connect ) . "; " .
		"frame-src 'self' " . implode( ' ', $frame ) . ";"

	);
	// Other security headers
	header( "Strict-Transport-Security: max-age=63072000; includeSubDomains; preload" );
	header( "Referrer-Policy: no-referrer-when-downgrade" );
	header( "Permissions-Policy: feature-name=(self)" );
	// header( "X-Frame-Options: SAMEORIGIN" );
	// header( "X-Content-Type-Options: nosniff" );

	// CORS: Be careful with this header, ensure it fits your requirements.
	header( "Access-Control-Allow-Origin: https://hoalac-school.fpt.edu.vn" );
} );

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
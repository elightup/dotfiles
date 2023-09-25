<?php
add_action( 'template_redirect', function () {
	if ( ! current_user_can( 'manage_options' ) ) {
		wp_die( '<h1>Website đang nâng cấp</h1><br>Vui lòng quay trở lại sau 2h nữa. Chúng tôi xin lỗi vì sự bất tiện này!');
	}
} );

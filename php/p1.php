<?php
/**
 * @package P1
 * @version 1.0
 */
/*
Plugin Name: P1
Plugin URI: http://
Description: 
Author: ksi
Version: 1.0
Author URI: 
*/

add_action('admin_menu', 'mymenu');
function mymenu() {
    add_menu_page('Mymenu', 'mymenu Settings', 'administrator', __FILE__, 
        'mymenu_settings_page',plugins_url('/images/icon.png', __FILE__));

	//add_action( 'admin_init', 'register_mysettings' );
}

function mymenu_settings_page() {
?>
<div class="wrap">
<h2>my Plugin </h2>

<?php
$args = array(
	'numberposts' => 5,
	'orderby'     => 'date',
	'post_type'   => 'page',
	'suppress_filters' => true
);

$posts = get_posts( $args );

$i = 1;
print("<ul>");
foreach($posts as $post){ setup_postdata($post);
    print("<li> $i) </li>");
$i++;
}
print("</ul>");

wp_reset_postdata(); // сброс


?>

</div>
<?php }


function a($t) {
}

//add_action( 'admin_notices', '' );
//add_action( 'admin_head', '' );
add_action( 'the_title', 'a' );

?>

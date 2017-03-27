<?php
/**
 * @package P1
 * @version 1.0
 */
/*
Plugin Name: Prosto Plugin
Plugin URI: http://
Description: Просто плагин
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
	
$args = array(
	'numberposts' => 0,
	'orderby'     => 'id',
	'order'       => 'ASC',
	'meta_key'    => 'counter_data',
	'post_type'   => 'page',
	'suppress_filters' => true,
);
print_r($_POST);echo '<br>';
$posts = get_posts( $args );
$i = 1;
foreach($posts as $post){ 
	setup_postdata($post);
	echo $i.') ID['.$post->ID.']  ';
    print($post->post_title);
	echo "&nbsp";
	//print($post->post_date);
	$i++;
	print_r(get_post_meta( $post->ID, 'counter_data' ));
	//delete_post_meta($post->ID, 'counter_data');
	print('<br>');
}

wp_reset_postdata(); // сброс

//echo '<form action="'.$_SERVER['PHP_SELF'].'" method="post"><input type="submit" value="Удалить всю"/></form>';
}

function a($t) {
	global $post;
	$id = $post->ID;
	$counter = get_post_meta($id, 'counter_data', true);
	
	if (empty($counter)) {
		add_post_meta($id, 'counter_data', 1);
	} else {
		$counter = $counter + 1;
		update_post_meta($id, 'counter_data', $counter);
	}

	return $t;
}

add_action( 'wp_head', 'a' );

?>

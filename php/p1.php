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
?>
<style>
table {
    border: solid #88B;
}
</style>
<?php
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
//print_r($_POST);echo '<br>';
$posts = get_posts( $args );
$i = 1;
echo '<table border=1 cellspacing=0>';
$head = array('ID','Заголовок страницы','Количество просмотров','Пользователь', 'Дата');
echo '<thead>';
foreach ($head as $title) {
    echo '<th>';
    echo $title;
    echo '</th>';
}
echo '</thead>';
echo '<tbody>';
//echo '<thead><th>ID</th><th>Заголовок страницы</th><th>Количество просмотров</th><th>Пользователь</th><thead><tbody>';
foreach($posts as $post){ 
	//delete_post_meta($post->ID, 'counter_data');
	setup_postdata($post);
    echo '<tr>';
    echo '<td>';
    echo $post->ID;
    echo '</td>';
	//echo $i.') ID['.$post->ID.']  ';
    echo '<td>';
    print($post->post_title);
    echo '</td>';
	//print($post->post_date);
	$i++;
	echo "&nbsp";
    $counter = get_post_meta( $post->ID, 'counter_data', true); 
    $count = $counter['count'];
    $user_id = $counter['userid'];
    $user = get_user_by('id', $user_id);
    echo '<td>';
    echo $count;
    echo '</td>';
    echo '<td>';
    //echo $user->data->user_login;
    echo $user->data->display_name;
    echo '</td>';
    echo '<td>';
    echo $post->post_date;
    echo '</td>';
    echo '</tr>';
}
echo '</tbody></table>';

wp_reset_postdata(); // сброс

//echo '<form action="'.$_SERVER['PHP_SELF'].'" method="post"><input type="submit" value="Удалить всю"/></form>';
}

function count_view($t) {
    if ( !is_user_logged_in() ) return $t;
	global $post;
	$id = $post->ID;
	$counter = get_post_meta($id, 'counter_data', true);
    $user_id = get_current_user_id();
	
	if (empty($counter)) {
		add_post_meta($id, 'counter_data', array($user_id => 1));
    } else {
        if (empty($counter[$user_id])) {
            $counter[$user_id] = 1;
        } else {
            $counter[$user_id]++;
        }
		update_post_meta($id, 'counter_data', $counter);
	}

	return $t;
}

add_action( 'wp_head', 'count_view' );

?>

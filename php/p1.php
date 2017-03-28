<?php
/**
 * @package pcu
 * @version 1.0
 */
/*
Plugin Name: Page view count
Plugin URI: 
Description: Подсчёт количества просмотров пользователями
Author: R
Version: 1.1
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
    add_menu_page('Mymenu', 'Статистика просмотров', 'administrator', __FILE__, 
        'mymenu_page',plugins_url('/images/icon.png', __FILE__));
}

function mymenu_page() {
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
foreach($posts as $post){ 
	//delete_post_meta($post->ID, 'counter_data');
	setup_postdata($post);
    $counter = get_post_meta( $post->ID, 'counter_data', true); 
    foreach ($counter as $user_id => $count) {
        $user = get_user_by('id', $user_id);
        echo '<tr>';
        echo '<td>';
        echo $post->ID;
        echo '</td>';
        echo '<td>';
        echo '<a href="';
        echo get_permalink( $post->ID );
        echo '">';
        print($post->post_title);
        echo '</a>';
        echo '</td>';
        echo "&nbsp";
        echo '<td>';
        echo $count;
        echo '</td>';
        echo '<td>';
        echo $user->data->display_name;
        echo '</td>';
        echo '<td>';
        echo $post->post_date;
        echo '</td>';
        echo '</tr>';
    }
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

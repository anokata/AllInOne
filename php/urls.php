<?php
require_once('db.php');
require_once('forms.php');
require_once('settings.php');
// TODO: categorys. login+cookie. uploader. date, edit
// move to cat
// debug hided block
make_head("URLS", 'style.css');
//print("<i>before connect<br>");
$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
//print("after connect<br>");
//print_r($connection->errorInfo()); if error

$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;
$catg = isset($_POST['category']) ? $_POST['category'] : NULL;
$urls = db_select($connection, array('*'), 'urls');
$categories = db_select($connection, array('name'), 'categories');
$thispage = $_SERVER['PHP_SELF'];

print("<div id='categoryForm'>");
print("<form action='$thispage' method='post'>");
echo 'Категория:';
echo '<select name="category">';
echo '<option>';
echo 'No';
echo '</option>';
foreach ($categories as $cat) {
    if ($catg == trim($cat['name']))
        echo '<option selected>';
    else 
        echo '<option>';
    echo $cat['name'];
    echo '</option>';
}
echo '</select>';
print("<input type='submit' name='submit' value='view' />");
print('</form></div>');

make_form('addForm', 'urls_add.php',  array('Name: ' => 'name', 'UrL: ' => 'url'), 'Добавить', 0);

make_table($urls, array('DELETE', 'id', 'name', 'url'), 'url');

$connection = null;
?>
</body>
</html>

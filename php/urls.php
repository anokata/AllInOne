<?php
require_once('db.php');
require_once('forms.php');
require_once('settings.php');
make_head("URLS", 'style.css');
//print("<i>before connect<br>");
$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
//print("after connect<br>");
//var_dump($connection);
//print_r($connection->errorInfo());

$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;
$rows = db_select($connection, array('*'), 'urls');


function make_form($formname, $action, $inputs) {
    print("<div id='$formname'>");
    print("<form action='$action' method='post'>");
    foreach ($inputs as $title => $name) {
        print("$title: <input type='text' name='$name' />");
    }
    print("<input type='submit' name='submit' value='OK' />");
    print('</form></div>');
}

make_form('addForm', 'urls_add.php', array('Name' => 'name', 'URL' => 'url'));

make_table($rows, array('id', 'name', 'url'));

$connection = null;
?>
</body>
</html>

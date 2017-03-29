<?php
require_once('db.php');
require_once('forms.php');
require_once('settings.php');
make_head("URLS", 'style.css');
$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$urls = db_select($connection, array('*'), 'urls');



$connection = null;
?>
</body>
</html>

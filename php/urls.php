<?php
require('db.php');
require('forms.php');
make_head("URLS", 'style.css');

$connection = db_connect('pgsql', 'localhost', 'urls', 'test', 'test');
$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;
$rows = db_select($connection, array('*'), 'urls');

make_table($rows, array('id', 'name', 'url'));

$connection = null;
?>
</body>
</html>

<?php
require('db.php');
require('forms.php');
require('settings.php');
make_head("URLS", 'style.css');
print("<i>before connect<br>");
$connection = db_connect('mysql', 'sql202.eu.ai', 'euai_19877563_urls', 'euai_19877563', $db_password);
print("after connect<br>");
$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;
$rows = db_select($connection, array('*'), 'urls');

make_table($rows, array('id', 'name', 'url'));

$connection = null;
?>
</body>
</html>

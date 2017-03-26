<?php
require_once('db.php');
require_once('settings.php');
$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$url = isset($_POST['url']) ? $_POST['url'] : NULL;

$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
print_r($_POST);
$db_urltable = 'urls';
db_insert($connection, $db_urltable, array('name' => $name, 'url' => $url));
print("ok insert");
$connection = null;

require('urls.php');

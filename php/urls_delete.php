<?php
require_once('db.php');
require_once('settings.php');
$id = isset($_POST['id']) ? $_POST['id'] : NULL;
//if not id

$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
print_r($_POST);
$db_urltable = 'urls';
db_delete_by_id($connection, $db_urltable, $id);
print("ok delete id:$id");
$connection = null;

require('urls.php');

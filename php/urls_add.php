<?php
require('db.php');
require('settings.php');
$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
print_r($_POST);
$db_urltable = 'urls';
db_insert($connection, $db_urltable, array('name' => 'R', 'url' => 'L'));
print("ok insert");
$connection = null;

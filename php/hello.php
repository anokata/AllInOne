<?php
print("hello cruel world :( Hi $argv[1]\n");
//phpinfo();
$pdo = new PDO('mysql:host=localhost;dbname=mor', 'test', 'test');
var_dump($pdo);
$sth = $pdo->query('SELECT * FROM territory');

foreach ($sth as $row) {
        print $row['id'] . "\t";
        print $row['name'] . "\n";
    }

$sth = null;
$pdo = null;
?>

<html>
<body>
<?php
//print("hello cruel world :( Hi $argv[1]\n");
//phpinfo();
/*
$pdo = new PDO('mysql:host=localhost;dbname=mor', 'test', 'test');
var_dump($pdo);
print(serialize($argv));
$sth = $pdo->query('SELECT * FROM territory');

foreach ($sth as $row) {
        ?> <div> <?php
        print $row['id'] . " ";
        print $row['name'] . "";
        ?> </div> <?php
    }

$sth = null;
$pdo = null;
 */
function a() {
    echo 'some fun a';
}
function b(&$fun) {
    $fun();
}
b(&$a);
?>
</body>
</html>

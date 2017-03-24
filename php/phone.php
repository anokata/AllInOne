<html>
 <head>
<title>Phone book</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<?php
// TODO view peop, search by num, add, del.
$connection = new PDO('mysql:host=localhost;dbname=phonebook', 'test', 'test');
if (!$connection) {
    exit(1);
}

$query = $connection->query(
    'select name, phone from people inner join phones where people.id = phones.people_id');
$rows = $query->fetchAll();
?>

<div id="search">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    Phone:  <input type="text" name="phone" />
    <input type="submit" name="submit" value="Search" />
</form>
<span id="result" >
<?php
$founded = false;
foreach ($rows as $row) {
    //print("'".$_POST['phone']."' ?=? ".'"'.$row['phone'].'"'."\n");
    if ($row['phone'] === $_POST['phone']) {
        print('Found: '. $row['name'] . ' with phone ' . $row['phone'] );
    }
}
?>
</span>
</div>

<table> <thead>
<tr><th>Name</th><th>Phone</th></tr>
</thead>
<?php

foreach ($rows as $row) {
    if ($row['phone'] === $_POST['phone']) {
        ?> <tr id="found"><td> <?php
    } elseif  (strpos($row['phone'], $_POST['phone']) !== false) {
        ?> <tr id="fuzzy"><td> <?php
    } else {
        ?> <tr><td> <?php
    }
        print $row['name'];
?></td><td><?php
        print $row['phone'];
?> </td></tr> <?php
    }

$query = null;
$connection = null;
?>
</table>
<?php print('phone search: ' . $_POST['phone']); ?>


</body>
</html>

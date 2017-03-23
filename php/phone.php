<html>
 <head>
<title>Phone book</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<table>
<thead>
<tr><th>Name</th><th>Phone</th></tr>
</thead>
<?php
// TODO view peop, search by num, add, del.
$connection = new PDO('mysql:host=localhost;dbname=phonebook', 'test', 'test');
if (!$connection) {
    exit(1);
}

$query = $connection->query(
    'select name, phone from people inner join phones where people.id = phones.people_id');

foreach ($query as $row) {
        ?> <tr><td> <?php
        print $row['name'];
        ?></td><td><?php
        print $row['phone'];
        ?> </td></tr> <?php
    }

$query = null;
$connection = null;
?>
</table>

</body>
</html>

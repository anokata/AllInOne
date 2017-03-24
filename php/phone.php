<html>
 <head>
<title>Phone book</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<?php
// TODO view peop, search by num, add, del.
require('db.php');

$connection = connect();
$rows = get_phonebook($connection);
require('search_form.php');
require('table_phones.php');
?>

<?php
$query = null;
$connection = null;
?>

</body>
</html>

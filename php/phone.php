<html>
 <head>
<title>Phone book</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<?php
// TODO ajax/ peoples crud, avatar
require('db.php');
require('post.php');
require('forms.php');
require('table_phones.php');

$connection = connect();
$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$phone = isset($_POST['phone']) ? $_POST['phone'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;

handle_post_method($connection, $method, $name, $phone);

$rows = get_phonebook($connection);
make_search_form($rows, $phone);
make_add_form();
make_table($connection, $rows, $phone);
$connection = null;
?>

</body>
</html>

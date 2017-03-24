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

function handle_post_method() {
// TODO secure!
// TODO not add if exists!
    if ($_POST['method'] === 'add') {
        $name = $_POST['name'];
        $phone = $_POST['phone'];
        $id = get_name_id($connection, $name);
        if ($phone && $id) {
            insert_name_phone($connection, $id, $phone);
        } elseif ($phone && !$id) {
            insert_name($connection, $name);
            $id = get_name_id($connection, $name);
            insert_name_phone($connection, $id, $phone);
        } elseif ($name && !$id) {
            insert_name($connection, $name);
            // TODO tell user success added
        }
    }
}

handle_post_method();

$rows = get_phonebook($connection);
require('search_form.php');
require('add_form.php');
require('table_phones.php');
?>

<?php
$query = null;
$connection = null;
?>

</body>
</html>

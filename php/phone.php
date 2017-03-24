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

function make_delete_form($connection, $name, $phone) {
?>
<div class="deleteForm">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    <input type="submit" name="submit" value="delete" />
    <input type="hidden" name="name" value="<?php echo $name; ?>" />
    <input type="hidden" name="phone" value="<?php echo $phone; ?>" />
    <input type="hidden" name="method" value="delete" />
    <input type="hidden" name="id" value="" />
</form></div>
<?php
}

function handle_post_method($connection) {
// TODO secure!
// TODO not add if exists!
    $name = $_POST['name'];
    $phone = $_POST['phone'];

    if ($_POST['method'] === 'add') {
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
    if ($_POST['method'] === 'delete') {
        //print("del $name $phone");
        print(get_namephone_id($connection, $name, $phone));
        delete_namephone_byid($connection, get_namephone_id($connection, $name, $phone));
    }
}

handle_post_method($connection);

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

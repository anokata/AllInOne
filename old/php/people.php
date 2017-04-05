<?php
require('forms.php');
make_head("People", 'style.css');
require('db.php');

$connection = connect();
$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;

//handle_post_method($connection, $method, $name, $phone);

make_table(db_select_people($connection), array('id', 'name'));

$connection = null;
?>

</body>
</html>

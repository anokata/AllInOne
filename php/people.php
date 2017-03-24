<html>
 <head>
<title>Phone book</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<?php
require('db.php');
//require('post.php');
//require('forms.php');

$connection = connect();
$name = isset($_POST['name']) ? $_POST['name'] : NULL;
$method = isset($_POST['method']) ? $_POST['method'] : NULL;

//handle_post_method($connection, $method, $name, $phone);

function make_table($rows, $fields) 
{
    echo '<table><thead><tr>';
    foreach ($fields as $head_name) {
        echo "<th>$head_name</th>";
    }
    echo '</tr><thead>';
    
    echo '<tbody>';
    foreach ($rows as $row) {
        echo '<tr>';
        foreach ($fields as $head_name) {
            echo '<td>'. $row{$head_name} .'</td>';
        }
        echo '</tr>';
    }
    echo '</tbody>';
}

make_table(db_select_people($connection), array('id', 'name'));

$connection = null;
?>

</body>
</html>

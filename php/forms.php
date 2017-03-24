<?php

function make_head($title, $style) {
    echo "<html><head><title>$title</title>";
    echo '<link rel="stylesheet" type="text/css" href="'. $style .'">';
    echo '</head><body>';
}

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

function make_add_form() {
?>
<div id="addForm">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    Name:  <input type="text" name="name" />
    Phone:  <input type="text" name="phone" />
    <input type="hidden" name="method" value="add" />
    <input type="submit" name="submit" value="Add" />
</form>
</div>
<?php
}
?>

<?php
function make_search_form($rows, $phone) {
?>
<div id="search">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    Phone:  <input type="text" name="phone" />
    <input type="submit" name="submit" value="Search" />
    <input type="hidden" name="method" value="find" />
</form>
<span id="result" >
<?php
foreach ($rows as $row) {
    //print("'".$_POST['phone']."' ?=? ".'"'.$row['phone'].'"'."\n");
    if ($row['phone'] === $phone) {
        print('Founded: '. $row['name'] . ' with phone ' . $row['phone'] );
    }
}
?>
</span>
</div>
<?php
}   
?>

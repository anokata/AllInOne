<?php

function make_form($formname, $action, $inputs, $title='ok', $hidden=false) {
    print("<div id='$formname'>");
    print("<form action='$action' method='post'>");
    if ($inputs)
    foreach ($inputs as $title => $name) {
        print("$title: <input type='text' name='$name' />");
    }
    if ($hidden)
    foreach ($hidden as $name => $val) {
        print("<input type='hidden' name='$name' value='$val' />");
    }
    print("<input type='submit' name='submit' value='$title' />");
    print('</form></div>');
}

function make_head($title, $style) {
    echo "<html><head><title>$title</title>";
    echo '<link rel="stylesheet" type="text/css" href="'. $style .'">';
    echo '</head><body>';
}

function make_table($rows, $fields, $link_fiedl_name='') 
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
            echo '<td>';
            if ($head_name == 'DELETE') {
                make_form('delForm', 'urls_delete.php', false, 'delete', array('id' => $row['id']));
            } else {
                if (strcmp($link_fiedl_name, $head_name) === 0) {
                    echo '<a href="' . $row[$head_name] . '">';
                    echo $row[$head_name];
                    echo '</a>';
                } else {
                    echo $row{$head_name};
                }
            }
            echo '</td>';
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

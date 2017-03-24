<?php

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

function make_table($connection, $rows, $phone) {
?>
<table> <thead>
<tr><th>Name</th><th>Phone</th><th>Actions</th></tr>
</thead>
<?php
$phone = isset($_POST['phone']) ? $_POST['phone'] : NULL;
foreach ($rows as $row) {
    if ($row['phone'] === $phone) {
        ?> <tr id="found"><td> <?php
    } elseif  ($phone && strpos($row['phone'], $phone) !== false) {
        ?> <tr id="fuzzy"><td> <?php
    } else {
        ?> <tr><td> <?php
    }
        print $row['name'];
?></td><td><?php
        print $row['phone'];
?></td><td><?php
        make_delete_form($connection, $row['name'], $row['phone']);
?> </td></tr> <?php
    }
?>
</table>
<?php
}
?>

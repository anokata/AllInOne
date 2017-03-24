<table> <thead>
<tr><th>Name</th><th>Phone</th><th>Actions</th></tr>
</thead>
<?php
$phone = $_POST['phone'];
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

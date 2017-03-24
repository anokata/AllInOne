<table> <thead>
<tr><th>Name</th><th>Phone</th></tr>
</thead>
<?php
$phone = $_POST['phone'];
foreach ($rows as $row) {
    if ($row['phone'] === $_POST['phone']) {
        ?> <tr id="found"><td> <?php
    } elseif  ($phone && strpos($row['phone'], $_POST['phone']) !== false) {
        ?> <tr id="fuzzy"><td> <?php
    } else {
        ?> <tr><td> <?php
    }
        print $row['name'];
?></td><td><?php
        print $row['phone'];
?> </td></tr> <?php
    }
?>
</table>

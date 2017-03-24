<div id="search">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    Phone:  <input type="text" name="phone" />
    <input type="submit" name="submit" value="Search" />
</form>
<span id="result" >
<?php
$founded = false;
foreach ($rows as $row) {
    //print("'".$_POST['phone']."' ?=? ".'"'.$row['phone'].'"'."\n");
    if ($row['phone'] === $_POST['phone']) {
        print('Founded: '. $row['name'] . ' with phone ' . $row['phone'] );
    }
}
?>
</span>
</div>


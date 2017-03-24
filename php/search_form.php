<div id="search">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    Phone:  <input type="text" name="phone" />
    <input type="submit" name="submit" value="Search" />
    <input type="hidden" name="method" value="find" />
</form>
<span id="result" >
<?php
$founded = false;
$phone = $_POST['phone'];
foreach ($rows as $row) {
    //print("'".$_POST['phone']."' ?=? ".'"'.$row['phone'].'"'."\n");
    if ($row['phone'] === $phone) {
        print('Founded: '. $row['name'] . ' with phone ' . $row['phone'] );
    }
}
?>
</span>
</div>


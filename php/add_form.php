<div id="addForm">
<form action="<?php print($_SERVER['PHP_SELF']);?>" method="post">
    Name:  <input type="text" name="name" />
    Phone:  <input type="text" name="phone" />
    <input type="hidden" name="method" value="add" />
    <input type="submit" name="submit" value="Add" />
</form>
</div>


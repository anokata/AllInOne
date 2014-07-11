<html><head><title>NoTitle</title></head>
<body>
    <form actoin="n2post.php" method = "POST">
    Please enter youre Name : <input type = "text" name="name1" /> <br />
    <input type = "submit" value = "Ok" />
    </form>

<?php
$thename = $_POST['name1'];

var_dump ($thename);
var_dump ($_POST); 
?>
</body>
</html>

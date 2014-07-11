<html><head><title>NoTitle</title></head>
<body>
    <form actoin="n2.php" method = "GET">
    Please enter youre Name : <input type = "text" name="name1" /> <br />
    <input type = "submit" value = "Ok" />
    </form>

<?php

$thename = $_GET['name1'];

var_dump ($thename);
var_dump ($_GET); 
var_dump($_SERVER['DOCUMENT_ROOT']);
//var_dump($_SERVER);
print "<br />".getcwd();
//chdir("")

if ($handle = opendir('.')) { 
  while (false !== ($file = readdir($handle)))   {
    //if ($file != "." && $file != "..")
   // {
      echo "$file" . "<br/>";
    //}
  }
  closedir($handle);
}

?>
</body>
</html>

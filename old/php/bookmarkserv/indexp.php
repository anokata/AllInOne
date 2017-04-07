<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
	</head>
	<body>
		<?php 
		
		function printArray($a) {
			for ($i = 0; $i<count($a); $i++)
                echo $a[$i], "<br/>";
		};
		function printArrayList($a) {
            echo "<ul>";
			for ($i = 0; $i<count($a); $i++)
                echo "<li>", $a[$i], "</li>";
            echo "</ul>";
            echo "<br/>";
		};		
		/*print(pathinfo("./"));
		print("S");
		$C = 0;
		print "$C";
		$a = [1,2,3];
		echo "{$a[1]}";
		$dir = scandir (".");
		var_dump(scandir ("."));
		echo "<br/>";
		for ($i = 0; $i<count($dir); $i++)
            echo $dir[$i], "<br/>";
        echo "<br/>";*/
		// strore list in file:
		// one page-query.php for get / one ajax for add
		$fileName =  "storage.dat";
		$data = file($fileName);
		printArrayList($data);
		
		$what=$_REQUEST["what"];
		
		 ?>
	</body>
</html>

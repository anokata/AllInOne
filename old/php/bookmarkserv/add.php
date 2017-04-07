
		<?php 
        // add.php?what=some_new
        echo "{\"newElem\":\"";
		$what=$_REQUEST["what"];
		echo  $what;
		$fileName =  "storage.dat";
		$what= $what . "\n";
		//echo "=$what=";
		$n = file_put_contents($fileName,$what,FILE_APPEND);
		//echo $n, " chars saved. \"}"
		echo " \"}"
		
		 ?>


		<?php 
		$n=$_REQUEST["what"];
		$fileName =  "storage.dat";
		$data = file($fileName);
		//var_dump(count($data));
		//var_dump(count($data[$n]));
		unset($data[$n]);
		//var_dump(count($data));
		file_put_contents($fileName,$data);
		echo "{}";
		
		 ?>

<?php

//print 5*5;
//echo "hellow";
//$i=4^7; 
//var_dump($i);
//define("consta",1);
//var_dump(consta);
//class 

//
//define("DEF_PRICE",0.0);
class Product 
{
  protected $price;
  //protected $discountedPrice;
  protected $name;
  function __construct( $name, $price) {
  $this->price = $price;
  $this->discountedPrice = $price;
  $this->name = $name;
  }
  function discount(float $dprice){
	  $this->discountedPrice = $dprice;
  }
}

$p1 = new Product('water', 3.03);
$pA = new Product('body', 1308);

//discount on product set
//discount on product count
interface AbsDiscount {
	function discountCalc();
}
class DiscountOnProductSet implements AbsDiscount {
	protected $discountValue;
	protected $productSet;
	
	function __construct( $set,  $val){
		$this->productSet = $set;
		$this->discountValue = $val;
	}
	function discountCalc(){
		foreach ($p as $productSet) 
			$p->discount($p->price * $this->discountValue);
	}
}

class DiscountOnProductCount implements AbsDiscount {
	protected $discountValue; // мультипликатор скидки
	protected $productSet; // список продуктов на которые распространяется скидка
	protected $targetCount;
	
	function __construct( $set,  $count,  $val){
		$this->productSet = $set;
		$this->discountValue = $val;
		$this->targetCount = $count;
	}
	function discountCalc(){
		//if 
		foreach ($p as $productSet) 
			$p->discount($p->price * $this->discountValue);
	}
}

class Order {
	protected $products; //список продуктов
	function __construct(){
		
	}
	function add(Product $p){
		array_push($this->products,$p);
	}
}


$a = array(1,$p1,3);
var_dump($a);
/*$p1->discount(80);
var_dump($a);
*/
define('N',PHP_EOL);
echo 'some', N, 'other', N, 'str';

?>

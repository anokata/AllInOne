<html>
<body>
<?php
//print("hello cruel world :( Hi $argv[1]\n");
//phpinfo();
/*
$pdo = new PDO('mysql:host=localhost;dbname=mor', 'test', 'test');
var_dump($pdo);
print(serialize($argv));
$sth = $pdo->query('SELECT * FROM territory');

foreach ($sth as $row) {
        ?> <div> <?php
        print $row['id'] . " ";
        print $row['name'] . "";
        ?> </div> <?php
    }

$sth = null;
$pdo = null;
 */
class HtmlElement {
    private $html;
    private $end;
    public function HtmlElement($tag) {
        $this->html = "<$tag>";
        $this->end = "</$tag>";
    }
    public function compile() {
        return $this->html . $this->end;
    }
    public function add($content) {
        $this->html .= $content;
    }
    public function add_html($content) {
        $this->html .= $content->compile();
    }
}

$h = new HtmlElement('div');
$d = new HtmlElement('DIV');
$h->add_html($d);
echo $h->compile();

?>
</body>
</html>

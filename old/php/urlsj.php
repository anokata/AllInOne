<?php
require_once('db.php');
require_once('forms.php');
require_once('settings.php');
make_head("URLS", 'style.css');
$connection = db_connect($dbdriver, $dbhost, $dbname, $dbuser, $db_password);
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$urls = db_select($connection, array('*'), 'urls');

class HtmlElement {
    private $html;
    private $end;
    public function __construct($tag='div') {
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
    // attr
}
// зачем генерить если можно сверстать. шаблоны

$main = new HtmlElement();
$div = new HtmlElement('DIV');
$main->add_html($div);
echo $main->compile();

$connection = null;
?>
</body>
</html>

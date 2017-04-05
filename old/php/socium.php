<?php

# :let file=expand('%:t:r')
# :vnew
# :for i in [1, 2, 3] 
# :normal ggdG
# :execute "silent r! make " . g:file . " && sleep"
# :endfor


class World {
    private $map = array();
    private $w;
    private $h = 3;
    public function __construct($initElement) {
        $this->map = array(array());
        $this->w = 10;
        $this->h = 20;
        for ($x = 0; $x < $this->w; $x++) {
            for ($y = 0; $y < $this->h; $y++) {
                $this->map[$x][$y] = $initElement;
            }
        }
    }
    public function view() {
        $str = '';
        for ($x = 0; $x < $this->w; $x++) {
            for ($y = 0; $y < $this->h; $y++) {
                $str .= $this->map[$x][$y]->view();
            }
            $str .= "\n";
        }
        return $str;
    }
    public function add($obj, $x, $y) {
        $this->map[$x][$y] = $obj;
    }
}

class Element {
    private $char;
    public function __construct($char) {
        $this->char = $char;
    }
    public function view() {
        return $this->char;
    }
}

$Void = new Element('.');
$mud = new Element('~');
$w = new World($Void);
$w->add($mud, 2, 5);


echo $w->view();


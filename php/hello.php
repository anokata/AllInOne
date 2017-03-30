<?php
function utf8_strrev($str){
    preg_match_all('/./us', $str, $ar);
    return join('',array_reverse($ar[0]));
}

function is_palindrome($str) {
    $str = preg_replace('/\s+/', '', $str);
    $str = mb_strtolower($str);
    if (mb_strlen($str) < 2) return false;
    return $str === utf8_strrev($str);
}

function all_sub_palindromes($str) {
    $length = mb_strlen($str);
    for ($max_len = $length - 1; $max_len > 1; $max_len--) {
        for ($start = 0; $start + $max_len <= $length; $start++) {
            if (is_palindrome(mb_substr($str, $start, $max_len))) {
                return mb_substr($str, $start, $max_len);
            }
        }
    }
    return false;
}

function palindrome($str) {
    if (is_palindrome($str)) {
        echo $str;
    } else {
        $sub = all_sub_palindromes($str);
        if ($sub) {
            echo $sub;
        } else {
            echo mb_substr($str, 0, 1);;
        }
    }
}


palindrome("Sum summus mus"); echo "o<BR>\n";
palindrome("Аргентина манит негра"); echo "o<BR>\n";
palindrome("sumusyzzsuslarararal"); echo "o<BR>\n";
palindrome("yzzsus"); echo "o<BR>\n";
palindrome("zzzsusx"); echo "o<BR>\n";
palindrome("susax"); echo "o<BR>\n";
palindrome("xsusax"); echo "o<BR>\n";
palindrome("xxsusax"); echo "o<BR>\n";
palindrome("A:xsz xusax"); echo "-<BR>\n";

palindrome("some  emos");echo "o<BR>\n";
palindrome("some other_emos");echo "-<BR>\n";
palindrome("");echo "-<BR>\n";
palindrome("x");echo "-<BR>\n";
palindrome("xx");echo "o<BR>\n";
palindrome("aaa");echo "o<BR>\n";
palindrome("zx");echo "-<BR>\n";
palindrome("Zxz");echo "o<BR>\n";
palindrome("axz");echo "-<BR>\n";
$a = 1;
echo "{${"a"}}";
if (array(1) < array(2)) { echo 'a';};
$a += ++$a;
echo $a;
$ar[] = "abc";
echo $ar;
$ar = (array) $a;
echo $ar[0];
$b = array(&$a => 1);
?>

<?php
function is_palindrome($str) {
    $str = strtolower($str);
    return $str === strrev($str);
}

function all_sub_palindromes($str) {
    $length = strlen($str);
    for ($max_len = $length - 1; $max_len > 0; $max_len--) {
        for ($start = 0; $start + $max_len <= $length; $start++) {
            if (is_palindrome(substr($str, $start, $max_len))) {
                return substr($str, $start, $max_len);
            }
        }
    }
    return false;
}

function palindrome($str) {
    if (is_palindrome($str)) {
        echo $str;
        echo "\n";
    } else {
        $sub = all_sub_palindromes($str);
        if ($sub) {
            echo $sub;
            echo " <sub\n";
        } else {
            echo $str[0];
            echo "\n";
        }
    }
}
palindrome("Sum summus mus");
palindrome("sumusyzzsuslarararalaa");
palindrome("sumusyzzsuslarararal");
palindrome("yzzsus");
palindrome("zzzsusx");
palindrome("susax");
palindrome("xsusax");
palindrome("xxsusax");
/*
palindrome("some other emos");
palindrome("");
palindrome("x");
palindrome("xx");
palindrome("aaa");
palindrome("zx");
palindrome("Zxz");
palindrome("axz");
 */
?>

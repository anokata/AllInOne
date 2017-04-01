<?php

function view_commit($name, $data) {
    $template = 'templates/' . $name . '.php';
    require($template);
}

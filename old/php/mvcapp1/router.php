<?php

$routes = explode('/', $_SERVER['REQUEST_URI']);
if (count($routes) === 4) {
    $name = $routes[count($routes)-2];
    $action = $routes[count($routes)-1];
} else {
    $name = $routes[count($routes)-1];
    $action = 'commit';
}   

$view = 'views/' . $name . '.php';
$model = 'models/' . $name . '.php';
$controller = 'controllers/' . $name . '.php';

require($model);
require($view);
require($controller);
$controller_fun = 'controller_' . $action;
$controller_fun($name);

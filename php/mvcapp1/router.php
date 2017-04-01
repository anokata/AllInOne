<?php

$routes = explode('/', $_SERVER['REQUEST_URI']);

$view = 'views/' . $routes[count($routes)-1] . '.php';
$model = 'models/' . $routes[count($routes)-1] . '.php';
$controller = 'controllers/' . $routes[count($routes)-1] . '.php';

require($model);
require($view);
require($controller);
controller_commit();

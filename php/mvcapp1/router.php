<?php

$routes = explode('/', $_SERVER['REQUEST_URI']);

$view = 'views/' . $routes[count($routes)-1] . '.php';

require($view);

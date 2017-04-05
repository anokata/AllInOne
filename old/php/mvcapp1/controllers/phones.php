<?php

function controller_commit($name) {
    $data = model_commit();
    view_commit($name, $data);
}

function controller_Add($name) {
    $data = null;
    view_commit($name . 'Add', $data);
}

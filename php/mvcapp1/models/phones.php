<?php
function model_commit() {
    require_once('db.php');
    $connection = connect();
    $data = get_phonebook($connection);
    $connection = null;
    return $data;
}

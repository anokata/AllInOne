<?php
function connect() {
    $connection = new PDO('mysql:host=localhost;dbname=phonebook', 'test', 'test');
    if (!$connection) {
        exit(1);
    }
    return $connection;
}

function get_phonebook($connection) {
    $query = $connection->query(
        'select name, phone from people inner join phones where people.id = phones.people_id');
    return $query->fetchAll();
}

?>

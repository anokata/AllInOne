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

function get_name_id($connection, $name) {
    $query = $connection->prepare(
        'select id from people where name = ?');
    $query->bindParam(1, $name);
    $query->execute();
    $row = $query->fetch();
    return $row['id'];
}

function insert_name_phone($connection, $people_id, $phone) {
    $query = $connection->prepare(
        'INSERT INTO phones (id, phone, people_id) VALUES ("null", ?, ?)');
    $query->bindParam(1, $phone);
    $query->bindParam(2, $people_id);
    $query->execute();
}

function insert_name($connection, $name) {
    $query = $connection->prepare(
        'INSERT INTO people (id, name) VALUES ("null", ?)');
    $query->bindParam(1, $name);
    $query->execute();
}

?>

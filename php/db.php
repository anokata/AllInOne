<?php

function db_connect($sdb, $host, $dbname, $user, $pass) {
    $connection = new PDO("$sdb:host=$host;dbname=$dbname", $user, $pass);
    if (!$connection) {
        exit(1);
    }
    return $connection;
}

function db_select($conn, $fields, $table) {
    $qry = 'select ';
    foreach ($fields as $field) {
        $qry .= $field;
    }
    $qry .= " from $table";
    $query = $conn->query($qry);
    return $query->fetchAll();
}

function db_insert($connection, $table, $fields) {
    $q = "INSERT INTO $table ";
    $field = '(';
    $vals = ' VALUES (';
    $i = 1;
    $l = count($fields);
    foreach ($fields as $name => $val) {
        if (is_string($name)) {
            //$field .= "'". $name ."'";
            $field .= $name; 
        } else {
            $field .= $name; 
        }
        if ($i < $l) {
            $field .= ', '; 
            $vals .= '?, ';
        }
        $i++;
    }
    $vals .= '?';
    $field .= ')';
    $vals .= ')';
    $q .= $field . $vals;
    $i = 1;
    //print($q);
    $query = $connection->prepare($q);
    foreach ($fields as $name => &$val) {
        $query->bindParam($i, $val);
        $i++;
    }
    $r = $query->execute();
}


function db_delete_by_id($connection, $table, $id) {
    $query = $connection->prepare(
        "delete from $table where id = ?");
    $query->bindParam(1, $id);
    $query->execute();
}

function connect() {
    $connection = new PDO('mysql:host=localhost;dbname=phonebook', 'test', 'test');
    if (!$connection) {
        exit(1);
    }
    return $connection;
}

function db_select_people($connection) {
    $query = $connection->query(
        'select id, name from people');
    return $query->fetchAll();
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

function get_namephone_id($connection, $name, $phone) {
    $id = get_name_id($connection, $name);
    if ($id) {
        $query = $connection->prepare(
            'select id from phones where people_id = ? and phone = ?');
        $query->bindParam(1, $id);
        $query->bindParam(2, $phone);
        $query->execute();
        $row = $query->fetch();
        return $row['id'];
    }
    return false;
}

function insert_name_phone($connection, $people_id, $phone) {
    $query = $connection->prepare(
        'INSERT INTO phones (id, phone, people_id) VALUES (null, ?, ?)');
    $query->bindParam(1, $phone);
    $query->bindParam(2, $people_id);
    $query->execute();
}

function insert_name($connection, $name) {
    $query = $connection->prepare(
        'INSERT INTO people (id, name) VALUES (null, ?)');
    $query->bindParam(1, $name);
    $query->execute();
}

function delete_namephone_byid($connection, $id) {
    $query = $connection->prepare(
        'delete from phones where id = ?');
    $query->bindParam(1, $id);
    $query->execute();
}

?>

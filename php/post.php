<?php
function handle_post_method($connection, $method, $name, $phone) {
// TODO secure!
// TODO not add if exists!
    if (!$method) return;

    if ($method === 'add') {
        $id = get_name_id($connection, $name);
        if ($phone && $id) {
            insert_name_phone($connection, $id, $phone);
        } elseif ($phone && !$id) {
            insert_name($connection, $name);
            $id = get_name_id($connection, $name);
            insert_name_phone($connection, $id, $phone);
        } elseif ($name && !$id) {
            insert_name($connection, $name);
            // TODO tell user success added
        }
        return;
    }
    if ($method === 'delete') {
        delete_namephone_byid($connection, get_namephone_id($connection, $name, $phone));
        return;
    }
}
?>

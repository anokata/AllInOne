<?php

function controller_commit() {
    $data = model_commit();
    view_commit($data);
}

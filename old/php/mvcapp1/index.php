<!DOCTYPE html>
<html>
<head>
<style>
header {
    background-color: #fee;
}
footer {
    background-color: #eef;
    position: relative;
}
article {
    background-color: #efe;
    position: relative;
    margin: auto;
    height: 90%;
}
</style>
</head>
<body>
<?php ini_set('display_errors', 1); ?>
<?php require('templates/header.php'); ?>
<?php require('router.php'); ?>
<?php require('templates/footer.php'); ?>
</body>
</html>

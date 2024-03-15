<?php
    session_start();

    const DB_SERVER   = 'localhost:3306';
    const DB_USERNAME = 'root';
    const DB_PASSWORD = '';
    const DB_DATABASE = 'PISID';

    $db = mysqli_connect(DB_SERVER, DB_USERNAME,
        DB_PASSWORD, DB_DATABASE);

    if(mysqli_connect_errno()) {
        exit('Failed to connect with MySQL: ' . mysqli_connect_error());
    }
?>
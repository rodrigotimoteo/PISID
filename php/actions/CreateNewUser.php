<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $sqli = new mysqli(DB_SERVER, 'root', '', DB_DATABASE);

    if($sqli->connect_error) { die("Connection failed: " . $sqli->connect_error); }

    $procedure = "CALL CreateNewUSer(?, ?, ?, ?)";

    $stmt = $sqli->prepare($procedure);
    $stmt->bind_param("ssss",$email, $password, $name, $phone);

    $email = $_POST['email'];
    $password = $_POST['password'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];

    if($stmt->execute()) {
        echo "New user created successfully";
    } else {
        echo "Error: " . $procedure . "<br>" . $sqli->error;
    }

    $stmt->close();
    $sqli->close();
}
?>
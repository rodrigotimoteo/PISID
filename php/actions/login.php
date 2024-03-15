<?php
include("../config.php");

if ( isset($_POST['login'])) {
    $sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

    if($sqli->connect_error) { die("Connection failed: " . $sqli->connect_error); }

    $stmt = $sqli->prepare("SELECT nome, password FROM utilizador WHERE email = ?");
    $stmt->bind_param("s", $email);

    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt->execute();
    $stmt->store_result();

    if($stmt->num_rows > 0) {
        $stmt->bind_result($name, $password_db);
        $stmt->fetch();

        if(($password === $password_db)) {
            $_SESSION['loggedin'] = true;
            $_SESSION['email'] = $email;
            $_SESSION['name'] = $name;

            header("Location: ../testList.php");
            exit;
        } else {
            echo "Wrong Password";
        }
    }
    else {
        echo "Wrong Email";
    }

    $stmt->close();
    $sqli->close();
}

?>
<?php
include("../config.php");

$database = "mysql";

if (isset($_POST['login'])) {
    $username = $_POST['email'];

    if(isset($_POST['password']))
        $password = $_POST['password'];
    else
        $password = "";

    $conn = new mysqli(DB_SERVER, $username, $password, $database);

    if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $sql_command = "SELECT * FROM user WHERE User = ?";
    $stmt = $conn->prepare($sql_command);
    $stmt->bind_param("s", $email);

    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        if(isset($row['password'])) {
            if(!password_verify($password, $row['password'])) { // Success with password
                echo "Wrong Credentials";

                $stmt->close();
                $conn->close();
                exit();
            }
        }
        // Success no password

        $conn = new mysqli(DB_SERVER, $username, $password, DB_DATABASE);

        if($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        $stmt = $conn->prepare("SELECT nome FROM utilizador WHERE email = ?");
        $stmt->bind_param("s", $email);

        $stmt->execute();
        $stmt->store_result();

        if($stmt->num_rows > 0) {
            $stmt->bind_result($name);
            $stmt->fetch();

            $_SESSION['loggedin'] = true;
            $_SESSION['email'] = $email;
            $_SESSION['name'] = $name;
            $_SESSION['password'] = $password;
            header("Location: ../testList.php");
            exit;
        }
    }

    $stmt->close();
    $conn->close();
}

<?php

include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    if(isset($_SESSION['email'])) {

        $email = $_SESSION['email'];

        $sqli = new mysqli(DB_SERVER, $email, $_SESSION['password'], DB_DATABASE);

        if ($sqli->connect_error) {
            die("Connection failed: " . $sqli->connect_error);
        }

        if(isset($_POST['name']) && isset($_POST['phone'])) {

            $name = $_POST['name'];
            $phone = $_POST['phone'];

            $procedure = "CALL EditUser(?,?,?)";
            $stmt = $sqli->prepare($procedure);
            $stmt->bind_param("sss", $email, $name , $phone);

            $result = $stmt->get_result();

            if (!$stmt->execute()) {
                echo "Error: " . $procedure . "<br>" . $sqli->error;
            }
            header("Location: ../profileChange.php");

            $stmt->close();
        }

        $sqli->close();

    }

}
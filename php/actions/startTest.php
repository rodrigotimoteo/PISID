<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    if(isset($_SESSION['email'])) {

        $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

        if ($sqli->connect_error) {
            die("Connection failed: " . $sqli->connect_error);
        }

        if(isset($_GET['start_id_exp'])) {

            $test_id = $_GET['start_id_exp'];

            $procedure = "CALL StartTest(?)";
            $stmt = $sqli->prepare($procedure);
            $stmt->bind_param("i", $test_id);

            if ($stmt->execute()) {
                header("Location: ../testList.php");
            } else {
                echo "Error: " . $procedure . "<br>" . $sqli->error;
            }

            $stmt->close();

        } else {
            echo "Test ID is not set.";
        }

        $sqli->close();
    }
}
<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    if(isset($_SESSION['email'])) {
        $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

        if ($sqli->connect_error) {
            die("Connection failed: " . $sqli->connect_error);
        }


        $procedure = "CALL FinishTest()";
        $stmt = $sqli->prepare($procedure);

        if ($stmt->execute()) {
            header("Location: ../testList.php");
        } else {
            echo "Error: " . $procedure . "<br>" . $sqli->error;
        }

        $stmt->close();
        $sqli->close();
    }
}
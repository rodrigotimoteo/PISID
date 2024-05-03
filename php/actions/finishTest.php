<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $sqli = new mysqli(DB_SERVER, $_SESSION['name'], $_SESSION['password'], DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    if(isset($_SESSION['email'])) {

        if(isset($_GET['test_id'])) {

            $test_id = $_GET['test_id'];

            $procedure = "CALL FinishTest(?)";
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

    }

    $sqli->close();

}
?>
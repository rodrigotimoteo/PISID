<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    if(isset($_SESSION['email'])) {

        if(isset($_GET['delete_id_exp'])) {

            $delete_id_exp = $_GET['delete_id_exp'];

            // Call the stored procedure to delete the test
            $procedure = "CALL DeleteTest(?)";
            $stmt = $sqli->prepare($procedure);
            $stmt->bind_param("i", $delete_id_exp); // Assuming delete_id_exp is an integer

            if ($stmt->execute()) {
                header("Location: ../testList.php");
            } else {
                echo "Error: " . $procedure . "<br>" . $sqli->error;
            }

            $stmt->close();

        } else {
            echo "Delete ID is not set.";
        }

    }

    $sqli->close();

}
?>
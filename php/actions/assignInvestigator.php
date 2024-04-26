<?php

include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    if(isset($_SESSION['email'])) {

        if(isset($_GET['assign_id_exp'])) {

            $assign_id_exp = $_GET['assign_id_exp'];
            $investigator_email = $_SESSION['email'];

            $procedure = "CALL AssignInvestigator(?,?)";
            $stmt = $sqli->prepare($procedure);
            $stmt->bind_param("is", $assign_id_exp,$investigator_email);

            if ($stmt->execute()) {
                header("Location: ../testList.php");
            } else {
                echo "Error: " . $procedure . "<br>" . $sqli->error;
            }

            $stmt->close();
        }

    }

}
?>
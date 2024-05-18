<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    if(isset($_SESSION['email'])) {

        $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

        if ($sqli->connect_error) {
            die("Connection failed: " . $sqli->connect_error);
        }

        if(isset($_GET['delete_subs_id'])) {

            $delete_id_subs = $_GET['delete_subs_id'];

            $procedure = "CALL DeleteExpSubstance(?)";
            $stmt = $sqli->prepare($procedure);
            $stmt->bind_param("i", $delete_id_subs);

            if ($stmt->execute()) {
                echo "<form id='redirectForm' action='../substanceList.php' method='post'>";
                echo "<input type='hidden' name='substance_list' value='" . htmlspecialchars($testId) . "'>";
                echo "</form>";
                echo "<script type='text/javascript'>document.getElementById('redirectForm').submit();</script>";
                exit();
            } else {
                echo "Error: " . $procedure . "<br>" . $sqli->error;
            }

            $stmt->close();

        } else {
            echo "Delete ID is not set.";
        }

        $sqli->close();
    }
}
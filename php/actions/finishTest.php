<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    if(isset($_SESSION['email'])) {

        if(isset($_POST['test_id'])) {

            $test_id = $_POST['test_id'];

            if(isset($_POST['delete_test'])) {
                // Code to delete the test
                // Implement your delete test logic here
                echo "Test deleted successfully.";
            } elseif(isset($_POST['edit_test'])) {
                // Code to edit the test
                // Implement your edit test logic here
                echo "Test edited successfully.";
            } elseif(isset($_POST['end_test'])) {
                // Call the stored procedure to end the experience
                $procedure = "CALL YourStoredProcedureName(?)";
                $stmt = $sqli->prepare($procedure);
                $stmt->bind_param("i", $test_id); // Assuming test_id is an integer

                if ($stmt->execute()) {
                    echo "Experience ended successfully.";
                } else {
                    echo "Error: " . $procedure . "<br>" . $sqli->error;
                }

                $stmt->close();
            }

        } else {
            echo "Test ID is not set.";
        }

    }

    $sqli->close();

}
?>
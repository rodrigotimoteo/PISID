<?php
include("../config.php");

$response = [
    'success' => false,
    'message' => ''
];

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

    if ($sqli->connect_error) {
        $response['message'] = "Connection failed: " . $sqli->connect_error;
    } else {

        if(isset($_SESSION['email'])) {

            if(isset($_POST['test_id'])) {

                $test_id = $_POST['test_id'];
                $test_description = $_POST['test_description'];
                $test_limit_per_room = $_POST['test_limit_per_room'];
                $test_number_of_rats = $_POST['test_number_of_rats'];
                $test_seconds_without_movement = $_POST['test_seconds_without_movement'];
                $test_ideal_temperature = $_POST['test_ideal_temperature'];
                $test_max_temp_deviation = $_POST['test_max_temp_deviation'];

                $procedure = "CALL EditTest(?,?,?,?,?,?,?,?)";
                $stmt = $sqli->prepare($procedure);
                $stmt->bind_param("ssiiiiid", $test_description, $test_limit_per_room, $test_number_of_rats, $test_seconds_without_movement, $test_ideal_temperature, $test_max_temp_deviation, $test_id);

                if ($stmt->execute()) {
                    $response['success'] = true;
                    $response['message'] = "Test updated successfully.";
                } else {
                    $response['message'] = "Error: " . $procedure . "<br>" . $sqli->error;
                }

                $stmt->close();

            } else {
                $response['message'] = "Test ID is not set.";
            }

        }

        $sqli->close();
    }
}

echo json_encode($response);
?>

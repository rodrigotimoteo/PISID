<?php
include("../config.php");

$response = [
    'success' => false,
    'message' => ''
];

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $sqli = new mysqli(DB_SERVER, $_SESSION['name'], $_SESSION['password'], DB_DATABASE);

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

                $procedure = "CALL EditTest(?,?,?,?,?,?,?)";
                $stmt = $sqli->prepare($procedure);
                $stmt->bind_param("siiiiii", $test_description, $test_number_of_rats, $test_limit_per_room, $test_id, $test_seconds_without_movement, $test_ideal_temperature, $test_max_temp_deviation);

                if ($stmt->execute()) {
                    header("Location: ../testList.php");
                } else {
                    echo "Error: " . $procedure . "<br>" . $sqli->error;
                }
                $stmt->close();

            } else {
                $response['message'] = "Test ID is not set.";
            }

        }

        $sqli->close();
    }
}

?>

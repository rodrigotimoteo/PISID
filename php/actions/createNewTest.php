<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

    if($sqli->connect_error) { die("Connection failed: " . $sqli->connect_error); }

    $procedure = "CALL InsertNewTest(?, ?, ?, ?, ?, ?, ?)";

    $stmt = $sqli->prepare($procedure);
    $stmt->bind_param("siiidds", $description, $numberOfRats, $limitPerRoom, $timeWithoutMovement,
        $idealTemperature, $maxTemperatureDeviation, $investigator);

    $description = $_POST['description'];
    $numberOfRats = $_POST['numberOfRats'];
    $limitPerRoom = $_POST['ratLimit'];
    $timeWithoutMovement = $_POST['timeWithoutMovement'];
    $idealTemperature = $_POST['idealTemperature'];
    $maxTemperatureDeviation = $_POST['maxTempVariation'];
    $investigator = $_SESSION['email'];

    if($stmt->execute()) {
        echo "New test created successfully";
    } else {
        echo "Error: " . $procedure . "<br>" . $sqli->error;
    }

    $stmt->close();
    $sqli->close();
}

?>

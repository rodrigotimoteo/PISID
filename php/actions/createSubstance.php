<?php
include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if(isset($_SESSION['email'])) {

        $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

        if($sqli->connect_error) { die("Connection failed: " . $sqli->connect_error); }

        $procedure = "CALL CreateExpSubstance(?, ?, ?)";

        $stmt = $sqli->prepare($procedure);
        $stmt->bind_param("isi", $testId, $subtance, $numberOfRats);

        $testId = $_POST['testId'];
        $subtance = $_POST['substance'];
        $numberOfRats = $_POST['numberOfRats'];

        if($stmt->execute()) {
            echo "<form id='redirectForm' action='../substanceList.php' method='post'>";
            echo "<input type='hidden' name='substance_list' value='" . htmlspecialchars($testId) . "'>";
            echo "</form>";
            echo "<script type='text/javascript'>document.getElementById('redirectForm').submit();</script>";
            exit();
        } else {
            echo "Error: " . $procedure . "<br>" . $sqli->error;
        }

        $stmt->close();
        $sqli->close();
    }
}
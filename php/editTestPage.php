<?php
session_start();
/*

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
} else {
    echo "Welcome " . $_SESSION['name'];
}
*/
?>


<?php
/*
if(isset($_GET['test_id'])) {
    $test_id = $_GET['test_id'];
} else {
    echo "Test ID is not set.";
    exit();

}
*/

include("../php/config.php");
$sqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

if ($sqli->connect_error) {
    die("Connection failed: " . $sqli->connect_error);
}

$stmt = $sqli->prepare("SELECT descricao, limite_ratos_sala, numero_ratos, segundos_sem_movimento, temperatura_ideal, variacao_temperatura FROM Experiencia WHERE id_experiencia = ?");
$stmt->bind_param("i", $test_id);
$stmt->execute();
$stmt->bind_result($descricao, $limite_ratos_sala, $numero_ratos, $segundos_sem_movimento, $temperatura_ideal, $variacao_temperatura);
$stmt->fetch();
$stmt->close();

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Test</title>

</head>
<body>
<h2>Edit Test</h2>

<form action="actions/editTest.php" method="post">
    <input type="hidden" name="test_id" value="<?php echo $test_id; ?>">

    <label for="test_description">Test Description:</label>
    <input type="text" id="test_description" name="test_description" value="<?php echo $descricao; ?>" required>

    <label for="test_limit_per_room">Limit per Room:</label>
    <input type="number" id="test_limit_per_room" name="test_limit_per_room" value="<?php echo $limite_ratos_sala; ?>" required>

    <label for="test_number_of_rats">Number of Rats:</label>
    <input type="number" id="test_number_of_rats" name="test_number_of_rats" value="<?php echo $numero_ratos; ?>" required>

    <label for="test_seconds_without_movement">Seconds without Movement:</label>
    <input type="number" id="test_seconds_without_movement" name="test_seconds_without_movement" value="<?php echo $segundos_sem_movimento; ?>" required>

    <label for="test_ideal_temperature">Ideal Temperature:</label>
    <input type="number" id="test_ideal_temperature" name="test_ideal_temperature" value="<?php echo $temperatura_ideal; ?>" required>

    <label for="test_max_temp_deviation">Max Temperature Deviation:</label>
    <input type="number" id="test_max_temp_deviation" name="test_max_temp_deviation" value="<?php echo $variacao_temperatura; ?>" required>

    <br>
    <input type="submit" value="Update Test">
</form>

<a href="landingPage.php">Go Back</a>
</body>
</html>

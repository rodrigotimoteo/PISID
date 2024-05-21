<?php

include("config.php");

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    $edit_id_exp = $_GET['edit_id_exp'];

    if (isset($_SESSION['email'])) {

        if (isset($_GET['edit_id_exp'])) {

            $stmt = $sqli->prepare("SELECT descricao, limite_ratos_sala, numero_ratos, segundos_sem_movimento, temperatura_ideal, variacao_temperatura_maxima FROM Experiencia WHERE id_experiencia = ?");
            $stmt->bind_param("i", $edit_id_exp);
            $stmt->execute();

            $stmt->bind_result($descricao, $limite_ratos_sala, $numero_ratos, $segundos_sem_movimento, $temperatura_ideal, $variacao_temperatura);

            $stmt->fetch();
            $stmt->close();
        }
    }
    $sqli->close();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Edit Test</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        label {
            color: #000000;
        }
    </style>
</head>

<body>
    <section class="container">
        <div class="menu">
            <a class="menu-item" href="landingPage.php">Home</a>
            <a class="menu-item" href="testList.php">Test List</a>
            <a class="menu-item" href="createTest.php">Create Test</a>
            <a class="menu-item" href="profileChange.php">Profile</a>
            <a class="menu-item" href="actions/logout.php">Logout</a>
        </div>

        <div class="form">
            <h2>Edit Test</h2><br>
            <form action="actions/editTest.php" method="post">
                <input type="hidden" name="test_id" value="<?php echo $edit_id_exp; ?>">
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
                <input type="submit" value="Update Test"><br>
                <a href="landingPage.php">Go Back</a>
            </form>
        </div>
    </section>

</body>

</html>

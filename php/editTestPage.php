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

    if(isset($_SESSION['email'])) {

        if(isset($_GET['edit_id_exp'])) {

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
        h2 {
            font-family: 'Open Sans', sans-serif;
            text-align: center;
            margin-top: 50px;
            font-size: 36px;
            color: #ffffff;
        }

        form {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffff;
            text-align: center;
            box-shadow: 0 0 20px #000;
            margin-top: 50px;
            border-radius: 15px;
        }

        label {
            display: block;
            color: #000000;
            font-size: 18px;
            margin-top: 20px;
        }

        input {
            margin-bottom: 20px;
            padding: 10px 5px;
            width: 100%;
            background-color: #f4f4f4;
            border: none;
            text-align: center;
            font-size: 16px;
            font-family: 'Open Sans', sans-serif;
            font-weight: bold;
            color: #333;
            border-radius: 3px;
        }

        input:focus {
            background-color: #ccc;
            border: none;
            outline: none;
        }

        input[type=submit] {
            color: #fff;
            background: #c32ce1;
            border: none;
            font-family: 'Open Sans', sans-serif;
            font-size: 24px;
            margin-top: 25px;
            width: 60%;
            transition: all .5s ease;
            cursor: pointer;
            display: block;
            margin: 0 auto;
            border-radius: 5px;
        }

        input[type=submit]:hover {
            background-color: #A64141;
            color: #f4f4f4;
        }

        a {
            text-decoration: none;
            color: lightgray;
            margin-top: 10px;
            display: inline-block;
            font-size: 18px;
            margin-top: 20px;
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

    <h2>Edit Test</h2>
    <div class="login">
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
            <input type="submit" value="Update Test">

            <a href="landingPage.php">Go Back</a>
        </form>
    </div>
</section>

</body>
</html>

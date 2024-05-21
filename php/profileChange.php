<?php

include("config.php");

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
}

$sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);
if($sqli->connect_error) {
    die("Connection failed: " . $sqli->connect_error); 
}

$query = "SELECT email, nome, telefone, tipo FROM utilizador WHERE email = ?";
$stmt = $sqli->prepare($query);

$stmt->bind_param("s", $_SESSION['email']);

$stmt->execute();

$stmt->bind_result($email, $nome, $telefone, $tipo);

if ($stmt->fetch()) {
    // Variables $email, $nome, $telefone, $tipo are now filled with values
} else {
    echo "0 results";
}

$stmt->close();
$sqli->close();
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>UserPagePISID</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        label {
            display: block;
            color: #ffff;
            font-size: 18px;
            opacity: 1;
            transition: all .3s ease-in-out;
        }

        .button-container {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #c32ce1;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1em;
            margin-right: 10px;
            transition: background-color 0.3s ease;
            font-family: 'Open Sans', sans-serif;
            cursor: pointer;
        }

        .button:hover {
            background-color: #0056b3;
        }

        a {
            text-decoration: none;
            color: lightgray;
        }
    </style>
</head>

<body>
<section class="container">
    <div class="menu">
        <a href="landingPage.php">Home</a>
        <a href="testList.php">Test List</a>
        <a href="createTest.php">Create Test</a>
        <a href="profileChange.php">Profile</a>
        <a href="actions/logout.php">Logout</a>
    </div>

    <div class="container">
        <div id="editUser" class="form">
            <h1>User Profile</h1>
            <br>
            <br>
            <p>Email: <?php echo htmlspecialchars($email); ?></p>
            <p>Name: <?php echo htmlspecialchars($nome); ?></p>
            <p>Telefone: <?php echo htmlspecialchars($telefone); ?></p>
            <p>Tipo: <?php echo htmlspecialchars($tipo); ?></p>
            <div class="button-container">
                <a href="editUserPage.php" class="button">Edit User Details</a>
            </div>
        </div>
    </div>
</section>
</body>

</html>

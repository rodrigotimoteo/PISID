<?php
session_start();

if (isset($_SESSION['loggedin']) && $_SESSION['loggedin'] === true) {
    header("Location: testList.php");
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Lab Rats - Landing Page</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        body {
            display: flex;
            align-items: center;
            height: 100vh;
            background: linear-gradient(90deg, rgba(58, 255, 246, 1) 5%, rgba(240, 16, 220, 1) 100%, rgba(38, 98, 247, 1) 100%);
        }

        .container {
            text-align: center;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
</head>

<body>


    <div class="container">
        <div>
            <h2><span style="color: #000000;">Lab</span> Rats</h2>
        </div>
        <br>
        <div class="menu">
            <a href="registerPage.php" class="button">Register</a>
            <a href="loginPage.php" class="button">Login</a>
        </div>
        <br>
    </div>

</html>

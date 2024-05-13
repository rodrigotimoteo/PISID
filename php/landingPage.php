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
            font-family: 'Arial', sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: rgb(58,255,246);
            background: linear-gradient(90deg, rgba(58,255,246,1) 5%, rgba(240,16,220,1) 100%, rgba(38,98,247,1) 100%);
        }

        h2 {
            font-size: 3em;
            margin-bottom: 10px;
            color: #000000;
        }

        p {
            font-size: 1.5em;
            margin-bottom: 20px;
            color: #f4f4f4;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #c32ce1;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1.2em;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #0056b3;
        }
        .container {
            text-align: center;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 500px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .menu {
            text-align: center;
            padding: 20px 0;
            display: flex;
            justify-content: space-around;
        }

        .menu a {
            text-decoration: none;
            color: #030101;
            margin: 0 10px;
            font-size: 18px;
        }

        .menu a:hover {
            text-decoration: underline;
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

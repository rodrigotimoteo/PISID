<?php
session_start();

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LoginPagePISID</title>
    <link rel="stylesheet" href="style.css" media="screen">
</head>
<style>
    .menu {
        text-align: center;
        padding: 20px 0;
        display: flex;
        justify-content: space-around;
    }

    .menu a {
        text-decoration: none;
        color: #fff;
        margin: 0 10px;
        font-size: 18px;
    }

    .menu a:hover {
        text-decoration: underline;
    }

    .login {
        background-color: #ffff;
        text-align: center;
        box-shadow: 0 0 20px #000;
        margin-top: 50px;
        padding: 30px;
        border-radius: 15px;
    }

    .login h1 {
        font-size: 36px;
        padding: 10px 0;
        color: #000;
    }

    label {
        display: block;
        color: #ffff;
        font-size: 18px;
        opacity: 1;
        transition: all .3s ease-in-out;
    }

    input {
        margin-bottom: 0px;
        padding: 10px 5px;
        width: 100%;
        background-color: #f4f4f4;
        border: none;
        text-align: center;
        font-size: 16px;
        font-family: 'Open Sans', sans-serif;
        font-weight: bold;
        color: #333;
        border-radius 3px;
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

    .message span {
        display: block;
        color: #cccc;
        position: relative;
        z-index: -1;
        bottom: 80px;
        text-align: center;
    }

    a {
        text-decoration: none;
        color: lightgray;
        margin-top: 10px;
    }
</style>

<body>
    <section class="container">
        <div class="menu">
            <a class="menu-item" href="landingPage.php">Home</a>
            <a class="menu-item" href="testList.php">Test List</a>
            <a class="menu-item" href="createTest.php">Create Test</a>
            <a class="menu-item" href="profileChange.php">Profile</a>
            <a class="menu-item" href="actions/logout.php">Logout</a>
        </div>

        <div id="createTest" class="login">
            <h1>Create Test</h1>
            <form action="actions/createNewTest.php" method="post">
                <label for="description">Description</label>
                <input class="input" type="text" id="description" name="description" placeholder="Description"><br>
                <label for="numberOfRats">Number of Rats</label>
                <input class="input" type="number" required id="numberOfRats" name="numberOfRats" placeholder="Number of Rats"><br>
                <label for="ratLimit">Rat Limit</label>
                <input class="input" type="number" required id="ratLimit" name="ratLimit" placeholder="Rat Limit per Room"><br>
                <label for="timeWithoutMovement">Time Without Movement</label>
                <input class="input" type="number" required id="timeWithoutMovement" name="timeWithoutMovement" placeholder="Time limit without Rat Movement"><br>
                <label for="idealTemperature">Ideal Temperature</label>
                <input class="input" type="number" required id="idealTemperature" name="idealTemperature" placeholder="Ideal Temperature"><br>
                <label for="maxTempVariation">Maximum Temperature Deviation</label>
                <input class="input" type="number" required id="maxTempVariation" name="maxTempVariation" placeholder="Maximum temperature deviation"><br><br>


                <input class="input" type="submit" value="Submit" name="Submit">
                <style>
                    input[type="text"], input[type="password"], input[type="tel"], input[type="number"], input[type="submit"] {
                        border-radius: 5px;
                    }
                </style>
            </form>
            <br>
            <a href="landingPage.php">Go Back</a>
        </div>
    </section>
</body>
</html>
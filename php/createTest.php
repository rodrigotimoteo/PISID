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

<!DOCTYPE html>
<html lang="en">
<head>
   <!-- <link rel="stylesheet" type="text/css" href="style.css"> -->
    <meta charset="UTF-8">
    <title>LoginPagePISID</title>
</head>
<style>
        @import url(https://fonts.googleapis.com/css?family=Rokkitt);
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
        @import url(https://fonts.googleapis.com/css?family=Roboto+Slab:700,400);
        @import url(https://fonts.googleapis.com/css?family=Lobster);

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        h1 {
            font-family: 'Open Sans', sans-serif;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Open Sans', sans-serif;
            background: linear-gradient(90deg, rgba(58,255,246,1) 5%, rgba(240,16,220,1) 100%, rgba(38,98,247,1) 100%);
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            width: 100%;
            height: 600px;
            padding: 20px;
            box-sizing: border-box;
        }

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
            height: 570px;
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
        .message {
            position: absolute;
            top: 500px;
            left: 460px;
            transform: rotate(-25deg);
            text-align: right;
            margin-left: 20px;
            margin-top: 20px;
        }

        .message span {
            display: block;
            color: #cccc;
            position: relative;
            z-index: -1;
            bottom: 80px;
            text-align: center;
        }

        .first, .second {
            font-size: 10em;
            letter-spacing: -4px;
            display: inline-block;
            font-family: 'Lobster', cursive;
            text-shadow: 3px 3px 0 #999;
        }

        .second {
            font-size: 8em;
            line-height: 150px;
        }
        a{
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
                    <input class="input" type="text" id="description" name="description" placeholder="Description">
                    <br>
                    <br>
                    <input class="input" type="number" required id="numberOfRats" name="numberOfRats" placeholder="Number of Rats">
                    <br>
                    <br>
                    <input class="input" type="number" required id="ratLimit" name="ratLimit" placeholder="Rat Limit per Room">
                    <br>
                    <br>
                    <input class="input" type="number" required id="timeWithoutMovement" name="timeWithoutMovement" placeholder="Time limit without Rat Movement">
                    <br>
                    <br>
                    <input class="input" type="number" required id="idealTemperature" name="idealTemperature" placeholder="Ideal Temperature">
                    <br>
                    <br>
                    <input class="input" type="number" required id="maxTempVariation" name="maxTempVariation" placeholder="Maximum temperature deviation">
                    <br>
                    <br>
                    <style>
                        input[type="text"], input[type="password"], input[type="tel"], input[type="number"], input[type="submit"] {
                            border-radius: 5px;
                        }
                    </style>
                    <input class="input" type="submit" value="Submit" name="Submit">
                    
                <a href="landingPage.php">Go Back</a>
            </form>
        </div>
    </section>
</body>
</html>
<html>
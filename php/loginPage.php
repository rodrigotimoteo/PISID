<?php
session_start();

if (isset($_SESSION['loggedin']) && $_SESSION['loggedin'] === true) {
    echo "User already logged in, redirecting to test list";
    header("Location: testList.php");
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>LoginPagePISID</title>
    <style>
        @import url('https://fonts.googleapis.com/css?family=Rokkitt|Open+Sans:400italic,400,700|Roboto+Slab:700,400|Lobster');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: url('https://unsplash.s3.amazonaws.com/batch%206/park-place.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            font-family: 'Open Sans', sans-serif;
        }

        .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 50px;
        }

        .login {
            flex: 1;
            background-color: #444444;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px #000;
        }

        .login h1 {
            color: #A64141;
            font-size: 36px;
            padding-bottom: 20px;
            border-bottom: 2px solid #d25555;
            margin-bottom: 20px;
        }

        .login a {
            display: block;
            margin-bottom: 10px;
            text-decoration: none;
            color: #ccc;
            font-size: 16px;
        }

        .message {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 10em;
            font-family: 'Lobster', cursive;
            text-shadow: 3px 3px 0 #999;
        }

        form {
            display: none;
            flex-direction: column;
            align-items: center;
        }

        label {
            color: #f4f4f4;
            font-size: 18px;
            margin-bottom: 10px;
        }

        input {
            margin-bottom: 20px;
            padding: 10px 15px;
            width: 300px;
            background-color: #ccc;
            border: none;
            text-align: center;
            font-size: 16px;
            font-family: 'Open Sans', sans-serif;
            color: #333;
            border-radius: 5px;
        }

        input[type=submit] {
            color: #fff;
            background-color: #d25555;
            border: none;
            font-family: 'Rokkitt', serif;
            font-size: 24px;
            width: 60%;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type=submit]:hover {
            background-color: #A64141;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="login">
        <h1>Greetings!</h1>
        <a href="../landingPage.php">Home</a>
        <a href="#" id="loginBtn">Login</a>
        <div id="loginPopup">
            <form action="actions/login.php" method="post">
                <label for="email">Email:</label>
                <input type="text" required="" id="email" name="email">
                <label for="password">Password:</label>
                <input type="password" required="" id="password" name="password">
                <a href="#">Forgot Username </a>&#x2022;<a href="#"> Forgot Password</a><br>
                <input type="submit" value="Login" name="login">
            </form>
        </div>
    </div>
    <div class="message">
        <span class="first">Lab</span>
        <span class="second">Rats</span>
    </div>
</div>
</body>

</html>

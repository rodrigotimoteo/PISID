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
        @import url(https://fonts.googleapis.com/css?family=Rokkitt);
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
        @import url(https://fonts.googleapis.com/css?family=Roboto+Slab:700,400);
        @import url(https://fonts.googleapis.com/css?family=Lobster);

        * {
            margin: 0;
            padding: 0;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
        }

        h1 {
            font-family: 'Open Sans', sans-serif;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Open Sans', sans-serif;
            background: rgb(58,255,246);
            background: linear-gradient(90deg, rgba(58,255,246,1) 5%, rgba(240,16,220,1) 100%, rgba(38,98,247,1) 100%);
        }

        .container {
            width: 30%; /* Smaller width */
            max-width: 400px; /* Adjust max-width as needed */
            margin: 0 auto;
            padding: 20px; /* Add some padding for better layout */
            box-sizing: border-box;
        }

        .menu {
            text-align: center;
            padding: 20px 0; /* Adjust vertical padding as needed */
        }

        .menu a {
            text-decoration: none;
            color: #fff;
            margin: 0 10px; /* Adjust horizontal margin as needed */
            font-size: 25px;
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
            height: 450px;
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
            margin-bottom: 15px;
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
            display: block; /* Make it a block element */
            margin: 0 auto; /* Center horizontally */
            border-radius: 5px;
        }

        input[type=submit]:hover {
            background-color: #A64141;
            color: #f4f4f4;
        }
        .message {
            position: absolute;
            top: 50px;
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
        a[href="#"] {
            text-decoration: none;
            color: lightgray;
        }
    </style>
</head>
<body>
<section class="container">
    <div class="menu">
        <a href="../landingPage.php">Home</a>
    </div>
    <div class="login">
        <h1>Login</h1>
        <form action="actions/login.php" method="post">
            <label id="emailLabel" for="email">Email:</label>
            <input type="text" required="" id="email" name="email" placeholder="Write your email">
            <label id="passwordLabel" for="password">Password:</label>
            <input type="password" required="" id="password" name="password" placeholder="Write your password">
            <div style="text-align:center;">
                <input type="submit" value="Login" name="login">
                <br>
                <a href="#">Forgot Password</a>
            </div>
        </form>
    </div>
</section>
</body>

</html>
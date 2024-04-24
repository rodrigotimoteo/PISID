<?php
session_start();

// Check if user is not logged in, then redirect to login page
/*
if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] !== true) {
    echo "Please log in to view this page.";
    header("Location: loginPage.php");
    exit;
}
*/
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>UserPagePISID</title>
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
            max-width: 800px;
            margin: 0 auto;
            width: 100%;
            height: 700px;
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
        <div id="editUser" class="login">
            <h1>User Profile</h1>
            <div class="button-container">
                <!-- Button to edit user details -->
                <a href="editUserPage.php" class="button">Edit User Details</a>
                <!-- Button to edit password -->
                <a href="changePassword.php" class="button">Change Password</a>
            </div>

        </div>
    </div>
</section>
</body>

</html>

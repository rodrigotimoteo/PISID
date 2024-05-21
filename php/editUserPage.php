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
            <h1>Edit User</h1>
            <form action="actions/editUserInformation.php" method="post">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required placeholder="Write your name">

                <label for="phone">Phone Number:</label>
                <input type="tel" id="phone" name="phone" required placeholder="Write your phone number">
                <style>
                    input[type="text"], input[type="password"], input[type="tel"] {
                        border-radius: 5px;
                    }
                </style><br><br>
                <input type="submit" value="Update"><br>
                <a href="profileChange.php"> Go Back</a>
            </form>
        </div>
    </div>
</section>
</body>
</html>

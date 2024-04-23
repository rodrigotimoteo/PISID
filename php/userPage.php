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
    }
    </style>
</head>
<body>
<section class="container">
    <div class="menu">
        <a href="../landingPage.php">Home</a>
        <a href="../testList.php">Test List</a>
        <a href="../createTest.php">Create Test</a>
        <a href="../userPage.php">Edit User</a>
        <a href="../actions/logout.php">Logout</a>
    </div>

    <div class="container">
        <div id="editUser" class="login">
            <h1>Edit User</h1>
            <form action="actions/editUserInformation.php" method="post">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required placeholder="Write your name">

                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required placeholder="Write your password">

                <label for="phone">Phone Number:</label>
                <input type="tel" id="phone" name="phone" required placeholder="Write your phone number">
                <style>
                    input[type="text"], input[type="password"], input[type="tel"] {
                        border-radius: 5px;
                    }
                </style>
                <br>
                <br>
                <input type="submit" value="Update">
                <br>
                <br>
                <a href="../landingPage.php"> Go Back</a>
            </form>
        </div>
    </div>
    <div class="message">
        <span class="first">Lab</span>
        <span class="second">Rats</span>
    </div>
</section>
</body>
</html>

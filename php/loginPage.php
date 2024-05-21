<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LoginPagePISID</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        .menu a {
            font-size: 25px;
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
            display: block;
            margin: 0 auto; 
            border-radius: 5px;
        }

        input[type=submit]:hover {
            background-color: #0056b3;
            color: #f4f4f4;
        }

        .message span {
            display: block;
            color: #cccc;
            position: relative;
            bottom: 80px;
            text-align: center;
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
        <a href="landingPage.php">Home</a>
    </div>
    <div class="form">
        <h1>Login</h1>
        <form action="actions/login.php" method="post">
            <label id="emailLabel" for="email">Email:</label>
            <input type="text" required="" id="email" name="email" placeholder="Write your email">
            <label id="passwordLabel" for="password">Password:</label>
            <input type="password" required="" id="password" name="password" placeholder="Write your password">
            <div style="text-align:center;">
                <br>
                <input type="submit" value="login" name="login"><br><br>
                <a href="#"> Forgot Password</a>
            </div>
        </form>
    </div>
</section>
</body>
</html>

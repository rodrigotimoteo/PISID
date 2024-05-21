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
                    <input type="submit" value="login" name="login"><br>
                    <a href="#"> Forgot Password</a>
                </div>
            </form>
        </div>
    </section>
</body>

</html>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>RegisterPagePISID</title>
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
            <h1>Register</h1>
            <form action="actions/createNewUser.php" method="post">
                <label id="nameLabel" for="name">Name:</label>
                <input type="text" required="" id="name" name="name" placeholder="Write your name">
                <label id="phoneLabel" for="phone">Phone Number:</label>
                <input type="tel" required="" id="phone" name="phone" placeholder="Write your phone number">
                <label id="emailLabel" for="email">Email:</label>
                <input type="text" required="" id="email" name="email" placeholder="Write your email">
                <label id="passwordLabel" for="password">Password:</label>
                <input type="password" required="" id="password" name="password" placeholder="Write your password">
                <br><br>
                <div style="text-align:center;">
                    <input type="submit" value="Register" name="register">
                </div>
            </form>
        </div>
    </section>

</body>

</html>

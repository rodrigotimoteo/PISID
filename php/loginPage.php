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
</head>
<body>
<header>
    <div>
        <h1>Lab Rats</h1>
        <nav>
            <ul>
                <li>
                    <a href="../landingPage.php">Home</a>
                </li>
                <li>
                    <a href="#" id="loginBtn">Login</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<div>
    <div id="loginPopup">
        <div id="loginForm">
            <form action="actions/login.php" method="post">
                <label for="email">Email:</label>
                <input type="text" required="" id="email" name="email">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password">
                <input type="submit" value="login" name="login">
            </form>
        </div>
    </div>
</div>

</body>
</html>

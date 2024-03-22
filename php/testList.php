<?php
session_start();

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
} else {
    echo "Welcome " . $_SESSION['name'];
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
                        <li><a href="landingPage.php">Home</a></li>
                        <li><a href="testList.php">Test List</a></li>
                        <li><a href="createTest.php">Create new Test</a></li>
                        <li><a href="userPage.php">Edit user</a></li>
                        <li><a href="actions/logout.php">Logout</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <div class="container">
            <h1>List Tests</h1>
        </div>

    </body>
</html>
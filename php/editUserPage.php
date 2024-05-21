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
                        input[type="text"],
                        input[type="password"],
                        input[type="tel"] {
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

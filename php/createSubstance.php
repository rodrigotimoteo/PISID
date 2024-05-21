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
    <title>Create Substance</title>
    <link rel="stylesheet" href="style.css" media="screen">
</head>

<body>
    <section class="container">
        <div class="menu">
            <a class="menu-item" href="landingPage.php">Home</a>
            <a class="menu-item" href="testList.php">Test List</a>
            <a class="menu-item" href="createTest.php">Create Test</a>
            <a class="menu-item" href="profileChange.php">Profile</a>
            <a class="menu-item" href="actions/logout.php">Logout</a>
        </div>

        <div id="createTest" class="form">
            <h1>Add substance</h1>
            <form action="actions/createSubstance.php" method="post">
                <label for="substance">Substance</label>
                <input class="input" type="text" id="substance" name="substance" placeholder="Substance"><br>
                <label for="numberOfRats">Number of Rats</label>
                <input class="input" type="number" required id="numberOfRats" name="numberOfRats" placeholder="Number of Rats"><br>
                <input type="hidden" id="testId" name="testId" value="<?php echo htmlspecialchars($_POST['id_exp']);  ?>">

                <br><br>
                <input class="input" type="submit" value="Submit" name="Submit">
                <style>
                    input[type="text"],
                    input[type="password"],
                    input[type="tel"],
                    input[type="number"],
                    input[type="submit"] {
                        border-radius: 5px;
                    }
                </style>
            </form>
            <br>
            <form action="substanceList.php" method="POST">
                <input type="hidden" name="substance_list" value="<?php echo htmlspecialchars($_POST['id_exp']); ?>">
                <button type="submit">Go back</button>
            </form>
        </div>
    </section>
</body>

</html>

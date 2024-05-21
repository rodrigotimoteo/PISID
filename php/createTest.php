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
    <title>Create Test</title>
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
            <h1>Create Test</h1>
            <form action="actions/createNewTest.php" method="post">
                <label for="description">Description</label>
                <input class="input" type="text" id="description" name="description" placeholder="Description"><br>
                <label for="numberOfRats">Number of Rats</label>
                <input class="input" type="number" required id="numberOfRats" name="numberOfRats" placeholder="Number of Rats"><br>
                <label for="ratLimit">Rat Limit</label>
                <input class="input" type="number" required id="ratLimit" name="ratLimit" placeholder="Rat Limit per Room"><br>
                <label for="timeWithoutMovement">Time Without Movement</label>
                <input class="input" type="number" required id="timeWithoutMovement" name="timeWithoutMovement" placeholder="Time limit without Rat Movement"><br>
                <label for="idealTemperature">Ideal Temperature</label>
                <input class="input" type="number" required id="idealTemperature" name="idealTemperature" placeholder="Ideal Temperature"><br>
                <label for="maxTempVariation">Maximum Temperature Deviation</label>
                <input class="input" type="number" required id="maxTempVariation" name="maxTempVariation" placeholder="Maximum temperature deviation"><br><br>


                <input class="input" type="submit" value="Submit" name="Submit">
            </form>
            <br>
            <a href="landingPage.php">Go Back</a>
        </div>
    </section>
</body>

</html>

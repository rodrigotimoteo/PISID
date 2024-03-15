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
                <li><a href="actions/logout.php">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<div>
    <h1>Create Test</h1>
    <form action="actions/createNewTest.php" method="post">
        <label for="description">Description:</label>
        <input type="text" id="description" name="description">

        <br><br>

        <label for="numberOfRats">Number of Rats:</label>
        <input type="number" required="" id="numberOfRats" name="numberOfRats">

        <br><br>

        <label for="ratLimit">Rat Limit per Room:</label>
        <input type="number" required="" id="ratLimit" name="ratLimit">

        <br><br>

        <label for="timeWithoutMovement">Time limit without Rat Movement:</label>
        <input type="number" required="" id="timeWithoutMovement" name="timeWithoutMovement">

        <br><br>

        <label for="idealTemperature">Ideal Temperature:</label>
        <input type="number" required="" id="idealTemperature" name="idealTemperature">

        <br><br>

        <label for="maxTempVariation">Maximum temperature deviation:</label>
        <input type="number" required="" id="maxTempVariation" name="maxTempVariation">

        <br><br>

        <input type="submit" value="Submit" name="Submit">
    </form>
</div>

</body>
</html>
<?php

include("config.php");

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    $id_substancia_exp = $_GET['edit_subs_id'];

    if (isset($_SESSION['email'])) {

        if (isset($_GET['edit_id_exp'])) {

            $stmt = $sqli->prepare("SELECT substancia, num_ratos_administrada FROM ExperienciaSubstancia WHERE id_substancia_exp = ?");
            $stmt->bind_param("i", $id_substancia_exp);
            $stmt->execute();

            $stmt->bind_result($substancia, $num_ratos_administrada);

            $stmt->fetch();
            $stmt->close();
        }
    }
    $sqli->close();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Edit Substance</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        label {
            color: #000000;
        }
    </style>
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


        <div class="form">
            <h2>Edit Substance</h2><br>
            <form action="actions/editTest.php" method="post">
                <input type="hidden" name="test_id" value="<?php echo $id_substancia_exp; ?>">
                <label for="substance">Substance:</label>
                <input type="text" id="substance" name="substance" value="<?php echo $substancia; ?>" required>
                <label for="$num_ratos_administrada">Number of Rats:</label>
                <input type="number" id="$num_ratos_administrada" name="$num_ratos_administrada" value="<?php echo $num_ratos_administrada; ?>" required>

                <br>
                <input type="submit" value="Update Test">
            </form>

            <form action="substanceList.php" method="POST">
                <input type="hidden" name="substance_list" value="<?php echo htmlspecialchars($_POST['id_exp']); ?>">
                <button type="submit">Go back</button>
            </form>
        </div>
    </section>

</body>

</html>

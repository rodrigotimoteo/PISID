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

    if(isset($_SESSION['email'])) {

        if(isset($_GET['edit_id_exp'])) {

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
    <title>Edit Test</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        h2 {
            font-family: 'Open Sans', sans-serif;
            text-align: center;
            margin-top: 50px;
            font-size: 36px;
            color: #ffffff;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Open Sans', sans-serif;
            background: linear-gradient(90deg, rgba(58,255,246,1) 5%, rgba(240,16,220,1) 100%, rgba(38,98,247,1) 100%);
        }

        form {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffff;
            text-align: center;
            box-shadow: 0 0 20px #000;
            margin-top: 50px;
            border-radius: 15px;
        }

        label {
            display: block;
            color: #000000;
            font-size: 18px;
            margin-top: 20px;
        }

        input {
            margin-bottom: 20px;
            padding: 10px 5px;
            width: 100%;
            background-color: #f4f4f4;
            border: none;
            text-align: center;
            font-size: 16px;
            font-family: 'Open Sans', sans-serif;
            font-weight: bold;
            color: #333;
            border-radius: 3px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            width: 100%;
            height: 700px;
            padding: 20px;
            box-sizing: border-box;
        }

        .menu {
            text-align: center;
            padding: 20px 0;
            display: flex;
            justify-content: space-around;
        }

        .menu a {
            text-decoration: none;
            color: #fff;
            margin: 0 10px;
            font-size: 18px;
        }

        .menu a:hover {
            text-decoration: underline;
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
            background-color: #A64141;
            color: #f4f4f4;
        }

        a {
            text-decoration: none;
            color: lightgray;
            margin-top: 10px;
            display: inline-block;
            font-size: 18px;
            margin-top: 20px;
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

    <h2>Edit Substance</h2>
    <div class="login">
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

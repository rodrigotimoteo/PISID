<?php

include("config.php");

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
}

$email = $_SESSION['email'];
$password = $_SESSION['password'];

$sqli = new mysqli(DB_SERVER, $email, $_SESSION['password'], DB_DATABASE);

if($sqli->connect_error) {
    die("Connection failed: " . $sqli->connect_error);
}

if(isset($_POST['substance_list'])) {
    $id_exp = $_POST['substance_list'];

    $query = "SELECT id_substancia_exp, id_experiencia, substancia, num_ratos_administrada FROM ExperienciaSubstancia WHERE id_experiencia = ?";
    $stmt = $sqli->prepare($query);
    $stmt->bind_param("s", $id_exp);
    $stmt->execute();
    $result = $stmt->get_result();
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SubstanceListPagePISID</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        h1 {
            font-family: 'Open Sans', sans-serif;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Open Sans', sans-serif;
            background: linear-gradient(90deg, rgba(58,255,246,1) 5%, rgba(240,16,220,1) 100%, rgba(38,98,247,1) 100%);
        }

        .container {
            max-width: 1800px;
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

        .test-list {
            background-color: #ffff;
            text-align: center;
            box-shadow: 0 0 20px #000;
            margin-top: 50px;
            padding: 30px;
            border-radius: 15px;
        }

        .test-list h1 {
            font-size: 36px;
            padding: 10px 0;
            color: #000;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }

        .edit, .delete {
            background-color: #c32ce1;
            color: #fff;
            border: none;
            padding: 8px 16px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
        }

        .edit:hover, .delete:hover {
            background-color: #A64141;
        }
        
        .start-finish {
            background-color: #c32ce1;
            color: #fff;
            border: none;
            padding: 8px 16px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
        }

        .start-finish:hover {
            background-color: #A64141;
        }
    </style>
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
        <div class="test-list">
            <h1>Substances</h1>
            <table>
                <tr>
                    <th>Substance</th>
                    <th>Number of Rats Appplied</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>

                <?php while ($row = $result->fetch_assoc()) { ?>
                    <tr>
                        <td><?php echo htmlspecialchars($row['substancia']); ?></td>
                        <td><?php echo htmlspecialchars($row['num_ratos_administrada']); ?></td>
                        <td>
                            <form action="editSubstance.php" method="GET">
                                <input type="hidden" name="edit_subs_id" value="<?php echo htmlspecialchars($row['id_substancia_exp']); ?>">
                                <button type="submit" class="start-finish" name="edit_subs_id">Edit Substance</button>
                            </form>
                        </td>
                        <td>
                            <form action="actions/deleteSubstance.php" method="GET">
                                <input type="hidden" name="delete_subs_id" value="<?php echo htmlspecialchars($row['id_substancia_exp']); ?>">
                                <button type="submit" class="start-finish" name="delete_subs_id">Delete Substance</button>
                            </form>
                        </td>
                    </tr>
                <?php } ?>
            </table>
            <br><br>
            <form action="createSubstance.php" method="POST">
                <input type="hidden" name="id_exp" value="<?php echo htmlspecialchars($id_exp); ?>">
                <button type="submit" class="start-finish">Add New Substance</button>
            </form>
        </div>
    </div>
</section>
</body>
</html>

<?php
$sqli->close();
?>

<?php
#session_start();

include("config.php");

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
}

$email = $_SESSION['email'];
$password = $_SESSION['password'];

$sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);
if($sqli->connect_error) {
    die("Connection failed: " . $sqli->connect_error);
}

$query = "SELECT id_experiencia, descricao, estado_experiencia, investigador, data_hora_criacao, data_hora_ult_edicao, data_hora_inicio, data_hora_conclusao, numero_ratos, limite_ratos_sala, segundos_sem_movimento, temperatura_ideal, variacao_temperatura_maxima, num_movimentos_ratos FROM experiencia WHERE investigador = ?";
$stmt = $sqli->prepare($query);
$stmt->bind_param("s", $_SESSION['email']);
$stmt->execute();
$result = $stmt->get_result();

$query2 = "SELECT estado_experiencia  FROM experiencia WHERE investigador = ?";
$stmt2 = $sqli->prepare($query2);
$stmt2->bind_param("s", $_SESSION['email']);
$stmt2->execute();
$result2 = $stmt2->get_result();


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TestListPagePISID</title>
    <link rel="stylesheet" href="style.css" media="screen">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

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
            <h1>Tests</h1>
            <table>
                <tr>
                    <th>Experience Number</th>
                    <th>Description</th>
                    <th>State</th>
                    <th>Number Of Rats</th>
                    <th>Rats per Room</th>
                    <th>Seconds w/ Movement</th>
                    <th>Ideal temp</th>
                    <th>Max temp deviation</th>
                    <th>Delete</th>
                    <th>Edit</th>
                    <th>Interact</th>
                    <th>Substances</th>
                </tr>
                <?php

                $count =0;

                while ($row = $result2->fetch_assoc()) {
                    if($row['estado_experiencia'] == 'A decorrer'){
                        $count = 1;
                    }
                }

                ?>

                 <?php while ($row = $result->fetch_assoc()) { ?>
                    <tr>
                        <td><?php echo htmlspecialchars($row['id_experiencia']); ?></td>
                        <td><?php echo htmlspecialchars($row['descricao']); ?></td>
                        <td><?php echo htmlspecialchars($row['estado_experiencia']); ?></td>
                        <td><?php echo htmlspecialchars($row['numero_ratos']); ?></td>
                        <td><?php echo htmlspecialchars($row['limite_ratos_sala']); ?></td>
                        <td><?php echo htmlspecialchars($row['segundos_sem_movimento']); ?></td>
                        <td><?php echo htmlspecialchars($row['temperatura_ideal']); ?></td>
                        <td><?php echo htmlspecialchars($row['variacao_temperatura_maxima']); ?></td>
                        <td>
                            <form action="actions/deleteTest.php" method="GET">
                                <input type="hidden" name="delete_id_exp" value="<?php echo htmlspecialchars($row['id_experiencia']); ?>">
                                <button type="submit" class="start-finish" name="delete">Delete Test</button>
                            </form>
                        </td>
                        <td>
                            <?php if ($row['estado_experiencia'] == 'Por Iniciar') { ?>
                                <form action="editTestPage.php" method="GET">
                                    <input type="hidden" name="edit_id_exp" value="<?php echo htmlspecialchars($row['id_experiencia']); ?>">
                                    <button type="submit" class="start-finish" name="edit">Edit Test</button>
                                </form>
                            <?php } else { ?>
                                <button class="start-finish" disabled>Edit Test</button>
                            <?php } ?>
                        </td>

                        <td>
                            <?php if ($row['estado_experiencia'] == 'A decorrer') { ?>
                                <form action="actions/finishTest.php" method="GET">
                                    <input type="hidden" name="stop_id_exp" value="<?php echo htmlspecialchars($row['id_experiencia']); ?>">
                                    <button type="submit" class="start-finish" name="stop">Stop Test</button>
                                </form>
                            <?php } elseif ($row['estado_experiencia'] == 'Terminada') { ?>
                                <button class="start-finish" disabled>Test Finished</button>
                            <?php } elseif ($count==0) { ?>
                                <form action="actions/startTest.php" method="GET">
                                    <input type="hidden" name="start_id_exp" value="<?php echo htmlspecialchars($row['id_experiencia']); ?>">
                                    <button type="submit" class="start-finish" name="start">Start Test</button>
                                </form>
                            <?php }else {?>
                                <button class="start-finish" disabled>Start Test</button>
                            <?php } ?>
                        </td>

                        <td>
                            <form action="subtanceList.php" method="POST">
                                <input type="hidden" name="substance_list" value="<?php echo htmlspecialchars($row['id_experiencia']); ?>">
                                <button type="submit" class="start-finish">Substances List</button>
                            </form>
                        </td>

                    </tr>

                 <?php } ?>

            </table>
        </div>
    </div>
</section>
</body>
</html>

<?php
$stmt->close();
$stmt2->close();
$sqli->close();
?>

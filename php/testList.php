<?php
session_start();
/*

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] === false) {
    echo "User isn't logged in, redirecting to landing page";
    header("Location: landingPage.php");
} else {
    echo "Welcome " . $_SESSION['name'];
}
*/
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TestListPagePISID</title>
    <style>
        @import url(https://fonts.googleapis.com/css?family=Rokkitt);
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
        @import url(https://fonts.googleapis.com/css?family=Roboto+Slab:700,400);
        @import url(https://fonts.googleapis.com/css?family=Lobster);

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

    </style>
</head>
<body>
<section class="container">
    <div class="menu">
        <a href="landingPage.php">Home</a>
        <a href="testList.php">Test List</a>
        <a href="createTest.php">Create Test</a>
        <a href="userPage.php">Edit User</a>
        <a href="actions/logout.php">Logout</a>
    </div>

    <div class="container">
        <div class="test-list">
            <h1>Tests</h1>
            <table>
                <tr>
                    <th>Experience Number</th>
                    <th>State</th>
                    <th>Number Of Rats</th>
                    <th>Description</th>
                    <th>Action 1</th>
                    <th>Action 2</th>
                    <th>Action 3</th>
                </tr>
                <tr>
                    <td>1</td>
                    <td>Finished</td>
                    <td>5</td>
                    <td>Description 1</td>
                    <td><button class="edit">Start Test</button></td>
                    <td><button class="delete">Assign Investigator</button></td>
                    <td><button class="delete">Edit Test</button></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>On Going</td>
                    <td>5</td>
                    <td>Description 2</td>
                    <td><button class="edit">Start Test</button></td>
                    <td><button class="delete">Assign Investigator</button></td>
                    <td><button class="delete">Edit Test</button></td>
                </tr>
                <tr>
                    <td>3</td>
                    <td>To Start</td>
                    <td>5</td>
                    <td>Description 3</td>
                    <td><button class="edit">Start Test</button></td>
                    <td><button class="delete">Assign Investigator</button></td>
                    <td><button class="delete">Edit Test</button></td>
                </tr>
            </table>
        </div>
    </div>
</section>
</body>
</html>

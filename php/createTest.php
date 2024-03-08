<?php


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LoginPagePISID</title>
    <!--        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.16/dist/tailwind.min.css" rel="stylesheet">-->
</head>

<body class="bg-gray-200">
<header class="bg-green-500 text-white p-6 border-b-4 border-orange-500">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="font-bold">Lab Rats</h1>
        <nav>
            <ul class="flex">
                <li class="mr-6"><a href="#" class="text-white uppercase">Home</a></li>
                <li class="mr-6"><a href="testList.php" class="text-white uppercase">List Tests</a></li>
                <li class="mr-6"><a href="#" id="logoutBtn" class="text-orange-500 font-bold uppercase">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="container">
    <h1>Create Test</h1>
    <table>
        <tr>
            <th>Description</th>
            <td><input type="text" id="description" name="description"></td>
        </tr>
        <tr>
            <th>Investigator</th>
            <td><input type="text" id="investigator" name="investigator"></td>
        </tr>
        <tr>
            <th>Number of Rats</th>
            <td><input type="number" id="numberOfRats" name="numberOfRats"></td>
        </tr>
        <tr>
            <th>Limit of Rats per Room</th>
            <td><input type="number" id="ratLimit" name="ratLimit"></td>
        </tr>
        <tr>
            <th>Time without Movement (in seconds)</th>
            <td><input type="number" id="timeWithoutMovement" name="timeWithoutMovement"></td>
        </tr>
        <tr>
            <th>Ideal Temperature</th>
            <td><input type="number" id="idealTemperature" name="idealTemperature"></td>
        </tr>
        <tr>
            <th>Maximum Temperature Variation</th>
            <td><input type="number" id="maxTimeWithoutMovement" name="maxTimeWithoutMovement"></td>
        </tr>
    </table>
</div>

</body>
</html>
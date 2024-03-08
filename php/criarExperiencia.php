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
                <li class="mr-6"><a href="#" id="loginBtn" class="text-orange-500 font-bold uppercase">Login</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="container">
    <h1>Create Test</h1>
    <table>
        <tr>
            <th>Data</th>
            <td><input type="text" id="data" name="data"></td>
        </tr>
        <tr>
            <th>Descrição</th>
            <td><input type="text" id="descricao" name="descricao"></td>
        </tr>
        <tr>
            <th>Investigador</th>
            <td><input type="text" id="investigador" name="investigador"></td>
        </tr>
        <tr>
            <th>Número de Ratos</th>
            <td><input type="number" id="num_ratos" name="num_ratos"></td>
        </tr>
        <tr>
            <th>Limite de Ratos</th>
            <td><input type="number" id="limite_ratos" name="limite_ratos"></td>
        </tr>
        <tr>
            <th>Segundos sem Movimento</th>
            <td><input type="number" id="segundos_sem_movimento" name="segundos_sem_movimento"></td>
        </tr>
        <tr>
            <th>Temperatura Ideal</th>
            <td><input type="number" id="temp_ideal" name="temp_ideal"></td>
        </tr>
        <tr>
            <th>Variação Máxima de Temperatura</th>
            <td><input type="number" id="var_max_temp" name="var_max_temp"></td>
        </tr>
    </table>
</div>

<script>
    function openProfileMenu() {
        // Define your profile dropdown menu logic here
    }
</script>

</body>
</html>
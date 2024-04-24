<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Lab Rats - Landing Page</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: rgb(58,255,246);
            background: linear-gradient(90deg, rgba(58,255,246,1) 5%, rgba(240,16,220,1) 100%, rgba(38,98,247,1) 100%);
        }

        h2 {
            font-size: 3em;
            margin-bottom: 10px;
            color: #ff69b4; /* Pink color for Lab Rats */
        }

        p {
            font-size: 1.5em;
            margin-bottom: 20px;
            color: #f4f4f4;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1.2em;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #0056b3;
        }

        /* Container styles */
        .container {
            text-align: center;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 500px;
            display: flex;
            flex-direction: column; /* Align children in a column */
            align-items: center; /* Center children horizontally */
        }
    </style>
</head>

<body>

<div class="container"> <!-- Added class="container" here -->
    <div>
        <h2><span style="color: #ff69b4;">Lab</span> Rats</h2> <!-- Added span for pink color in Lab -->
    </div>

    <div>
        <a href="loginPage.php" class="button">Login</a>
    </div>
</div>

</body>

</html>

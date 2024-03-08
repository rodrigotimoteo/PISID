<?php
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if ($username == 'admin' && $password == 'admin') {
        $_SESSION['loggedin'] = true;
        header("Location: login.php");
        exit;
    } else {
        $error = "Invalid username or password!";
    }
}
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
                <li class="mr-6">
                    <a href="#" class="text-white uppercase">Home</a>
                </li>
                <li class="mr-6">
                    <a href="#" id="loginBtn" class="text-orange-500 font-bold uppercase">Login</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<div class="container mx-auto">
    <div id="loginPopup" class="fixed z-10 inset-0 overflow-y-auto hidden">
        <div id="loginForm" class="bg-white rounded-lg shadow-lg w-1/3 mx-auto mt-20 p-6">
            <form action="" method="post">
                <label for="username" class="font-bold mb-2 block">Username:</label>
                <input type="text" id="username" name="username" class="border rounded w-full py-2 px-3
                            text-grey-darker mb-3">
                <label for="password" class="font-bold mb-2 block">Password:</label>
                <input type="password" id="password" name="password" class="border rounded w-full py-2
                            px-3 text-grey-darker mb-3">
                <input type="submit" value="Login" class="bg-green-500 hover:bg-orange-500 text-white
                            font-bold py-2 px-4 rounded cursor-pointer">
            </form>
            <?php if (isset($error)): ?>
                <p class="text-red-500 font-bold"><?php echo $error; ?></p>
            <?php endif; ?>
        </div>
    </div>

    <div class="mt-10">
        <h2 class="text-2xl font-bold mb-4">Lab Rats</h2>
        <p class="mb-4">neeko neeko neeeeee</p>
        <p class="mb-4">neeko neeko nee</p>
    </div>
</div>

<!--<script>-->
<!--    const modal = document.getElementById('loginPopup');-->
<!---->
<!--    const btn = document.getElementById("loginBtn");-->
<!---->
<!--    btn.onclick = function() {-->
<!--        modal.style.display = "block";-->
<!--    }-->
<!--    window.onclick = function(event) {-->
<!--        if (event.target === modal) {-->
<!--            modal.style.display = "none";-->
<!--        }-->
<!--    }-->
<!--</script>-->
</body>
</html>

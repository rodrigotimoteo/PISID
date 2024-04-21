<?php
session_start();

if (isset($_SESSION['loggedin']) && $_SESSION['loggedin'] === true) {
    echo "User already logged in, redirecting to test list";
    header("Location: testList.php");
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LoginPagePISID</title>
    <style>
        @import url(https://fonts.googleapis.com/css?family=Rokkitt);
@import url(https://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
@import url(https://fonts.googleapis.com/css?family=Roboto+Slab:700,400);
@import url(https://fonts.googleapis.com/css?family=Lobster);


* { margin: 0; padding: 0; -moz-box-sizing: border-box; box-sizing: border-box; }

h1 { font-family: 'Rokkitt', serif; }

body {
  background: url('https://unsplash.s3.amazonaws.com/batch%206/park-place.jpg') no-repeat center center fixed;
  background-size: cover;
  margin: 0 auto;
  width: 66%;
  font-family: 'Open Sans', sans-serif;
}


.container {
  width: 66%;
  min-width: 800px;
  position: absolute;
  top: 20%;
}
.span-6 {
  float: left;
  width: 49%;
  margin-right: 1%;
}

.login {
  background-color: #444444;
  text-align: center;
  box-shadow: 0 0 20px #000;
}
.login h1 {
  color: #A64141;
  font-size: 36px;
  padding: 30px;
  background-color: #d25555;
}
.login-content, .message {
  padding: 30px 30px 50px 30px;
}
.login-content a {
  text-decoration: none;
  font-size: 14px;
  color: #ccc;
}
label {
  display: block;
  color: #f4f4f4;
  font-size: 18px;
  margin-bottom: 3px;
  opacity: 0;
  
  transition: all .3s ease-in-out;
}
input {
  margin-bottom: 15px;
  padding: 10px 5px;
  width: 80%;
  background-color: #ccc;
  border: none;
  text-align: center;
  font-size: 16px;
  font-family: 'Open Sans', sans-serif;
  font-weight: bold;
  color: #333;
}
input:focus {
  background-color: #f4f4f4;
  border: none;
  outline: none;
}

input[type=submit] {
  color: #fff;
  background-color: #d25555;
  border: none;
  font-family: 'Rokkitt', serif;
  font-size: 24px;
  margin-top: 25px;
  width: 60%;
  
  transition: all .5s ease;
}
input[type=submit]:hover {
  background-color: #A64141;
  cursor: pointer;
  color: #f4f4f4;
}

.message {
  
}
.message span {
  display: block;
  color: rgba(255, 255, 255, 1);
  position: relative; 
  bottom: 80px;
  text-align: center;
}
.line {
  display: inline-block;
  padding: 2px;
  background-color: #fff;
  -webkit-transform: rotate(-12deg);
  -moz-transform: rotate(-12deg);
  transform: rotate(-12deg);
  width: 5px;
}
.first, .second, .third {
  font-size:10em;
  -webkit-transform: rotate(-12deg);
  -moz-transform: rotate(-12deg);
  transform: rotate(-12deg);
  letter-spacing: -4px;
}
.first {
  font-family: 'Lobster', cursive;
  -webkit-text-shadow: 3px 3px 0 #999;
  -moz-text-shadow: 3px 3px 0 #999;
  text-shadow: 3px 3px 0 #999;
}
.second:before {
  content: "";
  display: block;
  padding: 1px; 
  background-color: #fff;
  width: 170px;
  position: absolute;
  top: 50%;
  right: 110px;
}
.second:after {
  content: "";
  display: block;
  padding: 1px; 
  background-color: #fff;
  width: 170px;
  position: absolute;
  top: 50%;
  left: 110px;
}
.secondS {
  font-size: 8em;
  font-family: 'Lobster', cursive;
  -webkit-text-shadow: 3px 3px 0 #999;
  -moz-text-shadow: 3px 3px 0 #999;
  text-shadow: 3px 3px 0 #999;
  line-height: 150px;
}
.show {
  opacity: 1;
}
    </style>
    <script>
       $("#email").focus(function(){
    $("#emailLabel").addClass("show");
    $(this).val('')
}).blur(function(){
    $("#emailLabel").removeClass("show");
});

$("#password").focus(function(){
    $("#passwordLabel").addClass("show");
    $(this).val('')
}).blur(function(){
    $("#passwordLabel").removeClass("show");
});
    </script>
</head>
<body>
<header>
<section class="container">
        <div class="span-6">
            <div class="login">
                <h1>Greetings!</h1>
                    <a href="../landingPage.php">Home</a>
                </li>
                <li>
                    <a href="#" id="loginBtn">Login</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<div>
    <div id="loginPopup">
        <div id="loginForm">
            <form action="actions/login.php" method="post">
                <label id="emailLabel" for="email">Email:</label>
                <input type="text" required="" id="email" name="email">
                <label id="passwordLabel" for="password">Password:</label>
                <input type="password" required="" id="password" name="password">
                <a href="#">Forgot Username </a>&#x2022<a href="#"> Forgot Password</a><br>
                <input type="submit" value="login" name="login">
            </form>
        </div>
    </div>
    <div class="span-6">
            <div class="message">
                <span class="first">Lab</span>
                <span class="second">Rats</span>
            </div>
        </div>
</div>

</body>
</html>



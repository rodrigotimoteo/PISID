<?php

include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $sqli = new mysqli(DB_SERVER, $_SESSION['name'], $_SESSION['password'], DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    if(isset($_SESSION['email'])) {

        if(isset($_POST['name']) && isset($_POST['phone'])) {

            $name = $_POST['name'];
            $phone = $_POST['phone'];

            $query = "SELECT COUNT(*) AS count FROM utilizador WHERE (nome = ? OR telefone = ?) AND email <> ?";
            $stmt_check = $sqli->prepare($query);

            $stmt_check->bind_param("sss", $name, $phone, $_SESSION['email']);
            $stmt_check->execute();

            $result = $stmt_check->get_result();
            $row = $result->fetch_assoc();

            if($row['count'] == 0) {

                $procedure = "CALL EditUser(?,?,?,?)";
                $stmt = $sqli->prepare($procedure);

                if(!isset($_POST['name'])){
                    $name = $_SESSION['name'];
                }

                if(!isset($_POST['phone'])){
                    $name = $_SESSION['phone'];
                }

                $email_user = $_SESSION['email'];
                $stmt2 = $sqli->prepare("SELECT password FROM utilizador WHERE email = ?");
                $stmt2->bind_param("s", $email_user);
                $stmt2->execute();
                $stmt2->store_result();
                $stmt2->bind_result($password_db);
                $stmt2->fetch();


                $stmt->bind_param("ssss", $password_db, $name, $phone, $_SESSION['email']);

                if ($stmt->execute()) {
                    /*echo "User information changed successfully";*/
                    header("Location: ../profileChange.php");
                } else {
                    echo "Error: " . $procedure . "<br>" . $sqli->error;
                }

                $stmt2->close();
                $stmt->close();

            } else {
                echo "Already in use by another User.";
            }
            $stmt_check->close();
        }

    }

    $sqli->close();

}
?>
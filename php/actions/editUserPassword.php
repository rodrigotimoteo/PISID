<?php

include("../config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $sqli = new mysqli(DB_SERVER, $_SESSION['email'], $_SESSION['password'], DB_DATABASE);

    if ($sqli->connect_error) {
        die("Connection failed: " . $sqli->connect_error);
    }

    if(isset($_SESSION['email'])) {

        if(isset($_POST['new_password']) && isset($_POST['current_password'])) {

            $current_password = $_POST['current_password'];
            $new_password = $_POST['new_password'];
            $email = $_SESSION['email'];

            // Verify if current password is correct
            $stmt_check_password = $sqli->prepare("SELECT password FROM utilizador WHERE email = ?");
            $stmt_check_password->bind_param("s", $email);
            $stmt_check_password->execute();
            $stmt_check_password->store_result();

            if($stmt_check_password->num_rows > 0) {
                $stmt_check_password->bind_result($hashed_password);
                $stmt_check_password->fetch();

                // Verify if current password matches the stored password
                if($current_password==$hashed_password) {
                    // Passwords match, proceed with updating the password
                    $procedure = "CALL EditUser(?,?,?,?)";
                    $stmt = $sqli->prepare($procedure);

                    $query = "SELECT telefone FROM utilizador WHERE email = ?";
                    $stmt_get_phone = $sqli->prepare($query);
                    $stmt_get_phone->bind_param("s", $_SESSION['email']);
                    $stmt_get_phone->execute();
                    $stmt_get_phone->bind_result($telefone);
                    $stmt_get_phone->fetch();

                    $stmt_get_phone->close();
                    $hashed_new_password = $new_password;

                    $stmt->bind_param("ssss",  $hashed_new_password, $_SESSION['name'], $telefone, $_SESSION['email']);


                    if ($stmt->execute()) {

                        #echo "Password changed successfully";
                        header("Location: ../profileChange.php");

                    } else {

                        echo "Error: " . $procedure . "<br>" . $sqli->error;

                    }

                    $stmt->close();


                } else {
                    echo "Current password is incorrect. " . $current_password;
                }
            } else {
                echo "User not found.";
            }

            $stmt_check_password->close();
        } else {
            echo "Please provide both current and new passwords.";
        }

    }

    $sqli->close();

}
?>
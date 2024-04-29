<?php

include("../config.php");

// Database connection parameters
$database = "mysql";

if($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];

    if(isset($_POST['password']))
        $password = $_POST['password'];
    else
        $password = "";

    $conn = new mysqli(DB_SERVER, $username, $password, $database);

    if($conn->connect_error) {
        $response = array(
            'success' => false,
            'message' => 'Database connection failed: ' . $conn->connect_error
        );

        header('Content-Type: application/json');
        echo json_encode($response);
        exit();
    }

    $sql_command = "SELECT * FROM user WHERE User = ?";
    $stmt = $conn->prepare($sql_command);
    $stmt->bind_param("s", $username);

    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        if(isset($row['password'])) {
            if(password_verify($password, $row['password'])) {
                $response = array(
                    'success' => true,
                    'message' => 'Login successful'
                );
            } else {
                $response = array(
                    'success' => false,
                    'message' => 'Invalid username or password: ' . $conn->connect_error
                );
            }
        } else {
            $response = array(
                'success' => true,
                'message' => 'Login successful'
            );
        }
    } else {
        $response = array(
            'success' => false,
            'message' => 'Invalid username or password: ' . $conn->connect_error
        );
    }

    header('Content-Type: application/json');
    echo json_encode($response);

    $stmt->close();
    $conn->close();
} else {
    http_response_code(405);
    echo json_encode(array(
        'error' => 'Method Not Allowed'
    ));
}
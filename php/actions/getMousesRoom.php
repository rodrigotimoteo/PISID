<?php
#session_start();

include("../config.php");

if($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];

    if(isset($_POST['password']))
        $password = $_POST['password'];
    else
        $password = "";

    $conn = new mysqli(DB_SERVER, $username, $password, DB_DATABASE);

    if($conn->connect_error) {
        $response = array(
            'success' => false,
            'message' => 'Database connection failed: ' . $conn->connect_error
        );

        header('Content-Type: application/json');
        echo json_encode($response);
        exit();
    }

    $sql_command = "SELECT MedicoesSalas.sala_0, MedicoesSalas.sala_1, MedicoesSalas.sala_2, MedicoesSalas.sala_3, MedicoesSalas.sala_4, 
       MedicoesSalas.sala_5, MedicoesSalas.sala_6, MedicoesSalas.sala_7, MedicoesSalas.sala_8, MedicoesSalas.sala_9 FROM MedicoesSalas 
           INNER JOIN Experiencia ON MedicoesSalas.id_experiencia = Experiencia.id_experiencia INNER 
           JOIN Utilizador ON Experiencia.investigador = Utilizador.email WHERE Utilizador.email = ?";
    $stmt = $conn->prepare($sql_command);
    $stmt->bind_param("s", $username);

    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows > 0) {
        $response = array(
            'success' => false,
            'data'    => array()
        );
        while($row = $result->fetch_assoc()) {
            $response['data'][] = $row;
        }
    } else {
        $response = array(
            'success' => false,
            'message' => 'No results found'
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
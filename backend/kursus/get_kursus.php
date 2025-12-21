<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

include '../config/database.php';

if (!$koneksi) {
    echo "[]";
    exit;
}

$query = "SELECT * FROM kursus ORDER BY id DESC";
$result = $koneksi->query($query);

$data = [];
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

echo json_encode($data);
?>
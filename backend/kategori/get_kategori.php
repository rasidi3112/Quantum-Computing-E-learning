<?php

error_reporting(0); 
ini_set('display_errors', 0);

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

include '../config/database.php';

if ($koneksi->connect_error) {
    echo json_encode(["status" => "error", "pesan" => "Koneksi database gagal"]);
    exit;
}

$query = "SELECT id, nama_kategori FROM kategori ORDER BY id ASC";
$result = $koneksi->query($query);

$data = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

echo json_encode($data);
?>

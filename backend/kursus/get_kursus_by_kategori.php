<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

include '../config/database.php';

$id_kategori = $_GET['id_kategori'] ?? 0;

if (!$koneksi) { echo "[]"; exit; }

if ($id_kategori == 1 || $id_kategori == 0) {

    $query = "SELECT * FROM kursus ORDER BY id DESC";
    $result = $koneksi->query($query);
} else {

    $query = "SELECT DISTINCT k.* FROM kursus k 
              INNER JOIN kursus_kategori kk ON k.id = kk.id_kursus 
              WHERE kk.id_kategori = ? 
              ORDER BY k.id DESC";
    if ($stmt = $koneksi->prepare($query)) {
        $stmt->bind_param("i", $id_kategori);
        $stmt->execute();
        $result = $stmt->get_result();
    } else {
        $result = false;
    }
}

$data = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

echo json_encode($data);
?>





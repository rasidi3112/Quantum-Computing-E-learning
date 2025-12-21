<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

include '../config/database.php';

$id_kursus = $_GET['id_kursus'] ?? '';

if (empty($id_kursus)) {
    echo json_encode([]);
    exit;
}

if ($koneksi->connect_error) {
    echo json_encode([]);
    exit;
}

$sql = "SELECT k.id, k.nama_kategori FROM kategori k 
        JOIN kursus_kategori kk ON k.id = kk.id_kategori 
        WHERE kk.id_kursus = ?";

if ($stmt = $koneksi->prepare($sql)) {
    $stmt->bind_param("i", $id_kursus);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $kategori = [];
    while ($row = $result->fetch_assoc()) {
        $kategori[] = $row;
    }
    echo json_encode($kategori);
} else {
    echo json_encode([]);
}
?>

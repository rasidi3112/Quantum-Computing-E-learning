<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id = $_GET['id'] ?? 0;

    if (empty($id)) {
        echo json_encode(["status" => "gagal", "pesan" => "ID pelajaran diperlukan"]);
        exit;
    }

    $sql = "SELECT * FROM pelajaran WHERE id = ?";
    $stmt = $koneksi->prepare($sql);
    
    if (!$stmt) {
        echo json_encode(["status" => "gagal", "pesan" => "Database error"]);
        exit;
    }
    
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = $result->fetch_assoc();

    if ($data) {
        echo json_encode($data);
    } else {
        echo json_encode(["status" => "gagal", "pesan" => "Pelajaran tidak ditemukan"]);
    }
} catch (Exception $e) {
    echo json_encode(["status" => "gagal", "pesan" => "Error: " . $e->getMessage()]);
}
?>
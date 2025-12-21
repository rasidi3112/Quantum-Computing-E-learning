<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id_kursus = $_GET['id_kursus'] ?? 0;

    if (empty($id_kursus)) {
        echo json_encode([]);
        exit;
    }

    $query = "SELECT * FROM pelajaran WHERE id_kursus = ? ORDER BY urutan";
    $stmt = $koneksi->prepare($query);
    
    if (!$stmt) {
        echo json_encode([]);
        exit;
    }
    
    $stmt->bind_param("i", $id_kursus);
    $stmt->execute();
    $result = $stmt->get_result();

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode($data);
} catch (Exception $e) {
    echo json_encode([]);
}
?>
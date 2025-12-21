<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id_kursus = $_GET['id_kursus'] ?? '';

    if (empty($id_kursus)) {
        echo json_encode([]);
        exit;
    }

    $sql = "SELECT u.*, p.nama as nama_pengguna FROM ulasan u 
            JOIN pengguna p ON u.id_pengguna = p.id 
            WHERE u.id_kursus = ? 
            ORDER BY u.dibuat_pada DESC";
    $stmt = $koneksi->prepare($sql);
    
    if (!$stmt) {
        echo json_encode([]);
        exit;
    }
    
    $stmt->bind_param("i", $id_kursus);
    $stmt->execute();
    $result = $stmt->get_result();

    $ulasan = [];
    while ($row = $result->fetch_assoc()) {
        $ulasan[] = $row;
    }

    echo json_encode($ulasan);
} catch (Exception $e) {
    echo json_encode([]);
}
?>

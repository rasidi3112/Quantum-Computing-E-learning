<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id_pendaftaran = $_GET['id_pendaftaran'] ?? '';

    if (empty($id_pendaftaran)) {
        echo json_encode([]);
        exit;
    }

    $sql = "SELECT pr.*, pl.judul as judul_pelajaran, pl.urutan 
            FROM progres pr 
            JOIN pelajaran pl ON pr.id_pelajaran = pl.id 
            WHERE pr.id_pendaftaran = ? 
            ORDER BY pl.urutan";
    $stmt = $koneksi->prepare($sql);
    
    if (!$stmt) {
        echo json_encode([]);
        exit;
    }
    
    $stmt->bind_param("i", $id_pendaftaran);
    $stmt->execute();
    $result = $stmt->get_result();

    $progres = [];
    while ($row = $result->fetch_assoc()) {
        $progres[] = $row;
    }

    echo json_encode($progres);
} catch (Exception $e) {
    echo json_encode([]);
}
?>

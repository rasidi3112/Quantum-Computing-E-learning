<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

include '../config/database.php';

$id_pendaftaran = $_POST['id_pendaftaran'] ?? '';

if (empty($id_pendaftaran)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID pendaftaran diperlukan"]);
    exit;
}

if ($koneksi->connect_error) {
    echo json_encode(["status" => "error", "pesan" => "Koneksi database gagal"]);
    exit;
}

// Reset semua progres untuk pendaftaran ini (set status ke 'belum_mulai')
$sql = "UPDATE progres SET status = 'belum_mulai', diperbarui_pada = NOW() WHERE id_pendaftaran = ?";
$stmt = $koneksi->prepare($sql);

if (!$stmt) {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal mempersiapkan query"]);
    exit;
}

$stmt->bind_param("i", $id_pendaftaran);

if ($stmt->execute()) {
    $affected = $stmt->affected_rows;
    if ($affected > 0) {
        echo json_encode([
            "status" => "sukses", 
            "pesan" => "Progres belajar berhasil direset",
            "jumlah_reset" => $affected
        ]);
    } else {
        // Tidak ada progres yang perlu direset (mungkin belum mulai sama sekali)
        echo json_encode([
            "status" => "sukses", 
            "pesan" => "Progres belajar sudah dalam keadaan awal"
        ]);
    }
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal mereset progres: " . $koneksi->error]);
}

$stmt->close();
?>

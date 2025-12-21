<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

include '../config/database.php';

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID pendaftaran diperlukan"]);
    exit;
}

if ($koneksi->connect_error) {
    echo json_encode(["status" => "error", "pesan" => "DB Error"]);
    exit;
}

// Hapus progres terkait pendaftaran ini terlebih dahulu
$stmt = $koneksi->prepare("DELETE FROM progres WHERE id_pendaftaran = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();

// Baru hapus pendaftaran
$sql = "DELETE FROM pendaftaran WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Pendaftaran berhasil dibatalkan"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal membatalkan pendaftaran: " . $koneksi->error]);
}
?>

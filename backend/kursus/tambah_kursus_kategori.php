<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

include '../config/database.php';

$id_kursus = $_POST['id_kursus'] ?? '';
$id_kategori = $_POST['id_kategori'] ?? '';

if (empty($id_kursus) || empty($id_kategori)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID kursus dan kategori diperlukan"]);
    exit;
}

if ($koneksi->connect_error) {
    echo json_encode(["status" => "gagal", "pesan" => "DB Error"]);
    exit;
}

$del = "DELETE FROM kursus_kategori WHERE id_kursus = ?";
if ($stmtDel = $koneksi->prepare($del)) {
    $stmtDel->bind_param("i", $id_kursus);
    $stmtDel->execute();
    $stmtDel->close();
}

$sql = "INSERT INTO kursus_kategori (id_kursus, id_kategori) VALUES (?, ?)";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("ii", $id_kursus, $id_kategori);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Kategori berhasil diperbarui"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal update kategori: " . $koneksi->error]);
}
?>

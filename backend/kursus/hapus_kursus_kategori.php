<?php
header('Content-Type: application/json');
include '../config/database.php';

$id_kursus = $_POST['id_kursus'] ?? '';
$id_kategori = $_POST['id_kategori'] ?? '';

if (empty($id_kursus) || empty($id_kategori)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID kursus dan kategori diperlukan"]);
    exit;
}

$sql = "DELETE FROM kursus_kategori WHERE id_kursus = ? AND id_kategori = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("ii", $id_kursus, $id_kategori);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Kategori berhasil dihapus dari kursus"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal menghapus kategori dari kursus"]);
}
?>

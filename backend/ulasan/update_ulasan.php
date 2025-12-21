<?php
header('Content-Type: application/json');
include '../config/database.php';

$id = $_POST['id'] ?? '';
$rating = $_POST['rating'] ?? '';
$komentar = $_POST['komentar'] ?? '';

if (empty($id)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID ulasan diperlukan"]);
    exit;
}

$sql = "UPDATE ulasan SET rating = ?, komentar = ? WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("isi", $rating, $komentar, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Ulasan berhasil diperbarui"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal memperbarui ulasan"]);
}
?>

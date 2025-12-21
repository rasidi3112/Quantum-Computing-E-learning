<?php
header('Content-Type: application/json');
include '../config/database.php';

$id = $_POST['id'] ?? '';
$judul = $_POST['judul'] ?? '';
$konten = $_POST['konten'] ?? '';
$urutan = $_POST['urutan'] ?? 1;

if (empty($id) || empty($judul)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID dan Judul wajib diisi"]);
    exit;
}

$sql = "UPDATE pelajaran SET judul = ?, konten_teks = ?, urutan = ? WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("ssii", $judul, $konten, $urutan, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Pelajaran berhasil diperbarui"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal memperbarui pelajaran"]);
}
?>

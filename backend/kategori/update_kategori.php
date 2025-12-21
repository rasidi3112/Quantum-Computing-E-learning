<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include '../config/database.php';

$id = $_POST['id'] ?? '';
$nama = $_POST['nama_kategori'] ?? $_POST['nama'] ?? '';

if (empty($id) || empty($nama)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID dan Nama kategori wajib diisi"]);
    exit;
}

if ($id == 1) {
    echo json_encode(["status" => "gagal", "pesan" => "Kategori default tidak dapat diubah"]);
    exit;
}

$sql = "UPDATE kategori SET nama_kategori = ? WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("si", $nama, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Kategori berhasil diperbarui"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal memperbarui kategori: " . $koneksi->error]);
}
?>

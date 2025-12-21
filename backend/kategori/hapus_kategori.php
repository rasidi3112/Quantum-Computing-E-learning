<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include '../config/database.php';

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID kategori wajib diisi"]);
    exit;
}

if ($id == 1) {
    echo json_encode(["status" => "gagal", "pesan" => "Kategori default tidak dapat dihapus"]);
    exit;
}

$sql = "DELETE FROM kategori WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Kategori berhasil dihapus"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal menghapus kategori: " . $koneksi->error]);
}
?>

<?php
header('Content-Type: application/json');
include '../config/database.php';

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID ulasan diperlukan"]);
    exit;
}

$sql = "DELETE FROM ulasan WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Ulasan berhasil dihapus"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal menghapus ulasan"]);
}
?>

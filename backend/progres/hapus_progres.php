<?php
header('Content-Type: application/json');
include '../config/database.php';

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID progres diperlukan"]);
    exit;
}

$sql = "DELETE FROM progres WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Progres berhasil dihapus"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal menghapus progres"]);
}
?>

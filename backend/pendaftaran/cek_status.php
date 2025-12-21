<?php
header('Content-Type: application/json');
include '../config/database.php';

$id_pengguna = $_GET['id_pengguna'] ?? 0;
$id_kursus = $_GET['id_kursus'] ?? 0;

$query = "SELECT * FROM pendaftaran WHERE id_pengguna = ? AND id_kursus = ?";
$stmt = $koneksi->prepare($query);
$stmt->bind_param("ii", $id_pengguna, $id_kursus);
$stmt->execute();
$result = $stmt->get_result();
$data = $result->fetch_assoc();

if ($data) {
    echo json_encode(["status" => "terdaftar", "data" => $data]);
} else {
    echo json_encode(["status" => "belum_terdaftar"]);
}
?>

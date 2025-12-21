<?php
header('Content-Type: application/json');
include '../config/database.php';

$id_pendaftaran = $_POST["id_pendaftaran"] ?? 0;
$id_pelajaran = $_POST["id_pelajaran"] ?? 0;
$status = $_POST["status"] ?? "belum_mulai";

$sql = "SELECT * FROM progres WHERE id_pendaftaran = ? AND id_pelajaran = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("ii", $id_pendaftaran, $id_pelajaran);
$stmt->execute();
$result = $stmt->get_result()->fetch_assoc();

if ($result) {
    $sql_update = "UPDATE progres SET status = ?, diperbarui_pada = NOW() WHERE id = ?";
    $stmt2 = $koneksi->prepare($sql_update);
    $stmt2->bind_param("si", $status, $result["id"]);
    $stmt2->execute();
    echo json_encode(["status" => "sukses", "pesan" => "Progres diperbarui"]);
} else {
    $sql_insert = "INSERT INTO progres (id_pendaftaran, id_pelajaran, status) VALUES (?, ?, ?)";
    $stmt3 = $koneksi->prepare($sql_insert);
    $stmt3->bind_param("iis", $id_pendaftaran, $id_pelajaran, $status);
    $stmt3->execute();
    echo json_encode(["status" => "sukses", "pesan" => "Progres ditambahkan"]);
}
?>
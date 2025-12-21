<?php
header('Content-Type: application/json');
include '../config/database.php';

$id = $_GET["id"] ?? 0;

$query = "SELECT * FROM kursus WHERE id = ?";
$stmt = $koneksi->prepare($query);
$stmt->bind_param("i", $id);
$stmt->execute();
$data = $stmt->get_result()->fetch_assoc();

echo json_encode($data);
?>
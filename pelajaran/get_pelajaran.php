<?php
include '../config/database.php';

$id_kursus = $_GET['id_kursus'];

$query = "SELECT * FROM pelajaran WHERE id_kursus = ?";
$stmt = $koneksi->prepare($query);
$stmt->bind_param("i", $id_kursus);
$stmt->execute();
$result = $stmt->get_result();

$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>


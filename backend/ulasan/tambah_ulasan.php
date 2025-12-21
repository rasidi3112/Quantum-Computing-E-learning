<?php
header('Content-Type: application/json');
include '../config/database.php';

$id_pengguna = $_POST["id_pengguna"] ?? 0;
$id_kursus = $_POST["id_kursus"] ?? 0;
$rating = $_POST["rating"] ?? 0;
$komentar = $_POST["komentar"] ?? "";

$sql = "INSERT INTO ulasan (id_pengguna, id_kursus, rating, komentar) VALUES (?, ?, ?, ?)";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("iiis", $id_pengguna, $id_kursus, $rating, $komentar);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Ulasan berhasil ditambahkan"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal menambahkan ulasan"]);
}
?>
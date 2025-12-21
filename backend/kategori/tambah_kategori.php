<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include '../config/database.php';

$nama = $_POST['nama_kategori'] ?? $_POST['nama'] ?? '';

if (empty($nama)) {
    echo json_encode(["status" => "gagal", "pesan" => "Nama kategori wajib diisi"]);
    exit;
}
$sql = "INSERT INTO kategori (nama_kategori) VALUES (?)";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("s", $nama);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "sukses", 
        "pesan" => "Kategori berhasil ditambahkan", 
        "id" => $koneksi->insert_id
    ]);
} else {
    echo json_encode([
        "status" => "gagal", 
        "pesan" => "Gagal menambahkan kategori: " . $koneksi->error
    ]);
}
?>
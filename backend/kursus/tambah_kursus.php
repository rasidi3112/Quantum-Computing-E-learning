<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

include '../config/database.php';

$judul     = $_POST['judul'] ?? '';
$deskripsi = $_POST['deskripsi'] ?? '';
$tingkat   = $_POST['tingkat'] ?? 'Pemula'; 
$gambar    = $_POST['gambar_thumbnail'] ?? null;
$warna     = $_POST['warna_tema'] ?? '#667eea';

if (empty($judul)) {
    echo json_encode(["status" => "gagal", "pesan" => "Judul kursus wajib diisi"]);
    exit;
}

$sql = "INSERT INTO kursus (judul, deskripsi, tingkat, gambar_thumbnail, warna_tema, dibuat_pada) VALUES (?, ?, ?, ?, ?, NOW())";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("sssss", $judul, $deskripsi, $tingkat, $gambar, $warna);

if ($stmt->execute()) {
    
    echo json_encode([
        "status" => "sukses", 
        "pesan" => "Kursus berhasil ditambahkan",
        "id" => $koneksi->insert_id 
    ]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal tambah kursus: " . $koneksi->error]);
}
?>

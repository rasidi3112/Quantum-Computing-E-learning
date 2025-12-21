<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

include '../config/database.php';

$id        = $_POST['id'] ?? '';
$judul     = $_POST['judul'] ?? '';
$deskripsi = $_POST['deskripsi'] ?? '';
$tingkat   = $_POST['tingkat'] ?? 'Pemula';
$gambar    = $_POST['gambar_thumbnail'] ?? null;
$warna     = $_POST['warna_tema'] ?? null;

if (empty($id) || empty($judul)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID dan Judul wajib diisi"]);
    exit;
}

// Build dynamic query
$sql = "UPDATE kursus SET judul = ?, deskripsi = ?, tingkat = ?";
$params = [$judul, $deskripsi, $tingkat];
$types = "sss";

if ($gambar !== null && $gambar !== '') {
    $sql .= ", gambar_thumbnail = ?";
    $params[] = $gambar;
    $types .= "s";
}

if ($warna !== null && $warna !== '') {
    $sql .= ", warna_tema = ?";
    $params[] = $warna;
    $types .= "s";
}

$sql .= " WHERE id = ?";
$params[] = $id;
$types .= "i";

$stmt = $koneksi->prepare($sql);
$stmt->bind_param($types, ...$params);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Kursus berhasil diperbarui"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal memperbarui kursus: " . $koneksi->error]);
}
?>

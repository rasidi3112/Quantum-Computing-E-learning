<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

include '../config/database.php';

$id_kursus = $_POST['id_kursus'] ?? '';
$judul = $_POST['judul'] ?? '';
$konten = $_POST['konten'] ?? '';
$urutan = $_POST['urutan'] ?? 1;

error_log("TAMBAH PELAJARAN - id_kursus: $id_kursus, judul: $judul, urutan: $urutan");

if (empty($id_kursus) || empty($judul)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID Kursus dan Judul wajib diisi"]);
    exit;
}

$sql = "INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan, dibuat_pada) VALUES (?, ?, ?, ?, NOW())";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("issi", $id_kursus, $judul, $konten, $urutan);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "sukses", 
        "pesan" => "Pelajaran berhasil ditambahkan", 
        "id" => $koneksi->insert_id
    ]);
} else {
    echo json_encode([
        "status" => "gagal", 
        "pesan" => "Gagal menambahkan pelajaran: " . $stmt->error
    ]);
}
?>

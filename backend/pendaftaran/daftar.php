<?php
header('Content-Type: application/json');
include '../config/database.php';

$id_pengguna = $_POST['id_pengguna'] ?? '';
$id_kursus   = $_POST['id_kursus'] ?? '';

if (empty($id_pengguna) || empty($id_kursus)) {
    echo json_encode(["status" => "gagal", "pesan" => "Data tidak lengkap"]);
    exit;
}

$check = $koneksi->query("SELECT id FROM pendaftaran WHERE id_pengguna = '$id_pengguna' AND id_kursus = '$id_kursus'");

if ($check->num_rows > 0) {
    echo json_encode(["status" => "gagal", "pesan" => "Anda sudah terdaftar di kursus ini"]);
} else {
    $sql = "INSERT INTO pendaftaran (id_pengguna, id_kursus, tanggal_daftar) VALUES (?, ?, NOW())";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("ii", $id_pengguna, $id_kursus);
    
    if ($stmt->execute()) {
        echo json_encode(["status" => "sukses", "pesan" => "Berhasil mendaftar kursus"]);
    } else {
        echo json_encode(["status" => "gagal", "pesan" => "Gagal mendaftar"]);
    }
}
?>

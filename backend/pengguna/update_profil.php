<?php
header('Content-Type: application/json');
include '../config/database.php';

$id     = $_POST['id'] ?? '';
$nama   = $_POST['nama'] ?? '';
$email  = $_POST['email'] ?? '';
$password = $_POST['password'] ?? ''; 

if (empty($id) || empty($nama) || empty($email)) {
    echo json_encode(["status" => "gagal", "pesan" => "Nama dan Email wajib diisi"]);
    exit;
}

if (!empty($password)) {
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    $sql = "UPDATE pengguna SET nama = ?, email = ?, kata_sandi = ? WHERE id = ?";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("sssi", $nama, $email, $hashed_password, $id);
} else {
    $sql = "UPDATE pengguna SET nama = ?, email = ? WHERE id = ?";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("ssi", $nama, $email, $id);
}

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Profil berhasil diperbarui"]);
} else {
    echo json_encode(["status" => "gagal", "pesan" => "Gagal update profil"]);
}
?>

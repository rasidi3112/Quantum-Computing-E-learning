<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
try {
    include '../config/database.php';

    if (!isset($_POST['nama']) || !isset($_POST['email']) || !isset($_POST['kata_sandi'])) {
        echo json_encode(["status" => "gagal", "pesan" => "Data tidak lengkap"]);
        exit;
    }
    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $kata_sandi = $_POST['kata_sandi'];

    $kata_sandi_hash = password_hash($kata_sandi, PASSWORD_BCRYPT);

    $sql = "INSERT INTO pengguna (nama, email, kata_sandi) VALUES (?, ?, ?)";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("sss", $nama, $email, $kata_sandi_hash);

    if ($stmt->execute()) {
        echo json_encode(["status" => "sukses", "pesan" => "Registrasi berhasil"]);
    } else {
        if ($koneksi->errno == 1062) {
            echo json_encode(["status" => "gagal", "pesan" => "Email sudah terdaftar"]);
        } else {
            echo json_encode(["status" => "gagal", "pesan" => "Registrasi gagal: " . $stmt->error]);
        }
    }
} catch (Exception $e) {
    echo json_encode(["status" => "gagal", "pesan" => "Error: " . $e->getMessage()]);
}
?>
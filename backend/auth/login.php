<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    if (!isset($_POST['email']) || !isset($_POST['kata_sandi'])) {
        echo json_encode(["status" => "gagal", "pesan" => "Data tidak lengkap"]);
        exit;
    }
    $email = $_POST['email'];
    $kata_sandi = $_POST['kata_sandi'];

    $sql = "SELECT * FROM pengguna WHERE email = ?";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = $result->fetch_assoc();

    if ($data && password_verify($kata_sandi, $data["kata_sandi"])) {
        unset($data["kata_sandi"]); 
        echo json_encode([
            "status" => "sukses",
            "data" => $data,
            "pesan" => "Login berhasil"
        ]);
    } else {
        echo json_encode(["status" => "gagal", "pesan" => "Email atau password salah"]);
    }
} catch (Exception $e) {
    echo json_encode(["status" => "gagal", "pesan" => "Error: " . $e->getMessage()]);
}
?>

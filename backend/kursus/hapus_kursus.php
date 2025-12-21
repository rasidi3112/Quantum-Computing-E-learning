<?php
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

include '../config/database.php';

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(["status" => "gagal", "pesan" => "ID diperlukan"]);
    exit;
}

if ($koneksi->connect_error) {
    echo json_encode(["status" => "error", "pesan" => "DB Error"]);
    exit;
}

// Hapus progres terkait pendaftaran kursus ini
$stmt = $koneksi->prepare("DELETE pr FROM progres pr 
                           INNER JOIN pendaftaran p ON pr.id_pendaftaran = p.id 
                           WHERE p.id_kursus = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();

// Hapus progres terkait pelajaran kursus ini
$stmt = $koneksi->prepare("DELETE pr FROM progres pr 
                           INNER JOIN pelajaran pl ON pr.id_pelajaran = pl.id 
                           WHERE pl.id_kursus = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();

// Hapus pendaftaran kursus
$stmt = $koneksi->prepare("DELETE FROM pendaftaran WHERE id_kursus = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();

$stmt = $koneksi->prepare("DELETE FROM ulasan WHERE id_kursus = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();

$stmt = $koneksi->prepare("DELETE FROM pelajaran WHERE id_kursus = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();


$stmt = $koneksi->prepare("DELETE FROM kursus_kategori WHERE id_kursus = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();


$sql = "DELETE FROM kursus WHERE id = ?";
$stmt = $koneksi->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "sukses", "pesan" => "Kursus dan semua data terkait berhasil dihapus"]);
} else {

    echo json_encode(["status" => "gagal", "pesan" => "Gagal hapus kursus: " . $koneksi->error]);
}
?>

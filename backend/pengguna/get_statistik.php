<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id_pengguna = $_GET['id_pengguna'] ?? '';

    if (empty($id_pengguna)) {
        echo json_encode(["status" => "gagal", "pesan" => "ID pengguna diperlukan", "kursus" => 0, "selesai" => 0, "ulasan" => 0]);
        exit;
    }

    // Hitung jumlah ulasan
    $sql_ulasan = "SELECT COUNT(*) as total FROM ulasan WHERE id_pengguna = ?";
    $stmt = $koneksi->prepare($sql_ulasan);
    if (!$stmt) {
        echo json_encode(["status" => "sukses", "kursus" => 0, "selesai" => 0, "ulasan" => 0]);
        exit;
    }
    $stmt->bind_param("i", $id_pengguna);
    $stmt->execute();
    $result_ulasan = $stmt->get_result();
    $total_ulasan = $result_ulasan->fetch_assoc()['total'] ?? 0;

    // Hitung jumlah kursus yang diikuti
    $sql_kursus = "SELECT COUNT(*) as total FROM pendaftaran WHERE id_pengguna = ?";
    $stmt2 = $koneksi->prepare($sql_kursus);
    if (!$stmt2) {
        echo json_encode(["status" => "sukses", "kursus" => 0, "selesai" => 0, "ulasan" => (int)$total_ulasan]);
        exit;
    }
    $stmt2->bind_param("i", $id_pengguna);
    $stmt2->execute();
    $result_kursus = $stmt2->get_result();
    $total_kursus = $result_kursus->fetch_assoc()['total'] ?? 0;

   
    $sql_selesai = "SELECT COUNT(*) as total FROM progres pr 
                    JOIN pendaftaran pd ON pr.id_pendaftaran = pd.id 
                    WHERE pd.id_pengguna = ? AND pr.status = 'selesai'";
    $stmt3 = $koneksi->prepare($sql_selesai);
    if (!$stmt3) {
        echo json_encode(["status" => "sukses", "kursus" => (int)$total_kursus, "selesai" => 0, "ulasan" => (int)$total_ulasan]);
        exit;
    }
    $stmt3->bind_param("i", $id_pengguna);
    $stmt3->execute();
    $result_selesai = $stmt3->get_result();
    $total_selesai = $result_selesai->fetch_assoc()['total'] ?? 0;

    echo json_encode([
        "status" => "sukses",
        "kursus" => (int)$total_kursus,
        "selesai" => (int)$total_selesai,
        "ulasan" => (int)$total_ulasan
    ]);
} catch (Exception $e) {
    echo json_encode(["status" => "gagal", "pesan" => "Error", "kursus" => 0, "selesai" => 0, "ulasan" => 0]);
}
?>

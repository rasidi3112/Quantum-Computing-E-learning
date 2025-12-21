<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id_pengguna = $_GET['id_pengguna'] ?? '';

    if (empty($id_pengguna)) {
        echo json_encode([]);
        exit;
    }

    $sql = "SELECT p.*, k.judul as judul_kursus, k.tingkat, k.gambar_thumbnail, k.warna_tema 
            FROM pendaftaran p 
            JOIN kursus k ON p.id_kursus = k.id 
            WHERE p.id_pengguna = ? 
            ORDER BY p.tanggal_daftar DESC";
    $stmt = $koneksi->prepare($sql);
    
    if (!$stmt) {
        echo json_encode([]);
        exit;
    }
    
    $stmt->bind_param("i", $id_pengguna);
    $stmt->execute();
    $result = $stmt->get_result();

    $pendaftaran = [];
    while ($row = $result->fetch_assoc()) {
        $id_kursus = $row['id_kursus'];
        $id_pendaftaran = $row['id'];

        // 1. Hitung total pelajaran
        $qTotal = $koneksi->query("SELECT COUNT(*) as total FROM pelajaran WHERE id_kursus = '$id_kursus'");
        $total = $qTotal ? $qTotal->fetch_assoc()['total'] : 0;

        // 2. Hitung pelajaran selesai
        $qSelesai = $koneksi->query("SELECT COUNT(*) as selesai FROM progres WHERE id_pendaftaran = '$id_pendaftaran' AND status = 'selesai'");
        $selesai = $qSelesai ? $qSelesai->fetch_assoc()['selesai'] : 0;

        // 3. Hitung persentase
        $persen = ($total > 0) ? round(($selesai / $total) * 100) : 0;

        $row['total_pelajaran'] = $total;
        $row['selesai_pelajaran'] = $selesai;
        $row['progress_persen'] = $persen;

        $pendaftaran[] = $row;
    }

    echo json_encode($pendaftaran);
} catch (Exception $e) {
    echo json_encode([]);
}
?>

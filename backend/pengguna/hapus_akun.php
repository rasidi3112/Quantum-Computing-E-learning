<?php
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

try {
    include '../config/database.php';

    $id = $_POST['id'] ?? '';

    if (empty($id)) {
        echo json_encode(["status" => "gagal", "pesan" => "ID pengguna diperlukan"]);
        exit;
    }

    
    $koneksi->begin_transaction();

    try {

        $sql_progres = "DELETE pr FROM progres pr 
                        INNER JOIN pendaftaran pd ON pr.id_pendaftaran = pd.id 
                        WHERE pd.id_pengguna = ?";
        $stmt1 = $koneksi->prepare($sql_progres);
        if ($stmt1) {
            $stmt1->bind_param("i", $id);
            $stmt1->execute();
        }

        $sql_pendaftaran = "DELETE FROM pendaftaran WHERE id_pengguna = ?";
        $stmt2 = $koneksi->prepare($sql_pendaftaran);
        if ($stmt2) {
            $stmt2->bind_param("i", $id);
            $stmt2->execute();
        }

     
        $sql_ulasan = "DELETE FROM ulasan WHERE id_pengguna = ?";
        $stmt3 = $koneksi->prepare($sql_ulasan);
        if ($stmt3) {
            $stmt3->bind_param("i", $id);
            $stmt3->execute();
        }

   
        $sql_user = "DELETE FROM pengguna WHERE id = ?";
        $stmt4 = $koneksi->prepare($sql_user);
        if ($stmt4) {
            $stmt4->bind_param("i", $id);
            $stmt4->execute();
        }

   
        $koneksi->commit();

        echo json_encode(["status" => "sukses", "pesan" => "Akun dan semua data terkait berhasil dihapus"]);

    } catch (Exception $e) {
    
        $koneksi->rollback();
        echo json_encode(["status" => "gagal", "pesan" => "Gagal menghapus akun: " . $e->getMessage()]);
    }

} catch (Exception $e) {
    echo json_encode(["status" => "gagal", "pesan" => "Error: " . $e->getMessage()]);
}
?>

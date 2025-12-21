<?php

ini_set('display_errors', 0);
error_reporting(E_ALL);

function logDebug($msg) {
    $logFile = 'debug_upload.log';
    file_put_contents($logFile, date('[Y-m-d H:i:s] ') . $msg . PHP_EOL, FILE_APPEND);
}

logDebug("Request started");

header('Content-Type: application/json');

try {
    include '../config/database.php';

    $id = $_POST['id'] ?? '';
    logDebug("ID: " . $id);

    if (empty($id)) {
        echo json_encode(["status" => "gagal", "pesan" => "ID pengguna diperlukan"]);
        exit;
    }

    if (!isset($_FILES['foto'])) {
        logDebug("FILES[foto] not set. POST size maybe too big?");
        echo json_encode(["status" => "gagal", "pesan" => "Tidak ada file yang diupload"]);
        exit;
    }

    $file = $_FILES['foto'];
    logDebug("File uploaded: " . $file['name'] . ", Size: " . $file['size'] . ", Error: " . $file['error']);

    if ($file['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(["status" => "gagal", "pesan" => "Upload Error: " . $file['error']]);
        exit;
    }

   
    if ($file['size'] > 50 * 1024 * 1024) { 
        echo json_encode(["status" => "gagal", "pesan" => "Ukuran file terlalu besar."]);
        exit;
    }

    $uploadDir = '../uploads/profil/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }

    $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
    if (empty($ext)) $ext = 'jpg';
    
    $newFileName = 'profil_' . $id . '_' . time() . '.' . $ext;
    $uploadPath = $uploadDir . $newFileName;

  
    $checkSql = "SELECT foto FROM pengguna WHERE id = ?";
    $checkStmt = $koneksi->prepare($checkSql);
    $checkStmt->bind_param("i", $id);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    if ($row = $result->fetch_assoc()) {
        if (!empty($row['foto']) && file_exists($uploadDir . $row['foto'])) {
            unlink($uploadDir . $row['foto']);
        }
    }

    if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
    
        $sql = "UPDATE pengguna SET foto = ? WHERE id = ?";
        $stmt = $koneksi->prepare($sql);
        $stmt->bind_param("si", $newFileName, $id);
        
        if ($stmt->execute()) {
            logDebug("Upload success. New file: " . $newFileName);
            echo json_encode([
                "status" => "sukses", 
                "pesan" => "Foto profil berhasil diupload",
                "foto" => $newFileName
            ]);
        } else {
            logDebug("DB Update failed");
            echo json_encode(["status" => "gagal", "pesan" => "Gagal menyimpan ke database"]);
        }
    } else {
        logDebug("move_uploaded_file failed");
        echo json_encode(["status" => "gagal", "pesan" => "Gagal mengupload file ke server"]);
    }
} catch (Exception $e) {
    logDebug("Exception: " . $e->getMessage());
    echo json_encode(["status" => "gagal", "pesan" => "Server Error: " . $e->getMessage()]);
}
?>

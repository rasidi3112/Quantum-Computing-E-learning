<?php
include 'backend/config/database.php';

$result = $koneksi->query("SELECT * FROM kategori");
echo "Jumlah Kategori: " . $result->num_rows . "\n";
while ($row = $result->fetch_assoc()) {
    echo "ID: " . $row['id'] . " - " . $row['nama_kategori'] . "\n";
}
?>

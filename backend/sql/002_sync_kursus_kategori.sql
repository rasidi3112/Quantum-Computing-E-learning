-- Script untuk memperbaiki relasi kursus ke kategori Pemula, Menengah, Lanjutan
-- Jalankan script ini di phpMyAdmin atau MySQL CLI

USE elearning_qc;

-- Hapus semua relasi lama yang mungkin merujuk ke id_kategori yang tidak valid (5, 6, dst)
DELETE FROM kursus_kategori WHERE id_kategori NOT IN (SELECT id FROM kategori);

-- Tampilkan semua kursus yang ada
SELECT id, judul, tingkat FROM kursus;

-- Hapus relasi lama untuk semua kursus
DELETE FROM kursus_kategori;

-- Insert ulang relasi berdasarkan field 'tingkat' dari masing-masing kursus
-- Kategori: Pemula (2), Menengah (3), Lanjutan (4)

-- Kursus dengan tingkat 'Pemula' -> kategori 2
INSERT INTO kursus_kategori (id_kursus, id_kategori)
SELECT id, 2 FROM kursus WHERE tingkat = 'Pemula';

-- Kursus dengan tingkat 'Menengah' -> kategori 3
INSERT INTO kursus_kategori (id_kursus, id_kategori)
SELECT id, 3 FROM kursus WHERE tingkat = 'Menengah';

-- Kursus dengan tingkat 'Lanjutan' -> kategori 4
INSERT INTO kursus_kategori (id_kursus, id_kategori)
SELECT id, 4 FROM kursus WHERE tingkat = 'Lanjutan';

-- Verifikasi hasil
SELECT 
    k.id, k.judul, k.tingkat, 
    kat.nama_kategori 
FROM kursus k 
LEFT JOIN kursus_kategori kk ON k.id = kk.id_kursus 
LEFT JOIN kategori kat ON kk.id_kategori = kat.id
ORDER BY k.tingkat, k.id;

-- Cek jumlah kursus per kategori
SELECT 
    kat.nama_kategori, 
    COUNT(kk.id_kursus) as jumlah_kursus
FROM kategori kat
LEFT JOIN kursus_kategori kk ON kat.id = kk.id_kategori
GROUP BY kat.id, kat.nama_kategori
ORDER BY kat.id;

-- Nonaktifkan pengecekan foreign key sementara untuk menghindari error saat reset
SET FOREIGN_KEY_CHECKS = 0;

-- Kosongkan tabel kategori dan kursus_kategori agar bersih
TRUNCATE TABLE kursus_kategori;
TRUNCATE TABLE kategori;

-- Aktifkan kembali pengecekan foreign key
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Masukkan HANYA 4 Kategori sesuai permintaan:
-- ID 1 Wajib 'Semua' karena di PHP logika backend (id_kategori == 1) menampilkan semua.
INSERT INTO `kategori` (`id`, `nama_kategori`) VALUES 
(1, 'Semua'),
(2, 'Pemula'),
(3, 'Menengah'),
(4, 'Lanjutan');


-- Kursus ID 2 (Quantum Gates dan Circuits) kita set sebagai 'Menengah' (ID 3)
INSERT INTO `kursus_kategori` (`id_kursus`, `id_kategori`) VALUES (2, 3);

-- Jika Anda punya kursus lain, tambahkan manual di sini.
-- Contoh: INSERT INTO kursus_kategori (id_kursus, id_kategori) VALUES (3, 4);

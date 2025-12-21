-- Database setup untuk E-Learning Quantum Computing

CREATE DATABASE IF NOT EXISTS elearning_qc;
USE elearning_qc;

-- Tabel Pengguna
CREATE TABLE IF NOT EXISTS pengguna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    kata_sandi VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Kursus
CREATE TABLE IF NOT EXISTS kursus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(200) NOT NULL,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Pelajaran
CREATE TABLE IF NOT EXISTS pelajaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_kursus INT NOT NULL,
    judul VARCHAR(200) NOT NULL,
    konten_teks TEXT,
    urutan INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_kursus) REFERENCES kursus(id) ON DELETE CASCADE
);

-- Tabel Pendaftaran
CREATE TABLE IF NOT EXISTS pendaftaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna INT NOT NULL,
    id_kursus INT NOT NULL,
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id) ON DELETE CASCADE,
    FOREIGN KEY (id_kursus) REFERENCES kursus(id) ON DELETE CASCADE
);

-- Tabel Progres
CREATE TABLE IF NOT EXISTS progres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pendaftaran INT NOT NULL,
    id_pelajaran INT NOT NULL,
    status ENUM('belum_dimulai', 'sedang_dipelajari', 'selesai') DEFAULT 'belum_dimulai',
    tanggal_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pendaftaran) REFERENCES pendaftaran(id) ON DELETE CASCADE,
    FOREIGN KEY (id_pelajaran) REFERENCES pelajaran(id) ON DELETE CASCADE
);

-- Tabel Ulasan
CREATE TABLE IF NOT EXISTS ulasan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna INT NOT NULL,
    id_kursus INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    komentar TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id) ON DELETE CASCADE,
    FOREIGN KEY (id_kursus) REFERENCES kursus(id) ON DELETE CASCADE
);

-- Insert data contoh kursus
INSERT INTO kursus (judul, deskripsi) VALUES
('Pengenalan Quantum Computing', 'Pelajari dasar-dasar quantum computing dari awal'),
('Quantum Gates dan Circuits', 'Memahami berbagai quantum gates dan cara membuat quantum circuits');

-- Insert data contoh pelajaran
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
(1, 'Apa itu Quantum Computing?', 'Quantum computing adalah bidang komputasi yang memanfaatkan fenomena mekanika kuantum seperti superposisi dan entanglement untuk melakukan komputasi.', 1),
(1, 'Qubit dan Superposisi', 'Berbeda dengan bit klasik yang bernilai 0 atau 1, qubit dapat berada dalam superposisi kedua state tersebut secara bersamaan.', 2),
(2, 'Hadamard Gate', 'Hadamard gate (H-gate) adalah salah satu gate fundamental dalam quantum computing yang menciptakan superposisi.', 1),
(2, 'CNOT Gate', 'Controlled-NOT gate adalah gate dua qubit yang melakukan operasi NOT pada qubit target jika qubit control dalam state |1⟩.', 2);

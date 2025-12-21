
USE elearning_qc;

INSERT INTO kursus (judul, deskripsi, tingkat, durasi_estimasi, warna_tema, gambar_thumbnail) VALUES

-- Kursus: Quantum Algorithms (Gambar: Abstract Math/Code)
('Quantum Algorithms', 
 'Pelajari algoritma quantum revolusioner seperti Shor''s Algorithm untuk memecahkan enkripsi RSA dan Grover''s Algorithm untuk pencarian super cepat. Kuasai quantum speedup!',
 'Lanjutan',
 240,
 '#f093fb',
 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800&h=400&fit=crop'),

-- Kursus: Quantum Machine Learning (Gambar: AI/Neural Network)
('Quantum Machine Learning',
 'Eksplorasi frontier baru: gabungan Quantum Computing dan AI. Bangun quantum neural networks, variational quantum classifiers, dan quantum generative models.',
 'Lanjutan',
 300,
 '#4facfe',
 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&h=400&fit=crop'),

-- Kursus: Quantum Cryptography (Gambar: Security/Lock)
('Quantum Cryptography & Security',
 'Kuasai enkripsi yang tidak dapat dipecahkan! Pelajari Quantum Key Distribution (QKD), BB84 Protocol, dan masa depan keamanan siber dengan quantum.',
 'Menengah',
 180,
 '#43e97b',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&h=400&fit=crop'),

-- Kursus: Quantum Error Correction (Gambar: Circuit/Technology)
('Quantum Error Correction',
 'Tantangan terbesar quantum computing: mengatasi dekoherensi dan noise. Pelajari Surface Codes, Stabilizer Codes, dan Fault-tolerant Quantum Computing.',
 'Lanjutan',
 270,
 '#fa709a',
 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&h=400&fit=crop'),

-- Kursus: Praktikum Qiskit IBM (Gambar: Coding/Programming)
('Praktikum Qiskit IBM',
 'Hands-on programming dengan Qiskit dari IBM! Buat quantum circuits, jalankan di simulator, dan akses IBM Quantum Experience untuk real quantum computers.',
 'Menengah',
 200,
 '#30cfd0',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&h=400&fit=crop'),

-- Kursus: Quantum Hardware (Gambar: Hardware/Chip)
('Arsitektur Quantum Hardware',
 'Pelajari berbagai teknologi quantum hardware: Superconducting Qubits (IBM, Google), Trapped Ions (IonQ), Photonic Quantum (Xanadu), dan Topological Qubits (Microsoft).',
 'Pemula',
 150,
 '#fdbb2d',
 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=800&h=400&fit=crop'),

-- Kursus: Quantum Simulation (Gambar: Molecules/Chemistry)
('Quantum Simulation & Chemistry',
 'Aplikasi quantum computing untuk simulasi molekul, drug discovery, dan material science. Pelajari VQE (Variational Quantum Eigensolver) untuk chemistry.',
 'Menengah',
 180,
 '#a8edea',
 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=800&h=400&fit=crop'),

-- Kursus: Quantum Networking (Gambar: Network/Connection)
('Quantum Internet & Networking',
 'Masa depan internet: Quantum Internet! Pelajari quantum entanglement distribution, quantum repeaters, dan arsitektur jaringan quantum.',
 'Lanjutan',
 220,
 '#667eea',
 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&h=400&fit=crop'),

-- Kursus: Quantum Finance (Gambar: Finance/Charts)
('Quantum Computing for Finance',
 'Aplikasi quantum di industri keuangan: portfolio optimization, risk analysis, Monte Carlo simulations, dan fraud detection dengan quantum advantage.',
 'Menengah',
 160,
 '#ee9ca7',
 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&h=400&fit=crop');

-- ============================================
-- PELAJARAN UNTUK KURSUS BARU
-- ============================================

-- Pelajaran untuk Quantum Algorithms
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 
 'Introduction to Quantum Speedup', 
 'Quantum computers dapat menyelesaikan masalah tertentu secara eksponensial lebih cepat dibanding komputer klasik. Dalam pelajaran ini, kita akan mempelajari konsep dasar quantum parallelism dan bagaimana superposisi memungkinkan komputasi paralel secara alami apply dengan fenomena mekanika kuantum.', 1),
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 
 'Deutsch-Jozsa Algorithm', 
 'Algoritma Deutsch-Jozsa adalah bukti pertama quantum speedup. Algoritma ini dapat menentukan apakah suatu fungsi adalah constant atau balanced hanya dengan satu query, sementara komputer klasik membutuhkan hingga 2^(n-1)+1 queries. Kita akan memahami oracle dan quantum parallelism secara mendalam.', 2),
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 
 'Grover Search Algorithm', 
 'Algoritma Grover memberikan speedup kuadratik untuk pencarian dalam database unsorted: O(√N) vs O(N) pada komputer klasik. Kita akan mempelajari implementasi step-by-step termasuk amplitude amplification dan oracle marking.', 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 
 'Shor Factoring Algorithm', 
 'Algoritma Shor dapat memfaktorkan bilangan besar secara eksponensial lebih cepat, mengancam keamanan RSA dan enkripsi modern. Pelajaran ini mencakup Quantum Fourier Transform dan order-finding sebagai inti algoritma.', 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 
 'Quantum Phase Estimation', 
 'Quantum Phase Estimation adalah teknik fundamental yang menjadi basis banyak quantum algorithms termasuk Shor algorithm dan variational quantum eigensolver untuk quantum chemistry.', 5);

-- Pelajaran untuk Quantum Machine Learning
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 
 'Quantum Computing meets AI', 
 'Mengapa quantum computing bisa mempercepat machine learning? Eksplorasi quantum advantage dalam AI meliputi exponential state space, quantum interference untuk optimization, dan quantum sampling.', 1),
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 
 'Variational Quantum Circuits', 
 'Parameterized quantum circuits (PQC) adalah foundation quantum ML. Kita akan mempelajari cara mendesain ansatz, training dengan classical optimizers seperti COBYLA dan SPSA, serta menghindari barren plateaus.', 2),
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 
 'Quantum Neural Networks', 
 'Membangun neural networks dengan quantum layers. Hybrid classical-quantum architectures menggabungkan kekuatan deep learning dengan quantum processing untuk feature extraction dan classification.', 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 
 'Quantum Classification', 
 'Quantum kernel methods untuk classification problems. Pelajari quantum feature maps, kernel tricks dengan quantum computers, dan quantum support vector machines.', 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 
 'Quantum Generative Models', 
 'Quantum GANs dan Quantum Boltzmann Machines untuk generative modeling. Eksplorasi bagaimana quantum computers dapat menghasilkan data sintetis dan sampling dari distribusi kompleks.', 5);

-- Pelajaran untuk Quantum Cryptography
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Cryptography & Security'), 
 'Quantum Threat to Modern Cryptography', 
 'Bagaimana quantum computers mengancam enkripsi modern: RSA dapat dipecahkan dengan Shor algorithm, ECC juga vulnerable, dan symmetric encryption memerlukan key doubling. Kita akan memahami timeline ancaman quantum.', 1),
((SELECT id FROM kursus WHERE judul = 'Quantum Cryptography & Security'), 
 'BB84 Protocol Deep Dive', 
 'Protokol Quantum Key Distribution pertama oleh Bennett dan Brassard tahun 1984. BB84 menggunakan polarisasi foton dan ketidakpastian Heisenberg untuk menjamin security yang unconditional.', 2),
((SELECT id FROM kursus WHERE judul = 'Quantum Cryptography & Security'), 
 'Quantum Key Distribution Systems', 
 'Berbagai protokol QKD modern: E91 berbasis entanglement, B92 simplified protocol, SARG04 untuk noisy channels. Kita juga membahas implementasi komersial dan deployment challenges.', 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Cryptography & Security'), 
 'Post-Quantum Cryptography', 
 'Algoritma klasik yang tahan terhadap serangan kuantum: Lattice-based (CRYSTALS-Kyber), Hash-based (SPHINCS+), dan Code-based cryptography. NIST standardization dan migration strategies.', 4);

-- Pelajaran untuk Praktikum Qiskit
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 
 'Setup Qiskit Environment', 
 'Instalasi Qiskit menggunakan pip, setup IBM Quantum Experience account untuk akses ke real quantum computers, dan membuat first quantum circuit dengan QuantumCircuit class.', 1),
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 
 'Quantum Circuit Fundamentals', 
 'Membuat quantum circuits: inisialisasi qubits, menerapkan single-qubit gates (X, Y, Z, H) dan multi-qubit gates (CNOT, CZ), serta measurement. Visualisasi dengan circuit.draw().', 2),
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 
 'Simulation with Qiskit Aer', 
 'Execute circuits pada Qiskit Aer simulator. Pelajari statevector simulator untuk exact simulation, qasm simulator untuk shot-based simulation, dan noise models untuk realistic modeling.', 3),
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 
 'Running on IBM Quantum Hardware', 
 'Submit jobs ke IBM Quantum computers menggunakan Qiskit Runtime. Understanding queue system, device calibration data, error rates, dan best practices untuk hardware execution.', 4),
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 
 'Building Complete Quantum Applications', 
 'Membuat aplikasi quantum end-to-end: dari problem formulation, circuit design, execution strategy, result interpretation, hingga production deployment dengan Qiskit Runtime.', 5);

-- Pelajaran untuk Quantum Hardware
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Arsitektur Quantum Hardware'), 
 'Physics of Qubits', 
 'Fisika di balik qubit: bagaimana two-level quantum systems encode information, superposition sebagai linear combination of states, dan entanglement sebagai quantum correlation.', 1),
((SELECT id FROM kursus WHERE judul = 'Arsitektur Quantum Hardware'), 
 'Superconducting Quantum Computers', 
 'Teknologi IBM dan Google: transmon qubits berbasis Josephson junctions, dilution refrigerators untuk cooling ke 15 milikelvin, dan microwave pulses untuk gate control.', 2),
((SELECT id FROM kursus WHERE judul = 'Arsitektur Quantum Hardware'), 
 'Trapped Ion Quantum Computers', 
 'Teknologi IonQ dan Quantinuum: laser cooling untuk trap ions, electromagnetic traps untuk confinement, dan laser pulses untuk high-fidelity gates dengan coherence time panjang.', 3),
((SELECT id FROM kursus WHERE judul = 'Arsitektur Quantum Hardware'), 
 'Alternative Quantum Technologies', 
 'Pendekatan lain: Xanadu photonic qubits menggunakan light, Microsoft topological qubits untuk error protection, neutral atom arrays dari Atom Computing, dan diamond NV centers.', 4);

-- Pelajaran untuk Quantum Finance
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Computing for Finance'), 
 'Quantum Advantage in Financial Services', 
 'Use cases quantum computing di industri keuangan: computational speedup untuk optimization, accuracy improvement untuk risk modeling, dan new capabilities untuk portfolio construction.', 1),
((SELECT id FROM kursus WHERE judul = 'Quantum Computing for Finance'), 
 'Portfolio Optimization with QAOA', 
 'QAOA dan VQE untuk portfolio optimization. Formulating portfolio selection sebagai quadratic unconstrained binary optimization (QUBO) dan solving dengan variational algorithms.', 2),
((SELECT id FROM kursus WHERE judul = 'Quantum Computing for Finance'), 
 'Quantum Monte Carlo Methods', 
 'Risk analysis dan derivative pricing dengan quantum amplitude estimation. Achieving quadratic speedup untuk Monte Carlo simulations yang critical untuk options pricing.', 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Computing for Finance'), 
 'Fraud Detection with Quantum ML', 
 'Quantum machine learning untuk anomaly detection dan fraud prevention. Quantum kernels untuk pattern recognition dalam transaction data dengan potential quantum advantage.', 4);

INSERT INTO kursus_kategori (id_kursus, id_kategori) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Algorithms'), 5),
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Machine Learning'), 6),
((SELECT id FROM kursus WHERE judul = 'Quantum Cryptography & Security'), 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Cryptography & Security'), 5),
((SELECT id FROM kursus WHERE judul = 'Quantum Error Correction'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Error Correction'), 5),
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 3),
((SELECT id FROM kursus WHERE judul = 'Praktikum Qiskit IBM'), 6),
((SELECT id FROM kursus WHERE judul = 'Arsitektur Quantum Hardware'), 2),
((SELECT id FROM kursus WHERE judul = 'Arsitektur Quantum Hardware'), 5),
((SELECT id FROM kursus WHERE judul = 'Quantum Simulation & Chemistry'), 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Simulation & Chemistry'), 6),
((SELECT id FROM kursus WHERE judul = 'Quantum Internet & Networking'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Internet & Networking'), 5),
((SELECT id FROM kursus WHERE judul = 'Quantum Computing for Finance'), 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Computing for Finance'), 6);

SELECT id, judul, tingkat, gambar_thumbnail FROM kursus ORDER BY id;
SELECT COUNT(*) as total_kursus FROM kursus;
SELECT COUNT(*) as total_pelajaran FROM pelajaran;

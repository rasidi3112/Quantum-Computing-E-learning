-- ============================================
-- KURSUS QUANTUM COMPUTING CUTTING-EDGE 2025
-- Platform E-Learning Terdepan di Dunia
-- ============================================

USE elearning_qc;

-- ============================================
-- KURSUS BARU: CUTTING-EDGE & PROFESSIONAL
-- ============================================

INSERT INTO kursus (judul, deskripsi, tingkat, durasi_estimasi, warna_tema, gambar_thumbnail) VALUES

-- 1. Quantum Computing Fundamentals (PEMULA)
('Quantum Computing Fundamentals',
 'Perjalanan komprehensif ke dunia quantum computing dari nol. Pelajari konsep qubit, superposisi, entanglement, dan quantum gates dengan pendekatan visual dan intuitif. Cocok untuk pemula yang ingin memahami revolusi komputasi masa depan tanpa latar belakang fisika yang mendalam.',
 'Pemula',
 180,
 '#6366f1',
 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800&h=400&fit=crop'),

-- 2. Quantum Programming with Cirq (Google)
('Quantum Programming with Cirq',
 'Master Google Cirq framework untuk quantum programming! Bangun quantum circuits, implementasi quantum algorithms, dan jalankan eksperimen di Google Quantum AI. Termasuk akses ke Sycamore processor simulation.',
 'Menengah',
 220,
 '#10b981',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=400&fit=crop'),

-- 3. Quantum Optimization & QAOA
('Quantum Optimization & QAOA',
 'Deep dive ke Quantum Approximate Optimization Algorithm (QAOA) dan variational quantum algorithms. Selesaikan complex optimization problems seperti MaxCut, Traveling Salesman, dan Job Scheduling dengan quantum advantage.',
 'Lanjutan',
 280,
 '#f59e0b',
 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800&h=400&fit=crop'),

-- 4. Quantum Sensing & Metrology
('Quantum Sensing & Metrology',
 'Teknologi quantum sensing terdepan untuk pengukuran ultra-presisi. Pelajari atomic clocks, quantum magnetometers, gravitational wave detection, dan aplikasi di medical imaging serta navigation systems.',
 'Lanjutan',
 240,
 '#ec4899',
 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop'),

-- 5. Topological Quantum Computing
('Topological Quantum Computing',
 'Pendekatan Microsoft untuk fault-tolerant quantum computing menggunakan topological qubits dan Majorana fermions. Pelajari braiding operations, anyons, dan mengapa topological protection adalah masa depan quantum computing.',
 'Lanjutan',
 300,
 '#8b5cf6',
 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=800&h=400&fit=crop'),

-- 6. Quantum Biology & Life Sciences
('Quantum Biology & Life Sciences',
 'Eksplorasi peran quantum mechanics dalam biologi: photosynthesis, enzyme catalysis, avian navigation, dan olfaction. Understand bagaimana quantum effects drive fundamental biological processes.',
 'Menengah',
 200,
 '#14b8a6',
 'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800&h=400&fit=crop'),

-- 7. Quantum Cloud Computing Platforms
('Quantum Cloud Computing Platforms',
 'Hands-on dengan semua major quantum cloud platforms: IBM Quantum, Amazon Braket, Azure Quantum, dan Google Quantum AI. Bandingkan hardware, pricing, dan use cases untuk enterprise deployment.',
 'Menengah',
 160,
 '#0ea5e9',
 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=800&h=400&fit=crop'),

-- 8. Quantum-Classical Hybrid Systems
('Quantum-Classical Hybrid Systems',
 'Arsitektur hybrid quantum-classical computing untuk near-term applications. Pelajari variational algorithms, classical-quantum feedback loops, dan optimization of hybrid workflows untuk maximum quantum advantage.',
 'Lanjutan',
 260,
 '#f97316',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&h=400&fit=crop'),

-- 9. Quantum Ethics & Society
('Quantum Ethics & Society',
 'Implikasi sosial, etika, dan regulasi quantum computing. Diskusi tentang quantum supremacy claims, responsible development, workforce preparation, dan global quantum race. Essential untuk leaders dan policymakers.',
 'Pemula',
 120,
 '#84cc16',
 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop'),

-- 10. Advanced Quantum Algorithms
('Advanced Quantum Algorithms',
 'Algoritma quantum state-of-the-art: HHL untuk linear systems, quantum walks, adiabatic quantum computing, dan quantum annealing. Includes implementasi praktis dan complexity analysis mendalam.',
 'Lanjutan',
 320,
 '#dc2626',
 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800&h=400&fit=crop');

-- ============================================
-- PELAJARAN DENGAN KONTEN LENGKAP & PANJANG
-- ============================================

-- PELAJARAN: Quantum Computing Fundamentals
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Computing Fundamentals'),
 'Apa itu Quantum Computing?',
 'Quantum computing adalah paradigma baru dalam komputasi yang memanfaatkan prinsip-prinsip mekanika kuantum untuk memproses informasi dengan cara yang fundamentally berbeda dari komputer klasik. 

Berbeda dengan komputer tradisional yang menggunakan bit (0 atau 1), quantum computer menggunakan qubit yang dapat berada dalam superposisi - keadaan di mana nilai 0 dan 1 exist secara simultan. Bayangkan sebuah koin yang sedang berputar di udara: sebelum mendarat, koin tersebut bukanlah heads atau tails, melainkan probabilistic combination dari keduanya.

Sejarah quantum computing dimulai pada tahun 1980-an ketika Richard Feynman mengusulkan ide menggunakan sistem kuantum untuk mensimulasikan fenomena kuantum lainnya. David Deutsch kemudian memformulasikan konsep universal quantum computer pada 1985. Sejak saat itu, field ini berkembang pesat dengan kontribusi dari Peter Shor (algoritma faktorisasi), Lov Grover (algoritma pencarian), dan banyak ilmuwan lainnya.

Komputer kuantum modern dikembangkan oleh perusahaan-perusahaan terkemuka dunia: IBM dengan sistem Eagle dan Condor (1000+ qubits), Google dengan Sycamore yang mencapai quantum supremacy pada 2019, IonQ dengan trapped-ion technology, dan Rigetti dengan superconducting qubits. Perkembangan ini membawa kita ke era NISQ (Noisy Intermediate-Scale Quantum) di mana quantum computers mulai menunjukkan practical advantage untuk aplikasi tertentu.

Mengapa ini penting? Quantum computers berpotensi merevolusi berbagai bidang: drug discovery melalui simulasi molekul yang akurat, financial modeling dengan optimisasi portfolio yang lebih baik, cryptography dengan sistem yang lebih aman, materials science untuk superconductor discovery, dan artificial intelligence dengan quantum machine learning.',
 1),

((SELECT id FROM kursus WHERE judul = 'Quantum Computing Fundamentals'),
 'Qubit: Unit Dasar Quantum Information',
 'Qubit (quantum bit) adalah unit fundamental dari quantum information, analog dengan bit dalam komputasi klasik namun dengan properti yang jauh lebih powerful. Memahami qubit adalah kunci untuk menguasai quantum computing.

REPRESENTASI MATEMATIS QUBIT:
Sebuah qubit dapat direpresentasikan sebagai: |ψ⟩ = α|0⟩ + β|1⟩, di mana α dan β adalah complex numbers (amplitudes) yang memenuhi |α|² + |β|² = 1. Notasi |0⟩ dan |1⟩ disebut basis states atau computational basis.

Secara geometris, state qubit dapat divisualisasikan pada Bloch sphere - sebuah bola dengan radius 1 di mana setiap titik pada permukaan merepresentasikan valid quantum state. North pole adalah |0⟩, south pole adalah |1⟩, dan semua titik lainnya adalah superposisi.

SUPERPOSISI:
Superposisi adalah kemampuan qubit untuk berada dalam kombinasi linear dari |0⟩ dan |1⟩ secara simultan. Ini bukan berarti qubit "kadang 0 kadang 1" - melainkan truly exists in both states until measured. Saat kita mengukur qubit dalam superposisi, hasilnya probabilistic: probability mendapat |0⟩ adalah |α|² dan probability mendapat |1⟩ adalah |β|².

IMPLEMENTASI FISIK:
Berbagai teknologi dapat mengimplementasikan qubit:
• Superconducting qubits: Menggunakan Josephson junctions yang didinginkan hingga ~15 millikelvin (IBM, Google)
• Trapped ions: Atom bermuatan yang dikurung dengan electromagnetic fields (IonQ, Quantinuum)
• Photonic qubits: Menggunakan polarisasi atau path of photons (Xanadu, PsiQuantum)
• Spin qubits: Electron spin dalam quantum dots (Intel, Silicon Quantum Computing)
• Neutral atoms: Atoms trapped dengan optical tweezers (Atom Computing, QuEra)

Setiap implementasi memiliki trade-offs antara coherence time, gate fidelity, connectivity, dan scalability.',
 2),

((SELECT id FROM kursus WHERE judul = 'Quantum Computing Fundamentals'),
 'Quantum Entanglement: Koneksi Misterius',
 'Quantum entanglement adalah fenomena di mana dua atau lebih partikel menjadi correlated sedemikian rupa sehingga state satu partikel tidak dapat dideskripsikan independen dari yang lain - bahkan ketika terpisah jarak yang sangat jauh. Einstein menyebutnya "spooky action at a distance."

BELL STATES:
Contoh paling sederhana dari entanglement adalah Bell states, empat maximally entangled states untuk dua qubits:
|Φ+⟩ = (1/√2)(|00⟩ + |11⟩) - Jika qubit pertama diukur 0, qubit kedua pasti 0
|Φ-⟩ = (1/√2)(|00⟩ - |11⟩) - Sama dengan Φ+ tapi dengan phase berbeda
|Ψ+⟩ = (1/√2)(|01⟩ + |10⟩) - Jika qubit pertama 0, kedua pasti 1, dan sebaliknya
|Ψ-⟩ = (1/√2)(|01⟩ - |10⟩) - Anti-correlated dengan phase berbeda

MEMBUAT ENTANGLEMENT:
Entanglement dapat dibuat dengan mengaplikasikan Hadamard gate pada qubit pertama (menciptakan superposisi), kemudian CNOT gate dengan qubit pertama sebagai control dan kedua sebagai target. Circuit ini menghasilkan Bell state |Φ+⟩.

EKSPERIMEN BELL:
John Bell pada 1964 merumuskan Bell inequalities yang memungkinkan pengujian eksperimental apakah entanglement benar-benar non-local atau dapat dijelaskan dengan hidden variables. Eksperimen oleh Alain Aspect (1982) dan banyak eksperimen sesudahnya membuktikan bahwa quantum mechanics benar: correlations from entanglement tidak dapat dijelaskan oleh classical hidden variable theories.

APLIKASI ENTANGLEMENT:
• Quantum teleportation: Transfer quantum state tanpa physical transmission
• Superdense coding: Mengirim 2 classical bits menggunakan 1 qubit
• Quantum cryptography: Membuat encryption keys yang provably secure
• Quantum computing: Enabling exponential speedup untuk certain algorithms
• Quantum sensing: Enhanced measurement precision beyond classical limits',
 3),

((SELECT id FROM kursus WHERE judul = 'Quantum Computing Fundamentals'),
 'Quantum Gates: Memanipulasi Qubits',
 'Quantum gates adalah operasi dasar yang memanipulasi state qubit, analog dengan logic gates (AND, OR, NOT) dalam classical computing. Namun, quantum gates memiliki properti penting: mereka harus unitary (reversible dan preserve probability).

SINGLE-QUBIT GATES:

Pauli Gates:
• X Gate (NOT): Membalik |0⟩ ↔ |1⟩, seperti classical NOT
• Y Gate: Kombinasi bit dan phase flip
• Z Gate: Phase flip, |0⟩ → |0⟩, |1⟩ → -|1⟩

Hadamard Gate (H):
Gate paling penting! Menciptakan superposisi dari basis states:
H|0⟩ = (1/√2)(|0⟩ + |1⟩)
H|1⟩ = (1/√2)(|0⟩ - |1⟩)

Phase Gates:
• S Gate: Quarter turn (π/2 phase)
• T Gate: Eighth turn (π/4 phase) - penting untuk universal quantum computing

Rotation Gates:
• Rx(θ): Rotasi sekitar X-axis pada Bloch sphere
• Ry(θ): Rotasi sekitar Y-axis
• Rz(θ): Rotasi sekitar Z-axis

MULTI-QUBIT GATES:

CNOT (Controlled-NOT):
Gate dua-qubit fundamental. Jika control qubit = |1⟩, flip target qubit.
Essential untuk creating entanglement.

CZ (Controlled-Z):
Jika kedua qubits = |1⟩, apply phase flip.

SWAP:
Exchange states of two qubits.

Toffoli (CCNOT):
Three-qubit gate: flip target only if both controls = |1⟩.
Universal for classical computation.

FREDKIN (CSWAP):
Controlled swap of two target qubits.

UNIVERSALITAS:
Dengan set gates {H, T, CNOT}, kita dapat approximate any unitary operation dengan arbitrary precision. Ini disebut universal gate set.',
 4),

((SELECT id FROM kursus WHERE judul = 'Quantum Computing Fundamentals'),
 'Quantum Measurement: Kolapsnya Superposisi',
 'Measurement dalam quantum computing adalah proses fundamental yang mengekstrak informasi klasik dari quantum system. Namun, measurement juga "menghancurkan" superposisi - ini adalah salah satu aspek paling counter-intuitive dari quantum mechanics.

POSTULAT MEASUREMENT:
Ketika kita mengukur qubit dalam superposisi |ψ⟩ = α|0⟩ + β|1⟩:
• Probability mendapat hasil 0: P(0) = |α|²
• Probability mendapat hasil 1: P(1) = |β|²
• Setelah measurement, qubit "collapse" ke state yang corresponding dengan hasil (|0⟩ atau |1⟩)

MENGAPA MEASUREMENT DESTRUCTIVE?
Measurement forces the system to "choose" one definite state, menghapus informasi tentang superposisi original. Ini mengapa quantum algorithms harus carefully designed: kita tidak bisa simply "peek" at intermediate states tanpa disturbing computation.

DIFFERENT MEASUREMENT BASES:
Standard measurement adalah dalam computational basis (Z-basis). Namun kita bisa juga measure dalam:
• X-basis: |+⟩ = (|0⟩+|1⟩)/√2 dan |-⟩ = (|0⟩-|1⟩)/√2
• Y-basis: |i⟩ dan |-i⟩ states
• Arbitrary basis dengan proper rotation sebelum measurement

PARTIAL MEASUREMENT:
Dalam multi-qubit systems, kita bisa measure sebagian qubits saja. Measurement pada satu qubit akan collapse keseluruhan entangled state secara consistent.

QUANTUM ZENO EFFECT:
Frequent measurements dapat "freeze" evolution of quantum system. Ini karena setiap measurement resets state, tidak memberikan waktu untuk evolve significantly.

WEAK MEASUREMENT:
Teknik lanjutan yang extract partial information dengan minimal disturbance. Useful untuk quantum error correction dan quantum feedback control.',
 5);

-- PELAJARAN: Quantum Programming with Cirq
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Programming with Cirq'),
 'Introduction to Google Cirq',
 'Cirq adalah open-source Python framework dari Google untuk menulis, memanipulasi, dan mengeksekusi quantum circuits. Dirancang dengan fokus pada NISQ (Noisy Intermediate-Scale Quantum) algorithms dan tight integration dengan Google quantum hardware.

MENGAPA CIRQ?
• Native support untuk Google quantum processors (Sycamore, Weber)
• Noise simulation yang realistic
• Flexible circuit manipulation
• Integration dengan TensorFlow Quantum untuk quantum ML
• Active development dan strong community

INSTALASI:
pip install cirq
# Untuk Google Cloud integration:
pip install cirq-google

KONSEP DASAR CIRQ:
1. Qubits: cirq.LineQubit, cirq.GridQubit, cirq.NamedQubit
2. Gates: cirq.H, cirq.CNOT, cirq.measure
3. Operations: Gate applied to qubits
4. Moments: Operations that happen simultaneously
5. Circuits: Sequence of moments

FIRST CIRCUIT:
import cirq

# Create qubits
q0, q1 = cirq.LineQubit.range(2)

# Build circuit
circuit = cirq.Circuit([
    cirq.H(q0),           # Hadamard on q0
    cirq.CNOT(q0, q1),    # CNOT with q0 as control
    cirq.measure(q0, q1, key="result")
])

# Simulate
simulator = cirq.Simulator()
result = simulator.run(circuit, repetitions=1000)

print(circuit)
print(result.histogram(key="result"))

Ini akan print Bell state measurement results: roughly 500x "00" dan 500x "11".',
 1),

((SELECT id FROM kursus WHERE judul = 'Quantum Programming with Cirq'),
 'Advanced Circuit Construction',
 'Cirq menyediakan powerful tools untuk constructing complex quantum circuits dengan control yang granular. Mari explore teknik-teknik advanced.

PARAMETERIZED CIRCUITS:
import cirq
import sympy

theta = sympy.Symbol("theta")
q = cirq.LineQubit(0)

circuit = cirq.Circuit([
    cirq.rx(theta)(q),
    cirq.measure(q, key="m")
])

# Resolve parameter
resolver = cirq.ParamResolver({"theta": 0.5})
result = cirq.Simulator().run(circuit, resolver, repetitions=100)

CIRCUIT TRANSFORMERS:
# Decompose complex gates
decomposed = cirq.decompose(circuit)

# Merge single-qubit gates
merged = cirq.merge_single_qubit_gates_to_phased_x_and_z(circuit)

# Align to moments
aligned = cirq.align_left(circuit)

# Drop empty moments
cleaned = cirq.drop_empty_moments(circuit)

CUSTOM GATES:
class MyGate(cirq.Gate):
    def _num_qubits_(self):
        return 2
    
    def _unitary_(self):
        return np.array([[1,0,0,0],
                        [0,1,0,0],
                        [0,0,0,1],
                        [0,0,1,0]])
    
    def _circuit_diagram_info_(self, args):
        return ["MY", "GATE"]

SUBCIRCUITS & FREEZING:
# Create reusable subcircuit
qft = cirq.QuantumFourierTransformGate(3)

# Freeze circuit (immutable, faster simulation)
frozen = cirq.FrozenCircuit(circuit)

NOISE INSERTION:
noisy_circuit = circuit.with_noise(cirq.depolarize(p=0.01))
',
 2),

((SELECT id FROM kursus WHERE judul = 'Quantum Programming with Cirq'),
 'Simulation & Noise Modeling',
 'Cirq provides multiple simulators dengan berbagai trade-offs antara speed, accuracy, dan features. Understanding these options adalah crucial untuk effective quantum development.

SIMULATOR TYPES:

1. State Vector Simulator (cirq.Simulator):
• Tracks full quantum state exactly
• Exponential memory: 2^n complex amplitudes
• Best for: Small circuits, debugging, exact results

result = cirq.Simulator().simulate(circuit)
print(result.final_state_vector)

2. Density Matrix Simulator (cirq.DensityMatrixSimulator):
• Tracks mixed states (essential for noise simulation)
• Memory: 4^n (density matrix is 2^n × 2^n)
• Best for: Noisy simulation, decoherence studies

result = cirq.DensityMatrixSimulator().simulate(circuit)
print(result.final_density_matrix)

3. Clifford Simulator:
• Only works for Clifford circuits (H, S, CNOT, Pauli)
• Polynomial time simulation!
• Best for: Error correction, stabilizer circuits

NOISE MODELS:
# Depolarizing noise
cirq.depolarize(p=0.01)  # Random Pauli with prob p

# Amplitude damping (T1 decay)
cirq.amplitude_damp(gamma=0.01)

# Phase damping (T2 dephasing)
cirq.phase_damp(gamma=0.01)

# Realistic device noise
google_noise = cirq_google.engine.load_median_device_calibration("weber")
noisy_sim = cirq.DensityMatrixSimulator(noise=google_noise)

VALIDATION TECHNIQUES:
# Compute fidelity
fidelity = cirq.fidelity(state1, state2)

# Tomography for characterization
from cirq.experiments import state_tomography
tomography_result = state_tomography(circuit, qubits, sampler, repetitions=1000)',
 3);

-- PELAJARAN: Quantum Optimization & QAOA
INSERT INTO pelajaran (id_kursus, judul, konten_teks, urutan) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Optimization & QAOA'),
 'Introduction to Combinatorial Optimization',
 'Combinatorial optimization adalah class of problems di mana kita mencari solusi optimal dari finite set of possibilities. Meskipun finite, jumlah possibilities seringkali eksponensial, membuat brute-force search impractical.

CONTOH MASALAH:
1. Traveling Salesman Problem (TSP): Shortest route visiting all cities exactly once
2. MaxCut: Partition graph vertices to maximize edges cut
3. Graph Coloring: Minimum colors to color graph with no adjacent same-color vertices
4. Knapsack: Maximum value items fitting weight constraint
5. Job Shop Scheduling: Minimize total time for jobs on machines

NP-HARD PROBLEMS:
Banyak combinatorial optimization problems adalah NP-hard, artinya:
• No known polynomial-time algorithm exists
• Solutions can be verified quickly
• All NP problems can be reduced to them

QUANTUM PROMISE:
Quantum computers menawarkan potential advantages:
• Quadratic speedup via Grovers algorithm (for unstructured search)
• Potential exponential speedup untuk specific problem structures
• Heuristic approaches (QAOA, VQE) yang may outperform classical heuristics

QUBO FORMULATION:
Quantum Unconstrained Binary Optimization adalah framework untuk encoding optimization problems:

minimize: x^T Q x + c^T x

di mana x adalah binary vector, Q adalah coefficient matrix, dan c adalah linear coefficients.

Hampir semua combinatorial problems dapat di-encode sebagai QUBO, making it universal formulation untuk quantum optimization. QUBO naturally maps to Ising model hamiltonians yang dapat diselesaikan dengan quantum annealing atau variational algorithms.',
 1),

((SELECT id FROM kursus WHERE judul = 'Quantum Optimization & QAOA'),
 'QAOA: Quantum Approximate Optimization Algorithm',
 'QAOA adalah hybrid quantum-classical algorithm yang didesain untuk solving combinatorial optimization problems pada NISQ devices. Dikembangkan oleh Farhi, Goldstone, dan Gutmann pada 2014.

STRUKTUR QAOA:
1. Encode problem sebagai cost Hamiltonian H_C
2. Define mixer Hamiltonian H_M (typically Σ X_i)
3. Prepare initial state |+⟩^⊗n
4. Apply p layers of:
   • e^(-iγ H_C): Cost evolution
   • e^(-iβ H_M): Mixer evolution
5. Measure in computational basis
6. Classically optimize γ, β parameters

COST HAMILTONIAN:
Untuk MaxCut problem pada graph G=(V,E):
H_C = Σ_{(i,j)∈E} (1 - Z_i Z_j) / 2

Edge (i,j) contributes 1 jika i dan j dalam different partitions (cut), 0 otherwise.

IMPLEMENTASI DENGAN CIRQ:
import cirq
import numpy as np
from scipy.optimize import minimize

def qaoa_circuit(graph, gamma, beta, qubits):
    circuit = cirq.Circuit()
    
    # Initial superposition
    circuit.append(cirq.H.on_each(*qubits))
    
    # Cost layer
    for edge in graph.edges():
        i, j = edge
        circuit.append(cirq.ZZ(qubits[i], qubits[j])**(-gamma/np.pi))
    
    # Mixer layer  
    for q in qubits:
        circuit.append(cirq.rx(2*beta)(q))
    
    return circuit

# Classical optimization loop
def objective(params, graph, qubits, reps=1000):
    gamma, beta = params
    circuit = qaoa_circuit(graph, gamma, beta, qubits)
    circuit.append(cirq.measure(*qubits, key="m"))
    
    result = cirq.Simulator().run(circuit, repetitions=reps)
    # Compute expected cost from measurement results
    ...

result = minimize(objective, x0=[0.5, 0.5], method="COBYLA")

DEPTH vs APPROXIMATION:
• p=1: Guaranteed approximation ratio depends on graph structure
• Higher p: Better approximation but deeper circuit (more noise)
• p → ∞: Converges to adiabatic quantum computing (exact solution)',
 2);

-- ============================================
-- UPDATE KURSUS_KATEGORI
-- ============================================
INSERT INTO kursus_kategori (id_kursus, id_kategori) VALUES
((SELECT id FROM kursus WHERE judul = 'Quantum Computing Fundamentals'), 2),
((SELECT id FROM kursus WHERE judul = 'Quantum Programming with Cirq'), 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Optimization & QAOA'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Sensing & Metrology'), 4),
((SELECT id FROM kursus WHERE judul = 'Topological Quantum Computing'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Biology & Life Sciences'), 3),
((SELECT id FROM kursus WHERE judul = 'Quantum Cloud Computing Platforms'), 3),
((SELECT id FROM kursus WHERE judul = 'Quantum-Classical Hybrid Systems'), 4),
((SELECT id FROM kursus WHERE judul = 'Quantum Ethics & Society'), 2),
((SELECT id FROM kursus WHERE judul = 'Advanced Quantum Algorithms'), 4);

-- Verification queries
SELECT '=== KURSUS BARU ===' as info;
SELECT id, judul, tingkat FROM kursus ORDER BY id DESC LIMIT 10;
SELECT '=== STATISTIK ===' as info;
SELECT COUNT(*) as total_kursus FROM kursus;
SELECT COUNT(*) as total_pelajaran FROM pelajaran;
SELECT tingkat, COUNT(*) as jumlah FROM kursus GROUP BY tingkat;

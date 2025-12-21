import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_notification.dart';
import 'lesson_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> kursus;
  final dynamic userData;
  const CourseDetailScreen({super.key, required this.kursus, this.userData});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> pelajaran = [];
  List<dynamic> ulasan = [];
  bool loading = true;
  bool loadingUlasan = true;
  bool isEnrolled = false;
  bool enrollmentLoading = false;
  int selectedRating = 5;
  int idPendaftaran = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPelajaran();
    _loadUlasan();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPelajaran() async {
    try {
      final id = int.tryParse(widget.kursus['id'].toString()) ?? 0;
      final userData = widget.userData as Map<String, dynamic>?;
      final idPengguna = int.tryParse(userData?['id']?.toString() ?? '0') ?? 0;

      final results = await Future.wait([
        ApiService.getPelajaran(id),
        ApiService.cekStatusPendaftaran(idPengguna, id),
      ]);

      if (mounted) {
        setState(() {
          pelajaran = results[0] as List<dynamic>;
          final statusData = results[1] as Map<String, dynamic>;
          isEnrolled = statusData['status'] == 'terdaftar';

          // Capture ID Pendaftaran
          if (isEnrolled && statusData['data'] != null) {
            idPendaftaran =
                int.tryParse(statusData['data']['id'].toString()) ?? 0;
            // Load progress for this enrollment
            _loadProgres();
          }

          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  // Map to store lesson completion status
  Map<int, String> lessonProgress = {};

  void _loadProgres() async {
    if (idPendaftaran <= 0) return;

    try {
      final progres = await ApiService.getProgres(idPendaftaran);
      if (mounted && progres.isNotEmpty) {
        setState(() {
          for (var p in progres) {
            final idPelajaran = int.tryParse(p['id_pelajaran'].toString()) ?? 0;
            lessonProgress[idPelajaran] = p['status'] ?? 'belum';
          }
        });
      }
    } catch (e) {
      // Ignore error, progress will just show as not started
    }
  }

  void _loadUlasan() async {
    try {
      final id = int.tryParse(widget.kursus['id'].toString()) ?? 0;
      final data = await ApiService.getUlasan(id);
      if (mounted) {
        setState(() {
          ulasan = data;
          loadingUlasan = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loadingUlasan = false);
    }
  }

  void _daftarKursus() async {
    setState(() => enrollmentLoading = true);

    try {
      final id = int.tryParse(widget.kursus['id'].toString()) ?? 0;
      final userData = widget.userData as Map<String, dynamic>?;
      final idPengguna = int.tryParse(userData?['id']?.toString() ?? '0') ?? 0;

      final response = await ApiService.daftarKursus(idPengguna, id);

      if (mounted) {
        if (response['status'] == 'sukses') {
          setState(() => isEnrolled = true);
          _loadPelajaran(); // Refresh to get idPendaftaran
          _showEnrollmentSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['pesan'] ?? 'Gagal mendaftar')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => enrollmentLoading = false);
    }
  }

  void _showEnrollmentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50, shape: BoxShape.circle),
                child:
                    Icon(Icons.school, color: Colors.blue.shade600, size: 48),
              ),
              const SizedBox(height: 20),
              const Text('Pendaftaran Sukses!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Selamat belajar! Akses materi sekarang terbuka.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mulai Belajar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog untuk Tambah/Edit Ulasan
  void _showReviewDialog({Map<String, dynamic>? existingReview}) {
    TextEditingController komentarController = TextEditingController();
    int rating = 5;
    bool isEdit = existingReview != null;

    if (isEdit) {
      komentarController.text = existingReview['komentar'] ?? '';
      rating = int.tryParse(existingReview['rating']?.toString() ?? '5') ?? 5;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Ulasan' : 'Beri Ulasan'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rating:'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() => rating = index + 1);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: komentarController,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      border: OutlineInputBorder(),
                      hintText: 'Bagikan pengalaman Anda...',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal')),
              ElevatedButton(
                onPressed: () async {
                  if (komentarController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Silakan isi komentar')));
                    return;
                  }
                  Navigator.pop(context); // Close dialog

                  try {
                    Map<String, dynamic> response;
                    if (isEdit) {
                      final idUlasan =
                          int.tryParse(existingReview['id'].toString()) ?? 0;
                      response = await ApiService.updateUlasan(
                          idUlasan, rating, komentarController.text.trim());
                    } else {
                      final userData = widget.userData as Map<String, dynamic>?;
                      final idPengguna =
                          int.tryParse(userData?['id']?.toString() ?? '0') ?? 0;
                      final idKursus =
                          int.tryParse(widget.kursus['id'].toString()) ?? 0;
                      response = await ApiService.tambahUlasan(idPengguna,
                          idKursus, rating, komentarController.text.trim());
                    }

                    if (mounted) {
                      if (response['status'] == 'sukses') {
                        _loadUlasan(); // Refresh list
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response['pesan'] ?? 'Sukses'),
                            backgroundColor: Colors.green));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response['pesan'] ?? 'Gagal'),
                            backgroundColor: Colors.red));
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: Text(isEdit ? 'Update' : 'Kirim'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteReview(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Ulasan?'),
        content: const Text('Apakah Anda yakin ingin menghapus ulasan ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final response = await ApiService.hapusUlasan(id);
                if (mounted) {
                  if (response['status'] == 'sukses') {
                    _loadUlasan();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Ulasan dihapus'),
                        backgroundColor: Colors.green));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['pesan'] ?? 'Gagal hapus'),
                        backgroundColor: Colors.red));
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Theme colors
  final Color _primaryColor = const Color(0xFF6366F1);
  final Color _secondaryColor = const Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    final courseColor = _getCourseColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: loading
          ? _buildLoadingState()
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                // Modern Sliver App Bar with gradient
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  stretch: true,
                  backgroundColor: courseColor,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.bookmark_border,
                            color: Colors.white, size: 22),
                        onPressed: () {},
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            courseColor,
                            courseColor.withOpacity(0.8),
                            _secondaryColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Course badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_getLevelIcon(),
                                        color: Colors.white, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.kursus['tingkat'] ?? 'Kursus',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Course title
                              Text(
                                widget.kursus['judul'] ?? 'Tanpa Judul',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              // Course description
                              Text(
                                widget.kursus['deskripsi'] ?? '',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              // Stats row
                              Row(
                                children: [
                                  _buildStatChip(
                                    Icons.menu_book_rounded,
                                    '${pelajaran.length} Materi',
                                  ),
                                  const SizedBox(width: 12),
                                  _buildStatChip(
                                    Icons.star_rounded,
                                    '${ulasan.length} Ulasan',
                                  ),
                                  if (isEnrolled) ...[
                                    const SizedBox(width: 12),
                                    _buildStatChip(
                                      Icons.check_circle,
                                      'Terdaftar',
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Tab Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      indicatorColor: _primaryColor,
                      indicatorWeight: 3,
                      labelColor: _primaryColor,
                      unselectedLabelColor: Colors.grey[500],
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      tabs: const [
                        Tab(text: 'Materi'),
                        Tab(text: 'Ulasan'),
                      ],
                    ),
                  ),
                ),
              ],
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildMateriTab(),
                        _buildUlasanTab(),
                      ],
                    ),
                  ),
                  // Enrollment Button
                  if (!isEnrolled && !loading) _buildEnrollButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat kursus...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: enrollmentLoading ? null : _daftarKursus,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: enrollmentLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.school_rounded, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Daftar Kursus Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Color _getCourseColor() {
    final colorStr = widget.kursus['warna_tema']?.toString() ?? '#6366F1';
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    } catch (_) {
      return _primaryColor;
    }
  }

  IconData _getLevelIcon() {
    final level = widget.kursus['tingkat']?.toString().toLowerCase() ?? '';
    if (level.contains('pemula')) return Icons.eco_rounded;
    if (level.contains('menengah')) return Icons.trending_up_rounded;
    if (level.contains('lanjut')) return Icons.rocket_launch_rounded;
    return Icons.school_rounded;
  }

  Widget _buildMateriTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryColor.withOpacity(0.1),
                    _secondaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  Icon(Icons.menu_book_rounded, color: _primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Materi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${pelajaran.length} materi pembelajaran',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (!isEnrolled)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_rounded,
                        size: 14, color: Colors.orange[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Terkunci',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Lessons list
        if (pelajaran.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.school_outlined, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada materi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        else
          ...pelajaran.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;
            final isLocked = !isEnrolled;
            final idPelajaran = int.tryParse(p['id'].toString()) ?? 0;
            final status = lessonProgress[idPelajaran] ?? 'belum';
            final isCompleted = status == 'selesai';
            final isInProgress = status == 'sedang_dipelajari';

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLocked
                        ? Colors.grey[200]!
                        : isCompleted
                            ? Colors.green.withOpacity(0.3)
                            : _primaryColor.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: !isLocked
                        ? () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LessonScreen(
                                  pelajaran: p,
                                  kursus: widget.kursus,
                                  userData: widget.userData,
                                  idPendaftaran: idPendaftaran,
                                ),
                              ),
                            );
                            // Refresh progress after returning from lesson
                            _loadProgres();
                          }
                        : () {
                            CustomNotification.show(
                              context,
                              'Daftar kursus untuk mengakses materi ini',
                              isError: true,
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Number badge with completion indicator
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: isLocked
                                  ? null
                                  : isCompleted
                                      ? LinearGradient(
                                          colors: [
                                            Colors.green.withOpacity(0.2),
                                            Colors.green.withOpacity(0.1),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            _primaryColor.withOpacity(0.1),
                                            _secondaryColor.withOpacity(0.1),
                                          ],
                                        ),
                              color: isLocked ? Colors.grey[100] : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check_rounded,
                                      color: Colors.green, size: 24)
                                  : Text(
                                      '${p['urutan'] ?? index + 1}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isLocked
                                            ? Colors.grey[400]
                                            : _primaryColor,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['judul'] ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isLocked
                                        ? Colors.grey[500]
                                        : isCompleted
                                            ? Colors.green[700]
                                            : Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isLocked
                                      ? 'Daftar untuk membuka'
                                      : isCompleted
                                          ? '✓ Selesai dipelajari'
                                          : isInProgress
                                              ? 'Sedang dipelajari...'
                                              : 'Ketuk untuk mulai',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCompleted
                                        ? Colors.green
                                        : isInProgress
                                            ? Colors.orange
                                            : Colors.grey[400],
                                    fontWeight: isCompleted || isInProgress
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Status Icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isLocked
                                  ? Colors.grey[100]
                                  : isCompleted
                                      ? Colors.green.withOpacity(0.1)
                                      : _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isLocked
                                  ? Icons.lock_rounded
                                  : isCompleted
                                      ? Icons.check_circle_rounded
                                      : Icons.play_arrow_rounded,
                              color: isLocked
                                  ? Colors.grey[400]
                                  : isCompleted
                                      ? Colors.green
                                      : _primaryColor,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildUlasanTab() {
    if (loadingUlasan) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ulasan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('Belum ada ulasan',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showReviewDialog(),
              child: const Text('Beri Ulasan Pertama'),
            )
          ],
        ),
      );
    }

    // Get current user ID to check ownership
    final userData = widget.userData as Map<String, dynamic>?;
    final currentUserId =
        int.tryParse(userData?['id']?.toString() ?? '-1') ?? -1;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ulasan.length +
          1, // +1 for the "Add new" button at top if needed, or just list
      itemBuilder: (context, index) {
        if (index == ulasan.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => _showReviewDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Tulis Ulasan'),
              ),
            ),
          );
        }

        final review = ulasan[index];
        final reviewUserId =
            int.tryParse(review['id_pengguna']?.toString() ?? '-2') ?? -2;
        final isMyReview = reviewUserId == currentUserId;
        final reviewId = int.tryParse(review['id'].toString()) ?? 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.indigo.shade100,
                          child: Text(
                            (review['nama_pengguna'] ?? 'A')[0].toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMyReview
                                  ? 'Anda'
                                  : (review['nama_pengguna'] ?? 'Anonymous'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              review['tanggal']?.toString().split(' ')[0] ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          Icons.star,
                          size: 16,
                          color: starIndex <
                                  (int.tryParse(review['rating'].toString()) ??
                                      0)
                              ? Colors.amber
                              : Colors.grey[300],
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(review['komentar'] ?? '',
                    style: const TextStyle(fontSize: 14, height: 1.4)),

                // Edit/Delete buttons for owner
                if (isMyReview)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              _showReviewDialog(existingReview: review),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _deleteReview(reviewId),
                          icon: const Icon(Icons.delete, size: 16),
                          label: const Text('Hapus'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom delegate for sticky TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../widgets/custom_notification.dart';
import 'course_detail_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const MyCoursesScreen({super.key, required this.userData});

  @override
  State<MyCoursesScreen> createState() => MyCoursesScreenState();
}

class MyCoursesScreenState extends State<MyCoursesScreen> {
  List<dynamic> pendaftaran = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadPendaftaran();
  }

  // Public method to refresh data from MainScreen
  void refreshData() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    _loadPendaftaran();
  }

  void _loadPendaftaran() async {
    try {
      final id = int.tryParse(widget.userData['id'].toString()) ?? 0;
      print('DEBUG: Loading pendaftaran for user ID: $id');
      final data = await ApiService.getPendaftaran(id);
      print('DEBUG: Received ${data.length} pendaftaran');
      if (mounted) {
        setState(() {
          pendaftaran = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG: Error loading pendaftaran: $e');
      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    }
  }

  // Menampilkan bottom sheet menu untuk opsi kursus
  void _showCourseOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                item['judul_kursus'] ?? 'Kursus',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Divider(height: 1, color: Colors.grey[200]),

            // Reset Option
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              leading: Icon(Icons.replay, color: Colors.grey[700], size: 22),
              title: const Text(
                'Reset Progres Belajar',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmResetProgress(item);
              },
            ),

            Divider(height: 1, indent: 56, color: Colors.grey[200]),

            // Cancel Enrollment Option
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              leading: const Icon(Icons.remove_circle_outline,
                  color: Colors.red, size: 22),
              title: const Text(
                'Batalkan Pendaftaran',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmBatalDaftar(item);
              },
            ),

            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey[200]),

            // Cancel Button
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              title: Text(
                'Batal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Konfirmasi reset progres
  void _confirmResetProgress(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Ulangi dari awal?'),
        content: Text(
          'Progres belajar kursus ini akan direset ke 0%. Anda tetap terdaftar di kursus.',
          style: TextStyle(color: Colors.grey[700], height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () => _executeResetProgress(item),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  // Eksekusi reset progres
  void _executeResetProgress(Map<String, dynamic> item) async {
    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final idPendaftaran = int.tryParse(item['id'].toString()) ?? 0;
      final response = await ApiService.resetProgres(idPendaftaran);

      if (!mounted) return;
      Navigator.pop(context);

      if (response['status'] == 'sukses') {
        _loadPendaftaran();
        CustomNotification.show(context, 'Progres berhasil direset');
      } else {
        CustomNotification.show(
          context,
          response['pesan'] ?? 'Gagal mereset progres',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      CustomNotification.show(context, 'Terjadi kesalahan', isError: true);
    }
  }

  // Konfirmasi batalkan pendaftaran
  void _confirmBatalDaftar(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Keluar dari kursus?'),
        content: Text(
          'Semua progres belajar akan dihapus dan tidak dapat dikembalikan.',
          style: TextStyle(color: Colors.grey[700], height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () => _executeBatalDaftar(item),
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Eksekusi batalkan pendaftaran
  void _executeBatalDaftar(Map<String, dynamic> item) async {
    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final idPendaftaran = int.tryParse(item['id'].toString()) ?? 0;
      final response = await ApiService.batalDaftar(idPendaftaran);

      if (!mounted) return;
      Navigator.pop(context);

      if (response['status'] == 'sukses') {
        _loadPendaftaran();
        CustomNotification.show(context, 'Berhasil keluar dari kursus');
      } else {
        CustomNotification.show(
          context,
          response['pesan'] ?? 'Gagal keluar dari kursus',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      CustomNotification.show(context, 'Terjadi kesalahan', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            // Professional Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A00E0),
                    Color(0xFF8E2DE2),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A00E0).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kursus Saya',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lanjutkan progres belajar Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Content List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                      ? _buildErrorState()
                      : pendaftaran.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: () async => _loadPendaftaran(),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 20),
                                itemCount: pendaftaran.length,
                                itemBuilder: (context, index) {
                                  final item = pendaftaran[index];
                                  return _buildCourseCard(item, index);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat data',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                hasError = false;
              });
              _loadPendaftaran();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A00E0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4A00E0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 64,
              color: Color(0xFF4A00E0),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada kursus',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ayo mulai perjalanan belajar Anda!',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> item, int index) {
    // Determine color based on theme or index
    final colorHex = item['warna_tema'] ?? '#667eea';
    final themeColor = _parseColor(colorHex);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                kursus: {
                  'id': item['id_kursus'],
                  'judul': item['judul_kursus'],
                  'tingkat': item['tingkat'],
                  // Pass image data to detail screen too if needed
                  'gambar_thumbnail': item['gambar_thumbnail'],
                },
                userData: widget.userData,
              ),
            ),
          );
        },
        child: Column(
          children: [
            // Card Header with Image/Gradient
            SizedBox(
              height: 120, // Increased height for better image visibility
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Background Image or Gradient
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: item['gambar_thumbnail'] != null &&
                            item['gambar_thumbnail'].toString().isNotEmpty
                        ? _buildCourseImage(
                            item['gambar_thumbnail'], themeColor)
                        : _buildPlaceholderImage(themeColor),
                  ),

                  // 2. Gradient Overlay for Text Readability
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  // 3. Content Overlay
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                  color: _getLevelColor(item['tingkat']),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              child: Text(
                                item['tingkat'] ?? 'Umum',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10, // Small text
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_horiz,
                                  color: Colors.white),
                              onPressed: () => _showCourseOptions(item),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        Text(
                          item['judul_kursus'] ?? 'Kursus',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black54)
                              ]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card Body with Stats & Progress
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        Icons.book_outlined,
                        '${item['selesai_pelajaran']}/${item['total_pelajaran']} Materi',
                        Colors.blue,
                      ),
                      _buildStatItem(
                        Icons.calendar_today_outlined,
                        item['tanggal_daftar']?.toString().split(' ')[0] ?? '-',
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progres Belajar',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${item['progress_persen'] ?? 0}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (double.tryParse(
                                      item['progress_persen']?.toString() ??
                                          '0') ??
                                  0) /
                              100,
                          backgroundColor: Colors.grey[100],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF10B981)), // Green Bar preserved
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods (Copied/Adapted from HomeScreen)
  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.indigo;
    }
  }

  Color _getLevelColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'pemula':
        return Colors.green;
      case 'menengah':
        return Colors.orange;
      case 'lanjutan':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildCourseImage(String imageUrl, Color themeColor) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderImage(themeColor),
      );
    } else {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderImage(themeColor),
      );
    }
  }

  Widget _buildPlaceholderImage(Color color) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.7)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.school, size: 48, color: Colors.white24),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

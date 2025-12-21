import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const HomeScreen({super.key, this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> kursus = [];
  List<dynamic> filteredKursus = [];
  List<dynamic> kategori = [];
  int? selectedKategoriId;
  bool loading = true;
  bool loadingKategori = true;
  bool hasError = false;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKategori();
    _loadKursus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadKategori() async {
    try {
      final data = await ApiService.getKategori();
      setState(() {
        kategori = data;
        loadingKategori = false;
      });
    } catch (e) {
      setState(() {
        loadingKategori = false;
      });
    }
  }

  void _loadKursus() async {
    setState(() {
      loading = true;
      hasError = false;
    });

    try {
      final data = await ApiService.getKursus();
      setState(() {
        kursus = data;
        filteredKursus = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        hasError = true;
        errorMessage = 'Gagal memuat kursus: $e';
      });
    }
  }

  void _filterByKategori(int? idKategori) async {
    setState(() {
      selectedKategoriId = idKategori;
      loading = true;
      _searchController.clear();
    });

    try {
      List<dynamic> data;
      if (idKategori == null || idKategori == 1) {
        // Semua atau tidak ada kategori dipilih
        data = await ApiService.getKursus();
      } else {
        data = await ApiService.getKursusByKategori(idKategori);
      }
      setState(() {
        kursus = data;
        filteredKursus = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        hasError = true;
        errorMessage = 'Gagal memuat kursus: $e';
      });
    }
  }

  void _filterKursus(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredKursus = kursus;
      } else {
        filteredKursus = kursus.where((k) {
          final judul = k['judul']?.toString().toLowerCase() ?? '';
          final deskripsi = k['deskripsi']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          return judul.contains(searchLower) || deskripsi.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan widget.userData jika ada, jika tidak coba dari arguments (backward compatible)
    final user = widget.userData ??
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userName = user?['nama'] ?? 'Pengguna';
    final greeting = _getGreeting();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // For iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.person, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                offset: const Offset(0, 50),
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user?['email'] ?? '',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: const Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Keluar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Enhanced Header Section with Time-Based Greeting
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A00E0), // Richer violet
                    const Color(0xFF8E2DE2), // Vibrant purple
                    const Color(0xFFf093fb), // Soft pink accent
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A00E0).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Decorative Circles - Quantum Particles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    right: 40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        24, 60, 24, 28), // Added top padding for status bar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome/Greeting Text with Glassmorphism
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getTimeIcon(),
                                color: Colors.amberAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                greeting,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // User Greeting - Bold & Clear
                        Text(
                          'Halo, $userName! 👋',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle with Icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Eksplorasi dunia Quantum Computing',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
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

            // Enhanced Search Bar
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterKursus,
                decoration: InputDecoration(
                  hintText: 'Cari kursus yang kamu inginkan...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[400]),
                          onPressed: () {
                            _searchController.clear();
                            _filterKursus('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF667eea),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            // Category Chips
            if (!loadingKategori && kategori.isNotEmpty)
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kategori.length,
                  itemBuilder: (context, index) {
                    final kat = kategori[index];
                    final isSelected = selectedKategoriId ==
                        int.tryParse(kat['id'].toString());
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(kat['nama_kategori'] ?? ''),
                        selected: isSelected,
                        onSelected: (selected) {
                          final id = int.tryParse(kat['id'].toString());
                          _filterByKategori(selected ? id : null);
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.indigo.withOpacity(0.2),
                        checkmarkColor: Colors.indigo,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.indigo : Colors.grey[700],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? Colors.indigo : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Course List
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadKursus,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : filteredKursus.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tidak ada kursus ditemukan',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                // Reload both categories and courses
                                _loadKategori();
                                _loadKursus();
                              },
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: filteredKursus.length,
                                itemBuilder: (context, index) {
                                  final k = filteredKursus[index];
                                  return _buildCourseCard(k, user);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      Map<String, dynamic> kursus, Map<String, dynamic>? user) {
    // Parse warna tema dari database atau gunakan default
    final colorHex = kursus['warna_tema'] ?? '#667eea';
    final Color themeColor = _parseColor(colorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: themeColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CourseDetailScreen(kursus: kursus, userData: user),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image Header with Gradient Overlay
            Stack(
              children: [
                // Course Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: kursus['gambar_thumbnail'] != null &&
                          kursus['gambar_thumbnail'].toString().isNotEmpty
                      ? _buildCourseImage(
                          kursus['gambar_thumbnail'], themeColor)
                      : _buildPlaceholderImage(themeColor),
                ),

                // Gradient Overlay
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
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

                // Level Badge
                if (kursus['tingkat'] != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getLevelColor(kursus['tingkat']),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getLevelIcon(kursus['tingkat']),
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            kursus['tingkat'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Course Title Overlay
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Text(
                    kursus['judul'] ?? 'Tanpa Judul',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Course Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (kursus['deskripsi'] != null &&
                      kursus['deskripsi'].toString().isNotEmpty)
                    Text(
                      kursus['deskripsi'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 12),

                  // Stats Row
                  Row(
                    children: [
                      // Duration
                      if (kursus['durasi_estimasi'] != null)
                        Expanded(
                          child: _buildStatChip(
                            Icons.access_time,
                            '${kursus['durasi_estimasi']} min',
                            Colors.blue,
                          ),
                        ),

                      const SizedBox(width: 8),

                      // Action Button
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [themeColor, themeColor.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mulai Belajar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
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

  // Helper: Build course image (supports both assets and network)
  Widget _buildCourseImage(String imageUrl, Color themeColor) {
    // Check if it's a local asset path
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage(themeColor);
        },
      );
    } else {
      // Network image
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage(themeColor);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholderImage(themeColor);
        },
      );
    }
  }

  // Helper: Build placeholder image with gradient
  Widget _buildPlaceholderImage(Color color) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.science_outlined,
          size: 64,
          color: Colors.white54,
        ),
      ),
    );
  }

  // Helper: Build stat chip
  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Parse hex color
  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      }
      return const Color(0xFF667eea);
    } catch (e) {
      return const Color(0xFF667eea);
    }
  }

  // Helper: Get level color
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

  // Helper: Get level icon
  IconData _getLevelIcon(String? level) {
    switch (level?.toLowerCase()) {
      case 'pemula':
        return Icons.stars;
      case 'menengah':
        return Icons.trending_up;
      case 'lanjutan':
        return Icons.rocket_launch;
      default:
        return Icons.help_outline;
    }
  }

  // Helper: Get time-based icon
  IconData _getTimeIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return Icons.wb_sunny_outlined;
    } else if (hour >= 11 && hour < 15) {
      return Icons.wb_sunny;
    } else if (hour >= 15 && hour < 18) {
      return Icons.wb_twilight;
    } else {
      return Icons.nightlight_round;
    }
  }

  // Helper: Get time-based greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}

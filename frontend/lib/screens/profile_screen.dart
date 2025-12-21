import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'admin/admin_dashboard_screen.dart';
import '../widgets/custom_notification.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;

  int _totalKursus = 0;
  int _totalSelesai = 0;
  int _totalUlasan = 0;
  bool _loadingStats = true;

  String? _fotoProfil;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController =
        TextEditingController(text: widget.userData['nama'] ?? '');
    _emailController =
        TextEditingController(text: widget.userData['email'] ?? '');
    _fotoProfil = widget.userData['foto'];
    _loadStats();
  }

  // Public method to refresh stats from MainScreen
  void refreshStats() {
    setState(() {
      _loadingStats = true;
    });
    _loadStats();
  }

  void _loadStats() async {
    try {
      final id = int.tryParse(widget.userData['id'].toString()) ?? 0;
      print('DEBUG: Loading stats for user ID: $id');

      final stats = await ApiService.getStatistik(id);
      print('DEBUG: Stats received: $stats');

      if (mounted) {
        setState(() {
          _totalKursus = int.tryParse(stats['kursus']?.toString() ?? '0') ?? 0;
          _totalSelesai =
              int.tryParse(stats['selesai']?.toString() ?? '0') ?? 0;
          _totalUlasan = int.tryParse(stats['ulasan']?.toString() ?? '0') ?? 0;
          _loadingStats = false;
        });
      }
    } catch (e) {
      print('Error loading stats: $e');
      if (mounted) {
        setState(() {
          _totalKursus = 0;
          _totalSelesai = 0;
          _totalUlasan = 0;
          _loadingStats = false;
        });
      }
    }
  }

  Future<void> _uploadFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final id = int.tryParse(widget.userData['id'].toString()) ?? 0;
      final File file = File(image.path);

      final response = await ApiService.uploadFoto(id, file);

      if (!mounted) return;
      Navigator.pop(context);

      if (response['status'] == 'sukses') {
        setState(() {
          _fotoProfil = response['foto'];

          widget.userData['foto'] = response['foto'];
        });

        CustomNotification.show(context, 'Foto profil berhasil diperbarui');
      } else {
        CustomNotification.show(
            context, response['pesan'] ?? 'Gagal upload foto',
            isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      CustomNotification.show(context, 'Error: $e', isError: true);
    }
  }

  String getFotoUrl(String filename) {
    if (filename.startsWith('http')) return filename;

    final baseUrl =
        ApiService.baseUrl.replaceAll('/backend', '/backend/uploads/profil/');
    return baseUrl + filename;
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final id = int.tryParse(widget.userData['id'].toString()) ?? 0;
      final response = await ApiService.updateProfil(
        id,
        _namaController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.isEmpty ? null : _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response['status'] == 'sukses') {
        setState(() {
          _isEditing = false;

          widget.userData['nama'] = _namaController.text.trim();
          widget.userData['email'] = _emailController.text.trim();
        });

        CustomNotification.show(context, 'Profil berhasil diperbarui!');
      } else {
        CustomNotification.show(context, response['pesan'] ?? 'Gagal update',
            isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      CustomNotification.show(context, 'Error: $e', isError: true);
    }
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Akun Permanen?',
            style: TextStyle(color: Colors.red)),
        content: const Text(
          'Tindakan ini tidak dapat dibatalkan. Semua data kursus, progres belajar, dan informasi profil Anda akan dihapus secara permanen dari sistem.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close confirm dialog

              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                final id = int.tryParse(widget.userData['id'].toString()) ?? 0;
                final response = await ApiService.hapusAkun(id);

                if (!mounted) return;
                Navigator.pop(context); // Close loading dialog

                if (response['status'] == 'sukses') {
                  // Navigate to welcome/login screen and clear stack
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);

                  CustomNotification.show(
                      context, 'Akun Anda telah berhasil dihapus');
                } else {
                  CustomNotification.show(
                      context, response['pesan'] ?? 'Gagal menghapus akun',
                      isError: true);
                }
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context); // Close loading dialog
                CustomNotification.show(context, 'Error: $e', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Permanen'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
        backgroundColor: const Color(0xFFF8FAFC),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Gradient Background
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 80),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title Row (Profile + Edit)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profil Saya',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (!_isEditing)
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.edit,
                                      color: Colors.white, size: 20),
                                ),
                                onPressed: () =>
                                    setState(() => _isEditing = true),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Profile Image with Glow
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                border:
                                    Border.all(color: Colors.white, width: 4),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: _fotoProfil != null &&
                                        _fotoProfil!.isNotEmpty
                                    ? NetworkImage(getFotoUrl(_fotoProfil!))
                                    : null,
                                child:
                                    _fotoProfil == null || _fotoProfil!.isEmpty
                                        ? Text(
                                            (widget.userData['nama'] ?? 'U')[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo.shade600),
                                          )
                                        : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _uploadFoto,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      color: Color(0xFF4A00E0), size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // User Name & Email
                        Text(
                          widget.userData['nama'] ?? 'Pengguna',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.userData['email'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 2. Stats Section (Overlapping Header)
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _loadingStats
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Kursus', '$_totalKursus',
                                  Icons.school_outlined, Colors.blue),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey[200]),
                              _buildStatItem('Selesai', '$_totalSelesai',
                                  Icons.check_circle_outline, Colors.green),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey[200]),
                              _buildStatItem('Ulasan', '$_totalUlasan',
                                  Icons.star_outline, Colors.orange),
                            ],
                          ),
                  ),
                ),
              ),

              // 3. Edit Profile Form (Expanded if editing)
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Informasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(_namaController, 'Nama Lengkap',
                            Icons.person_outline),
                        const SizedBox(height: 16),
                        _buildTextField(
                            _emailController, 'Email', Icons.email_outlined),
                        const SizedBox(height: 16),
                        _buildTextField(_passwordController,
                            'Password Baru (Opsional)', Icons.lock_outline,
                            obscureText: true),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _isEditing = false),
                                child: const Text('Batal',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A00E0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : const Text('Simpan Perubahan',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // 4. Menu Options
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Container(
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
                  child: Column(
                    children: [
                      if (widget.userData['email'] == 'admin@admin.com') ...[
                        _buildMenuItem(
                          Icons.admin_panel_settings_outlined,
                          'Admin Panel',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminDashboardScreen()));
                          },
                          color: const Color(0xFF4A00E0),
                        ),
                        _buildDivider(),
                      ],
                      _buildMenuItem(
                          Icons.settings_outlined, 'Pengaturan', () {}),
                      _buildDivider(),
                      _buildMenuItem(
                          Icons.help_outline, 'Bantuan & Support', () {}),
                      _buildDivider(),
                      _buildMenuItem(
                          Icons.info_outline, 'Tentang Aplikasi', () {}),
                      _buildDivider(),
                      _buildMenuItem(Icons.logout, 'Keluar', _logout,
                          isDestructive: false, color: Colors.indigo),
                      _buildDivider(),
                      _buildMenuItem(Icons.delete_forever_outlined,
                          'Hapus Akun', _deleteAccount,
                          isDestructive: true),
                    ],
                  ),
                ),
              ),

              // Version Info
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Versi 1.0.0 (Quantum Release)',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A00E0)),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Colors.grey[100],
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false, Color? color}) {
    final itemColor =
        color ?? (isDestructive ? Colors.red : const Color(0xFF334155));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: itemColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: itemColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey[300]),
      onTap: onTap,
    );
  }
}

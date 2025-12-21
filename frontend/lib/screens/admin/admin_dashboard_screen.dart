import 'package:flutter/material.dart';
import 'manage_categories_screen.dart';
import 'manage_courses_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminMenuCard(
            context,
            'Kelola Kategori',
            Icons.category,
            Colors.orange,
            const ManageCategoriesScreen(),
          ),
          const SizedBox(height: 16),
          _buildAdminMenuCard(
            context,
            'Kelola Kursus & Materi',
            Icons.school,
            Colors.blue,
            const ManageCoursesScreen(),
          ),
          const SizedBox(height: 16),
          // Bisa tambah menu lain seperti Kelola User, Laporan, dll.
          _buildAdminMenuInfo(),
        ],
      ),
    );
  }

  Widget _buildAdminMenuCard(BuildContext context, String title, IconData icon,
      Color color, Widget destination) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminMenuInfo() {
    return Card(
      color: Colors.grey[100],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Info Admin', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                'Sebagai admin, Anda memiliki akses penuh untuk menambah, mengedit, dan menghapus konten aplikasi.'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_notification.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    try {
      final data = await ApiService.getKategori();
      setState(() {
        categories = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _showFormDialog({Map<String, dynamic>? category}) {
    final TextEditingController nameController = TextEditingController(
      text: category != null ? category['nama_kategori'] : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;

              // Show loading inside dialog or just disable button (simple approach: close & show global loading)
              // Better: Keep dialog open on error.

              try {
                Map<String, dynamic> response;
                if (category == null) {
                  response =
                      await ApiService.tambahKategori(nameController.text);
                } else {
                  final id = int.tryParse(category['id'].toString()) ?? 0;
                  response =
                      await ApiService.updateKategori(id, nameController.text);
                }

                if (!mounted) return;

                if (response['status'] == 'sukses') {
                  Navigator.pop(context); // Close only on success
                  _loadCategories(); // Refresh list
                  CustomNotification.show(
                      context, response['pesan'] ?? 'Berhasil disimpan');
                } else {
                  // Show error from backend
                  CustomNotification.show(
                      context, response['pesan'] ?? 'Gagal menyimpan',
                      isError: true);
                }
              } catch (e) {
                if (mounted) {
                  CustomNotification.show(context, 'Error: $e', isError: true);
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori?'),
        content: const Text('Yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => isLoading = true);
              try {
                final response = await ApiService.hapusKategori(id);

                if (mounted) {
                  if (response['status'] == 'sukses') {
                    _loadCategories();
                    CustomNotification.show(
                        context, response['pesan'] ?? 'Kategori dihapus');
                  } else {
                    setState(() => isLoading = false); // Stop loading
                    CustomNotification.show(
                        context, response['pesan'] ?? 'Gagal menghapus',
                        isError: true);
                  }
                }
              } catch (e) {
                if (mounted) {
                  setState(() => isLoading = false);
                  CustomNotification.show(context, 'Error: $e', isError: true);
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kategori')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  title: Text(cat['nama_kategori'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showFormDialog(category: cat),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: (cat['nama_kategori'] == 'Semua' ||
                                    int.tryParse(cat['id'].toString()) == 1)
                                ? Colors.grey
                                : Colors.red),
                        onPressed: (cat['nama_kategori'] == 'Semua' ||
                                int.tryParse(cat['id'].toString()) == 1)
                            ? null
                            : () {
                                final id =
                                    int.tryParse(cat['id'].toString()) ?? 0;
                                _deleteCategory(id);
                              },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

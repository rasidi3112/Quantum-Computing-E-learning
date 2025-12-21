import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'manage_lessons_screen.dart';
import '../../widgets/custom_notification.dart';

class ManageCoursesScreen extends StatefulWidget {
  const ManageCoursesScreen({super.key});

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  List<dynamic> courses = [];
  List<dynamic> categories = []; // Store categories for dropdown
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      // Load both courses and categories
      final results = await Future.wait([
        ApiService.getKursus(),
        ApiService.getKategori(),
      ]);

      setState(() {
        courses = (results[0] as List?) ?? [];
        categories = (results[1] as List?) ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e'); // Debug print
      setState(() {
        isLoading = false;
        courses = []; // Ensure not null
        categories = [];
      });
    }
  }

  void _loadCourses() async {
    try {
      final data = await ApiService.getKursus();
      setState(() {
        courses = (data as List?) ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading courses: $e');
      setState(() => isLoading = false);
    }
  }

  // Helper untuk parse warna hex
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

  void _showFormDialog({Map<String, dynamic>? course}) async {
    // Show fetching loading indicator if editing
    if (course != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    final titleController = TextEditingController(text: course?['judul']);
    final descController = TextEditingController(text: course?['deskripsi']);
    final levelController =
        TextEditingController(text: course?['tingkat'] ?? 'Pemula');
    final imageController =
        TextEditingController(text: course?['gambar_thumbnail'] ?? '');
    final colorController =
        TextEditingController(text: course?['warna_tema'] ?? '#6366f1');

    int? selectedCategoryId;

    // Logic to fetch existing category if editing
    if (course != null) {
      try {
        final id = int.tryParse(course['id'].toString()) ?? 0;
        final existingCategories = await ApiService.getKategoriKursus(id);

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        if (existingCategories.isNotEmpty) {
          // Assume single category for now
          selectedCategoryId =
              int.tryParse(existingCategories[0]['id'].toString());
        }
      } catch (e) {
        if (mounted) Navigator.pop(context); // Close loading on error
        print('Error fetching course category: $e');
      }
    } else {
      // Default logic for new course
      if (categories.isNotEmpty && categories.length > 1) {
        selectedCategoryId = int.tryParse(categories[1]['id'].toString());
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setStateDialog) {
        return AlertDialog(
          title: Text(course == null ? 'Tambah Kursus' : 'Edit Kursus'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Kursus',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: ['Pemula', 'Menengah', 'Lanjutan']
                          .contains(levelController.text)
                      ? levelController.text
                      : 'Pemula',
                  decoration: const InputDecoration(
                    labelText: 'Tingkat',
                  ),
                  items: ['Pemula', 'Menengah', 'Lanjutan'].map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (val) => levelController.text = val ?? 'Pemula',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                  ),
                  items: categories
                      .where((cat) => cat['nama_kategori'] != 'Semua')
                      .map((cat) {
                    return DropdownMenuItem<int>(
                      value: int.tryParse(cat['id'].toString()),
                      child: Text(cat['nama_kategori']),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setStateDialog(() => selectedCategoryId = val),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Gambar Thumbnail',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar',
                    hintText: 'https://images.unsplash.com/...',
                    helperText:
                        'Masukkan URL gambar dari Unsplash atau lainnya',
                    helperMaxLines: 2,
                  ),
                ),
                const SizedBox(height: 12),
                // Preview gambar jika ada URL
                if (imageController.text.isNotEmpty)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: colorController,
                  decoration: InputDecoration(
                    labelText: 'Warna Tema',
                    hintText: '#6366f1',
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _parseColor(colorController.text),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  onChanged: (val) => setStateDialog(() {}),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                Navigator.pop(context);
                setState(() => isLoading = true);

                try {
                  int courseId = 0;
                  Map<String, dynamic> response;

                  if (course == null) {
                    // Create
                    response = await ApiService.tambahKursus(
                      judul: titleController.text,
                      deskripsi: descController.text,
                      tingkat: levelController.text,
                      gambarUrl: imageController.text.isNotEmpty
                          ? imageController.text
                          : null,
                      warnaTema: colorController.text.isNotEmpty
                          ? colorController.text
                          : null,
                    );

                    if (response['status'] == 'sukses' &&
                        response['id'] != null) {
                      courseId = int.tryParse(response['id'].toString()) ?? 0;
                    }
                  } else {
                    // Update
                    courseId = int.tryParse(course['id'].toString()) ?? 0;
                    response = await ApiService.updateKursus(
                      id: courseId,
                      judul: titleController.text,
                      deskripsi: descController.text,
                      tingkat: levelController.text,
                      gambarUrl: imageController.text.isNotEmpty
                          ? imageController.text
                          : null,
                      warnaTema: colorController.text.isNotEmpty
                          ? colorController.text
                          : null,
                    );
                  }

                  if (response['status'] != 'sukses') {
                    setState(() => isLoading = false);
                    if (mounted) {
                      CustomNotification.show(context,
                          response['pesan'] ?? 'Gagal menyimpan kursus',
                          isError: true);
                    }
                    return;
                  }

                  // Update Category Relation
                  if (courseId > 0 && selectedCategoryId != null) {
                    try {
                      await ApiService.tambahKursusKategori(
                          courseId, selectedCategoryId!);
                    } catch (e) {
                      print('Error saving category relation: $e');
                    }
                  }

                  if (mounted) {
                    CustomNotification.show(context, 'Berhasil disimpan');
                  }
                  _loadData();
                } catch (e) {
                  setState(() => isLoading = false);
                  if (mounted) {
                    CustomNotification.show(context, 'Error: $e',
                        isError: true);
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      }),
    );
  }

  void _deleteCourse(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kursus?'),
        content: const Text('Semua pelajaran dan data terkait akan terhapus.'),
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
                final response = await ApiService.hapusKursus(id);

                if (mounted) {
                  if (response['status'] == 'sukses') {
                    CustomNotification.show(context, 'Kursus dihapus');
                  } else {
                    // Backend gagal hapus (misal ada foreign key restrict)
                    CustomNotification.show(
                        context, response['pesan'] ?? 'Gagal menghapus kursus',
                        isError: true);
                  }
                }
                _loadCourses(); // Refresh data regardless to sync state
              } catch (e) {
                if (mounted) {
                  CustomNotification.show(context, 'Error: $e', isError: true);
                }
                _loadCourses();
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
      appBar: AppBar(title: const Text('Kelola Kursus')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                if (course == null) return const SizedBox(); // Skip if null

                // Safe parsing for ID
                final id = int.tryParse(course['id'].toString()) ?? 0;

                // Safe string extraction
                final judul = course['judul']?.toString() ?? 'Tanpa Judul';
                final tingkat = course['tingkat']?.toString() ?? 'Umum';

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(judul,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(tingkat),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.list_alt, color: Colors.green),
                          tooltip: 'Kelola Materi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageLessonsScreen(
                                  courseId: id,
                                  courseTitle: judul,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showFormDialog(course: course),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCourse(id),
                        ),
                      ],
                    ),
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

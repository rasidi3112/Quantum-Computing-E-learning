import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ManageLessonsScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const ManageLessonsScreen(
      {super.key, required this.courseId, required this.courseTitle});

  @override
  State<ManageLessonsScreen> createState() => _ManageLessonsScreenState();
}

class _ManageLessonsScreenState extends State<ManageLessonsScreen> {
  List<dynamic> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() async {
    try {
      final data = await ApiService.getPelajaran(widget.courseId);
      setState(() {
        lessons = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _showFormDialog({Map<String, dynamic>? lesson}) {
    final titleController = TextEditingController(text: lesson?['judul']);
    final contentController = TextEditingController(
        text: lesson?['konten_teks'] ?? lesson?['konten'] ?? '');
    final orderController = TextEditingController(
        text: (lesson?['urutan'] ?? (lessons.length + 1)).toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lesson == null ? 'Tambah Pelajaran' : 'Edit Pelajaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Pelajaran'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Konten Teks'),
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: orderController,
                decoration: const InputDecoration(labelText: 'Urutan'),
                keyboardType: TextInputType.number,
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

              // Jangan tutup dialog dulu, kita cek statusnya
              // Navigator.pop(context); // <--- HAPUS INI

              // Gunakan dialog loading terpisah atau set state jika di StatefulBuilder (tapi ini dialog biasa)
              // Untuk simplicity: Kita tutup dialog form, lalu show loading indicator global, lalu logic.
              Navigator.pop(context);
              setState(() => isLoading = true);

              try {
                Map<String, dynamic> response;
                if (lesson == null) {
                  response = await ApiService.tambahPelajaran(
                    idKursus: widget.courseId,
                    judul: titleController.text,
                    konten: contentController.text,
                    urutan: int.tryParse(orderController.text) ?? 1,
                  );
                } else {
                  final id = int.tryParse(lesson['id'].toString()) ?? 0;
                  response = await ApiService.updatePelajaran(
                    id: id,
                    judul: titleController.text,
                    konten: contentController.text,
                    urutan: int.tryParse(orderController.text) ?? 1,
                  );
                }

                if (mounted) {
                  if (response['status'] == 'sukses') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Berhasil disimpan'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(response['pesan'] ?? 'Gagal menyimpan'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
                _loadLessons(); // Ini akan set isLoading = false
              } catch (e) {
                if (mounted) {
                  setState(() => isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteLesson(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelajaran?'),
        content: const Text('Yakin ingin menghapus pelajaran ini?'),
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
                final response = await ApiService.hapusPelajaran(id);

                if (mounted) {
                  if (response['status'] == 'sukses') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Pelajaran dihapus'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(response['pesan'] ?? 'Gagal menghapus'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
                _loadLessons();
              } catch (e) {
                if (mounted) {
                  setState(() => isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red),
                  );
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
      appBar: AppBar(title: Text('Materi: ${widget.courseTitle}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final id = int.tryParse(lesson['id'].toString()) ?? 0;

                return ListTile(
                  key: Key('$id'),
                  leading: CircleAvatar(child: Text('${lesson['urutan']}')),
                  title: Text(lesson['judul'] ?? ''),
                  subtitle: Text(
                    lesson['konten_teks'] ?? lesson['konten'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showFormDialog(lesson: lesson),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLesson(id),
                      ),
                    ],
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                // Feature improvement: Implement reorder API logic here
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2/elearning_qc_api/backend';
    } else {
      return 'http://127.0.0.1/elearning_qc_api/backend';
    }
  }

  static dynamic _safeJsonDecode(String body, {bool isList = false}) {
    if (body.isEmpty) {
      return isList
          ? []
          : {"status": "gagal", "pesan": "Response kosong dari server"};
    }
    try {
      return jsonDecode(body);
    } catch (e) {
      print('JSON DECODE ERROR: $e');
      print('BODY: $body');
      return isList
          ? []
          : {"status": "gagal", "pesan": "Format response tidak valid"};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login.php');
      final response = await http.post(uri, body: {
        'email': email,
        'kata_sandi': password,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG LOGIN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('LOGIN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> register(
      String nama, String email, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/register.php');
      final response = await http.post(uri, body: {
        'nama': nama,
        'email': email,
        'kata_sandi': password,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG REGISTER: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('REGISTER ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getKategori() async {
    try {
      final uri = Uri.parse('$baseUrl/kategori/get_kategori.php');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET KATEGORI ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> tambahKategori(String nama) async {
    try {
      final uri = Uri.parse('$baseUrl/kategori/tambah_kategori.php');
      final response = await http.post(uri, body: {
        'nama_kategori': nama,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG TAMBAH KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('TAMBAH KATEGORI ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateKategori(
      int id, String nama) async {
    try {
      final uri = Uri.parse('$baseUrl/kategori/update_kategori.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
        'nama_kategori': nama,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG UPDATE KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPDATE KATEGORI ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> hapusKategori(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/kategori/hapus_kategori.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS KATEGORI ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getKursus() async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/get_kursus.php');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG KURSUS RAW RESPONSE: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET KURSUS ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getDetailKursus(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/get_detail_kursus.php?id=$id');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG DETAIL KURSUS: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('GET DETAIL KURSUS ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getKursusByKategori(int idKategori) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/kursus/get_kursus_by_kategori.php?id_kategori=$idKategori');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG KURSUS BY KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET KURSUS BY KATEGORI ERROR: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getKategoriKursus(int idKursus) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/kursus/get_kategori_kursus.php?id_kursus=$idKursus');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG KATEGORI KURSUS: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET KATEGORI KURSUS ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> tambahKursus({
    required String judul,
    required String deskripsi,
    required String tingkat,
    String? gambarUrl,
    String? warnaTema,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/tambah_kursus.php');
      final body = {
        'judul': judul,
        'deskripsi': deskripsi,
        'tingkat': tingkat,
      };
      if (gambarUrl != null) body['gambar_thumbnail'] = gambarUrl;
      if (warnaTema != null) body['warna_tema'] = warnaTema;

      final response =
          await http.post(uri, body: body).timeout(const Duration(seconds: 30));
      print('DEBUG TAMBAH KURSUS: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('TAMBAH KURSUS ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateKursus({
    required int id,
    required String judul,
    required String deskripsi,
    required String tingkat,
    String? gambarUrl,
    String? warnaTema,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/update_kursus.php');
      final body = {
        'id': id.toString(),
        'judul': judul,
        'deskripsi': deskripsi,
        'tingkat': tingkat,
      };
      if (gambarUrl != null) body['gambar_thumbnail'] = gambarUrl;
      if (warnaTema != null) body['warna_tema'] = warnaTema;

      final response =
          await http.post(uri, body: body).timeout(const Duration(seconds: 30));
      print('DEBUG UPDATE KURSUS: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPDATE KURSUS ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> hapusKursus(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/hapus_kursus.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS KURSUS: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS KURSUS ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> tambahKursusKategori(
      int idKursus, int idKategori) async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/tambah_kursus_kategori.php');
      final response = await http.post(uri, body: {
        'id_kursus': idKursus.toString(),
        'id_kategori': idKategori.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG TAMBAH KURSUS KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('TAMBAH KURSUS KATEGORI ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> hapusKursusKategori(
      int idKursus, int idKategori) async {
    try {
      final uri = Uri.parse('$baseUrl/kursus/hapus_kursus_kategori.php');
      final response = await http.post(uri, body: {
        'id_kursus': idKursus.toString(),
        'id_kategori': idKategori.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS KURSUS KATEGORI: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS KURSUS KATEGORI ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getPelajaran(int idKursus) async {
    try {
      final uri =
          Uri.parse('$baseUrl/pelajaran/get_pelajaran.php?id_kursus=$idKursus');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG PELAJARAN: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET PELAJARAN ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getDetailPelajaran(int id) async {
    try {
      final uri =
          Uri.parse('$baseUrl/pelajaran/get_detail_pelajaran.php?id=$id');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG DETAIL PELAJARAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('GET DETAIL PELAJARAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> tambahPelajaran({
    required int idKursus,
    required String judul,
    required String konten,
    required int urutan,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/pelajaran/tambah_pelajaran.php');
      final response = await http.post(uri, body: {
        'id_kursus': idKursus.toString(),
        'judul': judul,
        'konten': konten,
        'urutan': urutan.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG TAMBAH PELAJARAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('TAMBAH PELAJARAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> updatePelajaran({
    required int id,
    required String judul,
    required String konten,
    required int urutan,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/pelajaran/update_pelajaran.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
        'judul': judul,
        'konten': konten,
        'urutan': urutan.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG UPDATE PELAJARAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPDATE PELAJARAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> hapusPelajaran(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/pelajaran/hapus_pelajaran.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS PELAJARAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS PELAJARAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> daftarKursus(
      int idPengguna, int idKursus) async {
    try {
      final uri = Uri.parse('$baseUrl/pendaftaran/daftar.php');
      final response = await http.post(uri, body: {
        'id_pengguna': idPengguna.toString(),
        'id_kursus': idKursus.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG DAFTAR KURSUS: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('DAFTAR KURSUS ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> cekStatusPendaftaran(
      int idPengguna, int idKursus) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/pendaftaran/cek_status.php?id_pengguna=$idPengguna&id_kursus=$idKursus');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG STATUS PENDAFTARAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('CEK STATUS PENDAFTARAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getPendaftaran(int idPengguna) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/pendaftaran/get_pendaftaran.php?id_pengguna=$idPengguna');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG GET PENDAFTARAN: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET PENDAFTARAN ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> batalDaftar(int idPendaftaran) async {
    try {
      final uri = Uri.parse('$baseUrl/pendaftaran/batal_daftar.php');
      final response = await http.post(uri, body: {
        'id': idPendaftaran.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG BATAL DAFTAR: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('BATAL DAFTAR ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateProfil(
      int id, String nama, String email, String? password) async {
    try {
      final uri = Uri.parse('$baseUrl/pengguna/update_profil.php');
      final body = {
        'id': id.toString(),
        'nama': nama,
        'email': email,
      };
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }
      final response =
          await http.post(uri, body: body).timeout(const Duration(seconds: 30));
      print('DEBUG UPDATE PROFIL: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPDATE PROFIL ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> getStatistik(int idPengguna) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/pengguna/get_statistik.php?id_pengguna=$idPengguna');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG STATISTIK: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('GET STATISTIK ERROR: $e');
      return {"status": "gagal", "kursus": 0, "selesai": 0, "ulasan": 0};
    }
  }

  static Future<Map<String, dynamic>> hapusAkun(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/pengguna/hapus_akun.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS AKUN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS AKUN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> uploadFoto(
      int idPengguna, File foto) async {
    try {
      final uri = Uri.parse('$baseUrl/pengguna/upload_foto.php');
      var request = http.MultipartRequest('POST', uri);
      request.fields['id'] = idPengguna.toString();
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);
      print('DEBUG UPLOAD FOTO: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPLOAD FOTO ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal upload foto: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateProgres(
      int idPendaftaran, int idPelajaran, String status) async {
    try {
      final uri = Uri.parse('$baseUrl/progres/update_progres.php');
      final response = await http.post(uri, body: {
        'id_pendaftaran': idPendaftaran.toString(),
        'id_pelajaran': idPelajaran.toString(),
        'status': status,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG UPDATE PROGRES: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPDATE PROGRES ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getProgres(int idPendaftaran) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/progres/get_progres.php?id_pendaftaran=$idPendaftaran');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG GET PROGRES: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET PROGRES ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> hapusProgres(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/progres/hapus_progres.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS PROGRES: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS PROGRES ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> resetProgres(int idPendaftaran) async {
    try {
      final uri = Uri.parse('$baseUrl/progres/reset_progres.php');
      final response = await http.post(uri, body: {
        'id_pendaftaran': idPendaftaran.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG RESET PROGRES: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('RESET PROGRES ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> tambahUlasan(
      int idPengguna, int idKursus, int rating, String komentar) async {
    try {
      final uri = Uri.parse('$baseUrl/ulasan/tambah_ulasan.php');
      final response = await http.post(uri, body: {
        'id_pengguna': idPengguna.toString(),
        'id_kursus': idKursus.toString(),
        'rating': rating.toString(),
        'komentar': komentar,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG TAMBAH ULASAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('TAMBAH ULASAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<List<dynamic>> getUlasan(int idKursus) async {
    try {
      final uri =
          Uri.parse('$baseUrl/ulasan/get_ulasan.php?id_kursus=$idKursus');
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      print('DEBUG GET ULASAN: ${response.body}');
      return _safeJsonDecode(response.body, isList: true) as List<dynamic>;
    } catch (e) {
      print('GET ULASAN ERROR: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateUlasan(
      int id, int rating, String komentar) async {
    try {
      final uri = Uri.parse('$baseUrl/ulasan/update_ulasan.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
        'rating': rating.toString(),
        'komentar': komentar,
      }).timeout(const Duration(seconds: 30));
      print('DEBUG UPDATE ULASAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('UPDATE ULASAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }

  static Future<Map<String, dynamic>> hapusUlasan(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/ulasan/hapus_ulasan.php');
      final response = await http.post(uri, body: {
        'id': id.toString(),
      }).timeout(const Duration(seconds: 30));
      print('DEBUG HAPUS ULASAN: ${response.body}');
      return _safeJsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('HAPUS ULASAN ERROR: $e');
      return {"status": "gagal", "pesan": "Gagal terhubung ke server: $e"};
    }
  }
}

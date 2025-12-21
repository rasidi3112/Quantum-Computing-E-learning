import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../services/api_service.dart';

class LessonScreen extends StatefulWidget {
  final Map<String, dynamic> pelajaran;
  final Map<String, dynamic> kursus;
  final dynamic userData;
  final int idPendaftaran;

  const LessonScreen({
    super.key,
    required this.pelajaran,
    required this.kursus,
    required this.idPendaftaran,
    this.userData,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? detail;
  bool loading = true;
  bool isCompleted = false;
  double _scrollProgress = 0.0;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Lesson navigation
  List<Map<String, dynamic>> allLessons = [];
  int currentIndex = 0;

  // Theme colors
  final Color _primaryColor = const Color(0xFF6366F1);
  final Color _secondaryColor = const Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollProgress);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _loadLessons();
    _loadDetail();
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        setState(() {
          _scrollProgress = _scrollController.offset / maxScroll;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Load all lessons for navigation
  void _loadLessons() async {
    final idKursus = int.tryParse(widget.kursus['id'].toString()) ?? 0;
    final lessons = await ApiService.getPelajaran(idKursus);

    if (lessons.isNotEmpty) {
      setState(() {
        allLessons = List<Map<String, dynamic>>.from(lessons);
        // Find current lesson index
        final currentId = widget.pelajaran['id'].toString();
        currentIndex =
            allLessons.indexWhere((l) => l['id'].toString() == currentId);
        if (currentIndex < 0) currentIndex = 0;
      });
    }
  }

  // Navigate to previous/next lesson
  void _navigateToLesson(int index) {
    if (index < 0 || index >= allLessons.length) return;

    HapticFeedback.lightImpact();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(
          pelajaran: allLessons[index],
          kursus: widget.kursus,
          idPendaftaran: widget.idPendaftaran,
          userData: widget.userData,
        ),
      ),
    );
  }

  void _loadDetail() async {
    final id = int.tryParse(widget.pelajaran['id'].toString()) ?? 0;
    final resp = await ApiService.getDetailPelajaran(id);

    setState(() {
      detail = resp;
      loading = false;
    });

    _animationController.forward();

    if (widget.idPendaftaran > 0) {
      await ApiService.updateProgres(
          widget.idPendaftaran, id, 'sedang_dipelajari');
    }
  }

  void _markAsComplete() async {
    HapticFeedback.mediumImpact();

    final idPel = int.tryParse(widget.pelajaran['id'].toString()) ?? 0;

    if (widget.idPendaftaran > 0) {
      await ApiService.updateProgres(widget.idPendaftaran, idPel, 'selesai');
    }

    setState(() => isCompleted = true);

    if (!mounted) return;

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Success Icon
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF10B981),
                                      const Color(0xFF059669),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981)
                                          .withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 56,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Luar Biasa! 🎉',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Anda telah menyelesaikan pelajaran ini.\nTerus semangat belajar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // XP Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.orange.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                '+50 XP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Tutup dialog saja
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Lanjutkan Belajar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonNumber = widget.pelajaran['urutan'] ?? '1';
    final courseTitle = widget.kursus['judul'] ?? 'Kursus';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: loading
            ? _buildLoadingState()
            : Stack(
                children: [
                  // Main Content
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Collapsing Header
                      SliverAppBar(
                        expandedHeight: 200,
                        pinned: true,
                        stretch: true,
                        backgroundColor: _primaryColor,
                        leading: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new,
                                size: 18, color: Colors.white),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        actions: [
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isCompleted
                                    ? Icons.check_circle
                                    : Icons.bookmark_border,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [_primaryColor, _secondaryColor],
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Decorative Elements
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
                                  bottom: -30,
                                  left: -30,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                // Content
                                SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 60, 20, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Course Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            courseTitle,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Lesson Number
                                        Text(
                                          'PELAJARAN $lessonNumber',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Lesson Title
                                        Text(
                                          detail?['judul'] ??
                                              widget.pelajaran['judul'] ??
                                              '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Content Body
                      SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reading Info Card
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      _buildInfoItem(
                                        Icons.access_time_rounded,
                                        '10 menit',
                                        'Waktu baca',
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.grey[200],
                                      ),
                                      _buildInfoItem(
                                        Icons.auto_stories_rounded,
                                        '${(detail?['konten_teks']?.toString().split(' ').length ?? 0)} kata',
                                        'Total kata',
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.grey[200],
                                      ),
                                      _buildInfoItem(
                                        isCompleted
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        isCompleted ? 'Selesai' : 'Belum',
                                        'Status',
                                        color: isCompleted
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Main Content Card
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: _buildMathMarkdown(
                                      detail?['konten_teks'] ?? ''),
                                ),

                                const SizedBox(height: 24),

                                // Key Points Card
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _primaryColor.withOpacity(0.1),
                                        _secondaryColor.withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _primaryColor.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.lightbulb_rounded,
                                              color: _primaryColor, size: 24),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'Poin Penting',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      _buildKeyPoint(
                                          'Pahami konsep dasar sebelum lanjut'),
                                      _buildKeyPoint(
                                          'Praktikkan dengan contoh nyata'),
                                      _buildKeyPoint(
                                          'Review kembali jika perlu'),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Reading Progress Bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 60),
                        child: LinearProgressIndicator(
                          value: _scrollProgress,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Action Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, -10),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          children: [
                            // Previous Button
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: currentIndex > 0
                                      ? _primaryColor.withOpacity(0.3)
                                      : Colors.grey[300]!,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                onPressed: currentIndex > 0
                                    ? () => _navigateToLesson(currentIndex - 1)
                                    : null,
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                  color: currentIndex > 0
                                      ? _primaryColor
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Complete Button
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed:
                                      isCompleted ? null : _markAsComplete,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isCompleted
                                        ? Colors.green
                                        : _primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isCompleted
                                            ? Icons.check_circle
                                            : Icons.check_circle_outline,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        isCompleted
                                            ? 'Sudah Selesai'
                                            : 'Tandai Selesai',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Next Button
                            Container(
                              decoration: BoxDecoration(
                                color: currentIndex < allLessons.length - 1
                                    ? _primaryColor.withOpacity(0.1)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                onPressed: currentIndex < allLessons.length - 1
                                    ? () => _navigateToLesson(currentIndex + 1)
                                    : null,
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: currentIndex < allLessons.length - 1
                                      ? _primaryColor
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
            'Memuat materi...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk render Markdown + LaTeX Math
  Widget _buildMathMarkdown(String content) {
    if (content.isEmpty) {
      return const Text('Tidak ada konten.');
    }

    // Parse content untuk memisahkan teks biasa dan formula
    final List<Widget> widgets = [];

    // Pattern untuk mencocokkan LaTeX display math: \[...\] atau $$...$$
    final mathPattern = RegExp(
      r'\\\[([\s\S]*?)\\\]|\$\$([\s\S]*?)\$\$',
      multiLine: true,
    );

    int lastEnd = 0;
    final matches = mathPattern.allMatches(content);

    for (final match in matches) {
      // Tambahkan teks sebelum formula sebagai Markdown
      if (match.start > lastEnd) {
        final textBefore = content.substring(lastEnd, match.start).trim();
        if (textBefore.isNotEmpty) {
          widgets.add(_buildMarkdownSection(textBefore));
        }
      }

      // Render formula LaTeX
      String formula = match.group(1) ?? match.group(2) ?? '';
      formula = formula.trim();

      if (formula.isNotEmpty) {
        widgets.add(_buildMathFormula(formula));
      }

      lastEnd = match.end;
    }

    // Tambahkan sisa teks setelah formula terakhir
    if (lastEnd < content.length) {
      final remaining = content.substring(lastEnd).trim();
      if (remaining.isNotEmpty) {
        widgets.add(_buildMarkdownSection(remaining));
      }
    }

    // Jika tidak ada formula, render semua sebagai Markdown
    if (widgets.isEmpty) {
      widgets.add(_buildMarkdownSection(content));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  // Widget untuk render section Markdown
  Widget _buildMarkdownSection(String text) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
        h2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
        h3: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
        p: TextStyle(
          fontSize: 15,
          height: 1.7,
          color: Colors.grey[700],
        ),
        listBullet: TextStyle(
          fontSize: 15,
          color: _primaryColor,
        ),
        code: TextStyle(
          fontSize: 14,
          backgroundColor: Colors.grey[100],
          color: Colors.indigo[700],
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        blockquoteDecoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: _primaryColor,
              width: 4,
            ),
          ),
        ),
        blockquote: TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: Colors.grey[700],
        ),
        strong: const TextStyle(fontWeight: FontWeight.bold),
        em: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  // Widget untuk render formula LaTeX
  Widget _buildMathFormula(String formula) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.functions, color: _primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Formula',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Math.tex(
                formula,
                textStyle: const TextStyle(fontSize: 18),
                mathStyle: MathStyle.display,
                onErrorFallback: (error) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formula,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'monospace',
                        color: Colors.grey[800],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label,
      {Color? color}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color ?? _primaryColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color ?? Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

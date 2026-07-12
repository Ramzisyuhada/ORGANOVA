  import 'dart:ui';

  import 'package:flutter/material.dart';
  import 'package:flutter_animate/flutter_animate.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:organova/feature/ppt_viewer_screen.dart';
  import 'package:organova/feature/video_screen.dart';

  class MateriScreen extends StatelessWidget {
    const MateriScreen({super.key});

    /// Item "ppt" menampilkan slide berbasis gambar dari folder assets.
    /// Item "video" memutar file MP4 dari folder assets/video.
    final List<Map<String, dynamic>> materi = const [
      {
        "title": "PPT Materi",
        "type": "ppt",
        "folder": "assets/materi",
        "count": 21,
        "extension": "jpg",
      },
      {
        "title": "Video Pembelajaran",
        "type": "video",
        "file": "assets/video/intro.mp4",
      },
    ];

    List<String> _buildImagePaths(
      String folder,
      int count, {
      String extension = 'jpg',
    }) {
      final cleanFolder = folder.replaceAll(RegExp(r'/+$'), '');
      return List.generate(count, (i) => '$cleanFolder/${i + 1}.$extension');
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Materi',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEEF2FF),
                    Color(0xFFE0E7FF),
                    Color(0xFFF8FAFF),
                  ],
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: materi.length,
              itemBuilder: (context, index) {
                final item = materi[index];
                final isPpt = item['type'] == 'ppt';

                return GestureDetector(
                  onTap: () {
                    if (isPpt) {
                      final images = _buildImagePaths(
                        item['folder'] as String,
                        (item['count'] as int?) ?? 0,
                        extension: item['extension'] as String? ?? 'jpg',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PptViewerScreen(
                            title: item['title'] as String,
                            images: images,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerScreen(
                            title: item['title'] as String,
                            file: item['file'] as String,
                          ),
                        ),
                      );
                    }
                  },
                  child: _card(item)
                      .animate()
                      .fadeIn(delay: (100 * index).ms)
                      .slideY(begin: 0.2),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget _card(Map item) {
      final isVideo = item['type'] == 'video';

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    isVideo ? Icons.play_circle : Icons.slideshow,
                    color: isVideo ? Colors.red : Colors.indigo,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['title'],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
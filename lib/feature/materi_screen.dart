import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/pdf_screen.dart';
import 'package:organova/feature/video._screen.dart';


class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  final List<Map<String, dynamic>> materi = const [
    {
      "title": "Model Likert",
      "type": "ppt",
      "file": "assets/materi/likert.pdf"
    },
    {
      "title": "Leadership Continuum",
      "type": "ppt",
      "file": "assets/materi/leadership.pdf"
    },
    {
      "title": "Video Pembelajaran",
      "type": "video",
      "file": "assets/video/intro.mp4"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Materi",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [

          /// BACKGROUND
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

          /// LIST
          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: materi.length,
            itemBuilder: (context, index) {
              final item = materi[index];

              return GestureDetector(
                onTap: () {
                  if (item["type"] == "ppt") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PdfViewerScreen(file: item["file"]),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VideoPlayerScreen(file: item["file"]),
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
    final isVideo = item["type"] == "video";

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
                  isVideo ? Icons.play_circle : Icons.picture_as_pdf,
                  color: isVideo ? Colors.red : Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item["title"],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
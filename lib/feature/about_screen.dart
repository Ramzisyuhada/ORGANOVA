import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tentang Aplikasi",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [

          /// Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEEF2FF),
                  Color(0xFFE0E7FF),
                  Color(0xFFF8FAFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Animation
                Center(
                  child: SizedBox(
                    height: 120,
                    child: Lottie.asset("assets/ai.json"),
                  ),
                ).animate().fadeIn().scale(),

                const SizedBox(height: 20),

                /// Title
                Text(
                  "LEXIMPACT AI",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// Description
                _glassText(
                  "Aplikasi ini merupakan simulasi pembelajaran berbasis AI "
                  "yang dirancang untuk membantu mahasiswa memahami konsep "
                  "kepemimpinan melalui pengalaman langsung.",
                ),

                const SizedBox(height: 20),

                /// Section
                _section(
                  "Tujuan",
                  "Membantu pengguna memahami gaya kepemimpinan dan "
                  "pengambilan keputusan dalam organisasi.",
                ),

                _section(
                  "Teknologi",
                  "Menggunakan AI untuk menghasilkan studi kasus, "
                  "simulasi respon organisasi, dan evaluasi keputusan.",
                ),

               

                const SizedBox(height: 30),

                /// Developer Section
                Text(
                  "Developer",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _developerCard(
                  name: "Nama Kamu",
                  role: "Mobile Developer",
                  desc:
                      "Pengembang aplikasi pembelajaran berbasis simulasi dan AI dengan fokus pada pengalaman pengguna.",
                  email: "email@example.com",
                ),

                const SizedBox(height: 30),

                Center(
                  child: Text(
                    "Organova © 2026",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Glass Text
  Widget _glassText(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(),
          ),
        ),
      ),
    );
  }

  /// Section
  Widget _section(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          _glassText(desc),
        ],
      ),
    );
  }

  /// Developer Card
  Widget _developerCard({
    required String name,
    required String role,
    required String desc,
    required String email,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            children: [

              /// Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Icon(Icons.person),
              ),

              const SizedBox(width: 12),

              /// Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
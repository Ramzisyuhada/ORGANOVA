import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Viewer slide berbasis gambar (pengganti SfPdfViewer).
/// Menerima daftar path asset gambar (hasil konversi dari PDF),
/// ditampilkan sebagai slide yang bisa di-swipe + tombol next/prev.
class PptViewerScreen extends StatefulWidget {
  const PptViewerScreen({
    super.key,
    required this.title,
    required this.images,
  });

  final String title;
  final List<String> images;

  @override
  State<PptViewerScreen> createState() => _PptViewerScreenState();
}

class _PptViewerScreenState extends State<PptViewerScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentPage + 1} / $total',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
      body: total == 0
          ? Center(
              child: Text(
                'Tidak ada slide untuk ditampilkan',
                style: GoogleFonts.poppins(color: Colors.black54),
              ),
            )
          : Column(
              children: [
                Expanded(child: _buildSlideViewer()),
                const SizedBox(height: 8),
                _buildIndicator(),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _buildSlideViewer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 40),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 200.ms);
          },
        ),

        if (_currentPage > 0)
          Positioned(
            left: 8,
            child: _NavButton(
              icon: Icons.chevron_left,
              onTap: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              ),
            ),
          ),

        if (_currentPage < widget.images.length - 1)
          Positioned(
            right: 8,
            child: _NavButton(
              icon: Icons.chevron_right,
              onTap: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIndicator() {
    return SizedBox(
      height: 16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final isActive = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.indigo : Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
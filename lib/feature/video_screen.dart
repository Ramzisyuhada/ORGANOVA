import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

/// Player video pembelajaran. Mendukung file dari asset lokal (mis.
/// "assets/video/intro.mp4") maupun URL network (otomatis terdeteksi).
/// Kontrol custom: play/pause, seek bar dengan buffer indicator,
/// durasi berjalan, mute, dan mode fullscreen (landscape).
class VideoPlayerScreen extends StatefulWidget {
  final String file;
  final String? title;

  const VideoPlayerScreen({super.key, required this.file, this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  Timer? _hideControlsTimer;
  bool _showControls = true;
  bool _isFullscreen = false;
  bool _isMuted = false;
  bool _isInitError = false;

  bool get _isMp4 {
    final uri = Uri.tryParse(widget.file);
    final path = (uri?.path ?? widget.file).toLowerCase();
    return path.endsWith('.mp4');
  }

  bool get _isNetwork =>
      widget.file.startsWith('http://') || widget.file.startsWith('https://');

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    if (!_isMp4) {
      setState(() => _isInitError = true);
      return;
    }

    _controller = _isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(widget.file))
        : VideoPlayerController.asset(widget.file);

    _controller!
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {});
          _controller!.play();
          _startHideTimer();
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _isInitError = true);
        });

    _controller!.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      final controller = _controller;
      if (mounted && controller != null && controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;

    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
    _startHideTimer();
  }

  void _toggleMute() {
    final controller = _controller;
    if (controller == null) return;

    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  Future<void> _toggleFullscreen() async {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller?.dispose();
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                widget.title ?? 'Video Pembelajaran',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
      body: SafeArea(
        top: !_isFullscreen,
        bottom: false,
        child: Center(
          child: _isInitError
              ? _errorState()
              : _controller?.value.isInitialized == true
              ? _videoBody()
              : const CircularProgressIndicator(color: Colors.indigoAccent),
        ),
      ),
    );
  }

  Widget _errorState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white38, size: 48),
          const SizedBox(height: 12),
          Text(
            'Video harus berformat MP4',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.file,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _videoBody() {
    final controller = _controller;
    if (controller == null) {
      return _errorState();
    }

    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio == 0
                ? 16 / 9
                : controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),

          // overlay gradient + kontrol
          AnimatedOpacity(
            opacity: _showControls ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0, 0.25, 0.6, 1],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 8),

                    // tombol play/pause besar di tengah
                    Expanded(
                      child: Center(
                        child: IconButton(
                          iconSize: 56,
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          onPressed: _togglePlay,
                        ),
                      ),
                    ),

                    // bar bawah: seek + waktu + mute + fullscreen
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            colors: VideoProgressColors(
                              playedColor: Colors.indigoAccent,
                              bufferedColor: Colors.white38,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _formatDuration(controller.value.position),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                ' / ${_formatDuration(controller.value.duration)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  _isMuted ? Icons.volume_off : Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: _toggleMute,
                              ),
                              IconButton(
                                icon: Icon(
                                  _isFullscreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                onPressed: _toggleFullscreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

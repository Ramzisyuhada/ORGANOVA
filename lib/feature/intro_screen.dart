import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/scene2_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int index = 0;

  final List<Map<String, String>> dialogs = [
    {
      "text": "Selamat, Anda ditunjuk sebagai Manager Divisi Operasional.",
      "emotion": "Confident",
      "audio": "audio/confident.mp3",
    },
    {
      "text":
          "Organisasi saat ini mengalami penurunan kinerja dan konflik tim.",
      "emotion": "Worried",
      "audio": "audio/worried.mp3",
    },
    {
      "text": "Anda perlu memahami kondisi tim sebelum mengambil keputusan.",
      "emotion": "Thinking",
      "audio": "audio/thinking.mp3",
    },
    {
      "text": "Keputusan Anda akan mempengaruhi hasil organisasi.",
      "emotion": "Talking",
      "audio": "audio/talking.mp3",
    },
  ];

  String displayedText = "";
  Timer? timer;
  int charIndex = 0;
  bool isTyping = true;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool enableVoice = true;

  @override
  void initState() {
    super.initState();
    startTyping();
  }

  Future<void> playVoice(String? path) async {
    if (!enableVoice || path == null) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("Audio tidak ditemukan: $path");
    }
  }

  void startTyping() {
    timer?.cancel();
    displayedText = "";
    charIndex = 0;
    isTyping = true;

    final current = dialogs[index];
    final fullText = current["text"]!;

    //playVoice(current["audio"]);

    timer = Timer.periodic(const Duration(milliseconds: 28), (t) {
      if (charIndex < fullText.length) {
        setState(() {
          displayedText += fullText[charIndex];
          charIndex++;
        });
      } else {
        isTyping = false;
        t.cancel();
      }
    });
  }

  void nextDialog() async {
    if (isTyping) {
      timer?.cancel();
      setState(() {
        displayedText = dialogs[index]["text"]!;
        isTyping = false;
      });
      return;
    }

    if (index < dialogs.length - 1) {
      setState(() => index++);
      startTyping();
    } else {
      await _audioPlayer.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Scene2Screen()),
      );
    }
  }

  String getCharacterImage(String emotion) {
    switch (emotion) {
      case "Angry":
        return "assets/game/player/Angry.png";
      case "Happy":
        return "assets/game/player/Happy.png";
      case "Thinking":
        return "assets/game/player/Thinking.png";
      case "Talking":
        return "assets/game/player/Talking.png";
      case "Confident":
        return "assets/game/player/Confident.png";
      case "Worried":
        return "assets/game/player/Worried.png";
      default:
        return "assets/game/player/Idle.png";
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// 🧊 GLASS DIALOG BOX — improved typography
  Widget _dialogBox(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.28), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Speaker label
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B8CFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "NARATOR",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF7B8CFF),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Main dialog text
              Text(
                text + (isTyping ? "▌" : ""),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.65,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = dialogs[index];
    final progress = (index + 1) / dialogs.length;

    return Scaffold(
      body: Stack(
        children: [
          /// 🌄 BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/game/background/background.png",
              fit: BoxFit.cover,
            ),
          ),

          /// 🎬 CINEMATIC OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🔝 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: title + progress
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SIMULASI KEPEMIMPINAN",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 5,
                                backgroundColor: Colors.white.withOpacity(0.15),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF7B8CFF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right: dialog counter + volume
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              "${index + 1} / ${dialogs.length}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: Icon(
                              enableVoice
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_off_rounded,
                              color: Colors.white70,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() => enableVoice = !enableVoice);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// 🎭 CHARACTER ANIMATION
                  AnimatedScale(
                    scale: isTyping ? 1.03 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      getCharacterImage(current["emotion"]!),
                      height: 240,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 💬 DIALOG BOX — tap to skip or continue
                  GestureDetector(
                    onTap: nextDialog,
                    child: AnimatedScale(
                      scale: isTyping ? 1 : 0.985,
                      duration: const Duration(milliseconds: 100),
                      child: _dialogBox(displayedText),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 👉 HINT ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Scene indicator dots
                      Row(
                        children: List.generate(dialogs.length, (i) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: i == index ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == index
                                  ? const Color(0xFF7B8CFF)
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      // Tap hint
                      Row(
                        children: [
                          Text(
                            isTyping ? "Mengetik..." : "Tap untuk lanjut",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isTyping
                                ? Icons.more_horiz
                                : Icons.arrow_forward_ios,
                            size: 13,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

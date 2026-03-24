import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
      "audio": "audio/confident.mp3"
    },
    {
      "text": "Organisasi saat ini mengalami penurunan kinerja dan konflik tim.",
      "emotion": "Worried",
      "audio": "audio/worried.mp3"
    },
    {
      "text": "Anda perlu memahami kondisi tim sebelum mengambil keputusan.",
      "emotion": "Thinking",
      "audio": "audio/thinking.mp3"
    },
    {
      "text": "Keputusan Anda akan mempengaruhi hasil organisasi.",
      "emotion": "Talking",
      "audio": "audio/talking.mp3"
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

    timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
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
    MaterialPageRoute(
      builder: (context) => Scene2Screen(),
    ),
  );    }
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

  /// 🧊 GLASS DIALOG
  Widget _dialogBox(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Text(
            text + (isTyping ? "|" : ""),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
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
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
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
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor:
                                Colors.white.withOpacity(0.2),
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xFF7B8CFF)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      IconButton(
                        icon: Icon(
                          enableVoice
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => enableVoice = !enableVoice);
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Simulasi Kepemimpinan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  /// 🎭 CHARACTER ANIMATION
                  AnimatedScale(
                    scale: isTyping ? 1.05 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      getCharacterImage(current["emotion"]!),
                      height: 240,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 💬 DIALOG
                  GestureDetector(
                    onTap: nextDialog,
                    child: AnimatedScale(
                      scale: isTyping ? 1 : 0.98,
                      duration: const Duration(milliseconds: 100),
                      child: _dialogBox(displayedText),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 👉 HINT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isTyping ? "Mengetik..." : "Tap untuk lanjut",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.white70)
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
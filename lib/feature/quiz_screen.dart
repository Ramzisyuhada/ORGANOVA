import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  int score = 0;
  int? selected;
  bool answered = false;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "Apa itu kepemimpinan?",
      "options": [
        "Memaksa orang",
        "Mempengaruhi orang",
        "Mengontrol tim",
        "Memberi perintah"
      ],
      "answer": 1
    },
    {
      "question": "Model Likert ada berapa?",
      "options": ["2", "3", "4", "5"],
      "answer": 2
    },
    {
      "question": "Gaya demokratis termasuk?",
      "options": [
        "Otoriter",
        "Partisipatif",
        "Eksploitatif",
        "Pasif"
      ],
      "answer": 1
    },
  ];

  /// 🎯 HITUNG NILAI
  int get nilai => ((score / questions.length) * 100).round();

  /// 🎯 KATEGORI NILAI
  String get kategori {
    if (nilai >= 85) return "Sangat Baik";
    if (nilai >= 70) return "Baik";
    if (nilai >= 50) return "Cukup";
    return "Perlu Belajar";
  }

  /// 🎨 WARNA NILAI
  Color get nilaiColor {
    if (nilai >= 85) return Colors.green;
    if (nilai >= 70) return Colors.blue;
    if (nilai >= 50) return Colors.orange;
    return Colors.red;
  }

  void selectAnswer(int i) {
    if (answered) return;

    setState(() {
      selected = i;
      answered = true;
    });

    if (i == questions[index]["answer"]) {
      score++;
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (index < questions.length - 1) {
        setState(() {
          index++;
          selected = null;
          answered = false;
        });
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: _resultCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = questions[index];
    final progress = (index + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kuis",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
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

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// PROGRESS
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                ),

                const SizedBox(height: 10),

                /// NILAI REALTIME
                Text(
                  "Nilai: $nilai",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: nilaiColor,
                  ),
                ),

                const SizedBox(height: 20),

                /// QUESTION
                _glass(
                  child: Text(
                    current["question"],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.2),

                const SizedBox(height: 20),

                /// OPTIONS
                ...List.generate(current["options"].length, (i) {
                  return GestureDetector(
                    onTap: () => selectAnswer(i),
                    child: _optionCard(
                      text: current["options"][i],
                      indexOption: i,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// GLASS
  Widget _glass({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ),
    );
  }

  /// OPTION CARD
  Widget _optionCard({
    required String text,
    required int indexOption,
  }) {
    final correctIndex = questions[index]["answer"];

    bool isCorrect = indexOption == correctIndex;
    bool isSelected = indexOption == selected;

    Color bg = Colors.white.withOpacity(0.2);
    Color border = Colors.transparent;

    if (answered) {
      if (isCorrect) {
        bg = Colors.green.withOpacity(0.4);
        border = Colors.green;
      } else if (isSelected) {
        bg = Colors.red.withOpacity(0.4);
        border = Colors.red;
      }
    } else if (isSelected) {
      border = Colors.blue;
    }

    return AnimatedScale(
      scale: isSelected ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border, width: 2),
              ),
              child: Text(
                text,
                style: GoogleFonts.poppins(),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }

  /// RESULT CARD
  Widget _resultCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Hasil Kuis",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "$nilai",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: nilaiColor,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                kategori,
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    index = 0;
                    score = 0;
                    selected = null;
                    answered = false;
                  });
                },
                child: const Text("Ulangi"),
              )
            ],
          ),
        ),
      ),
    ).animate().scale().fadeIn();
  }
}
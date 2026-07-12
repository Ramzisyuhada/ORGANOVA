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
    "question": "Kepemimpinan dalam organisasi pada dasarnya merupakan proses untuk...",
    "options": [
      "Mengontrol seluruh aktivitas organisasi",
      "Mempengaruhi individu atau kelompok untuk mencapai tujuan",
      "Menghukum anggota yang tidak disiplin",
      "Mengawasi pekerjaan bawahan secara ketat"
    ],
    "answer": 1
  },
  {
    "question": "Menurut Robbins dan Judge (2017), kepemimpinan adalah...",
    "options": [
      "Cara mengatur organisasi secara formal",
      "Kemampuan mempengaruhi kelompok untuk mencapai visi atau tujuan",
      "Sistem pengawasan karyawan",
      "Proses evaluasi kinerja pegawai"
    ],
    "answer": 1
  },
  {
    "question": "Leadership Continuum dikembangkan oleh...",
    "options": [
      "Robbins dan Judge",
      "Peter Drucker",
      "Robert Tannenbaum dan Warren H. Schmidt",
      "Kurt Lewin"
    ],
    "answer": 2
  },
  {
    "question": "Leadership Continuum pertama kali dipublikasikan pada tahun...",
    "options": [
      "1945",
      "1958",
      "1975",
      "1989"
    ],
    "answer": 1
  },
  {
    "question": "Konsep utama Leadership Continuum menyatakan bahwa gaya kepemimpinan berada pada spektrum antara...",
    "options": [
      "Demokratis dan transformasional",
      "Otoriter dan demokratis",
      "Karismatik dan birokratis",
      "Transaksional dan visioner"
    ],
    "answer": 1
  },
  {
    "question": "Pada spektrum Leadership Continuum gaya kepemimpinan yang memberi kontrol penuh kepada pemimpin disebut...",
    "options": [
      "Subordinate-centered leadership",
      "Leader-centered leadership",
      "Transformational leadership",
      "Participative leadership"
    ],
    "answer": 1
  },
  {
    "question": "Gaya kepemimpinan yang memberikan partisipasi besar kepada bawahan disebut...",
    "options": [
      "Leader-centered leadership",
      "Subordinate-centered leadership",
      "Directive leadership",
      "Bureaucratic leadership"
    ],
    "answer": 1
  },
  {
    "question": "Model pertama dalam Leadership Continuum adalah...",
    "options": [
      "Consult",
      "Join",
      "Tell",
      "Delegate"
    ],
    "answer": 2
  },
  {
    "question": "Pada model Tell pemimpin biasanya...",
    "options": [
      "Meminta saran dari tim",
      "Menyerahkan keputusan kepada bawahan",
      "Membuat keputusan sendiri dan mengumumkannya",
      "Mengajak tim berdiskusi sebelum mengambil keputusan"
    ],
    "answer": 2
  },
  {
    "question": "Karakteristik utama gaya kepemimpinan Tell adalah...",
    "options": [
      "Demokratis",
      "Otoriter",
      "Partisipatif",
      "Transformasional"
    ],
    "answer": 1
  },
  {
    "question": "Model kepemimpinan Sell berarti pemimpin...",
    "options": [
      "Menjual ide kepada investor",
      "Membuat keputusan dan menjelaskan alasan kepada bawahan",
      "Memberi keputusan kepada tim",
      "Menyerahkan keputusan sepenuhnya kepada bawahan"
    ],
    "answer": 1
  },
  {
    "question": "Tujuan pemimpin menggunakan gaya Sell adalah...",
    "options": [
      "Agar bawahan membuat keputusan",
      "Agar bawahan menerima keputusan yang sudah dibuat",
      "Agar bawahan mengganti keputusan",
      "Agar pemimpin tidak bertanggung jawab"
    ],
    "answer": 1
  },
  {
    "question": "Dalam model Suggest, pemimpin...",
    "options": [
      "Tidak menjelaskan keputusan",
      "Menjelaskan keputusan dan membuka kesempatan bertanya",
      "Menyerahkan keputusan kepada bawahan",
      "Memberikan kebebasan penuh kepada tim"
    ],
    "answer": 1
  },
  {
    "question": "Pada model Consult, pemimpin...",
    "options": [
      "Memberikan keputusan final tanpa diskusi",
      "Menyerahkan semua keputusan kepada tim",
      "Memberikan keputusan sementara dan meminta masukan tim",
      "Menghindari pengambilan keputusan"
    ],
    "answer": 2
  },
  {
    "question": "Model Join menunjukkan bahwa pemimpin...",
    "options": [
      "Mengambil keputusan sendiri",
      "Menjelaskan masalah dan meminta saran dari tim",
      "Tidak melibatkan tim",
      "Mengontrol semua keputusan"
    ],
    "answer": 1
  },
  {
    "question": "Dalam model Delegate, pemimpin...",
    "options": [
      "Menyerahkan keputusan sepenuhnya tanpa batasan",
      "Menentukan batasan dan tim menentukan solusi",
      "Mengambil keputusan tanpa diskusi",
      "Tidak memiliki peran dalam tim"
    ],
    "answer": 1
  },
  {
    "question": "Model Abdicate menggambarkan kondisi ketika...",
    "options": [
      "Pemimpin mengontrol penuh keputusan",
      "Pemimpin memberikan kebebasan penuh kepada tim",
      "Pemimpin memberikan arahan detail",
      "Pemimpin menentukan semua kebijakan"
    ],
    "answer": 1
  },
  {
    "question": "Dalam model Abdicate, peran pemimpin lebih sebagai...",
    "options": [
      "Pengontrol",
      "Supervisor",
      "Fasilitator",
      "Direktur"
    ],
    "answer": 2
  },
  {
    "question": "Salah satu fungsi utama kepemimpinan dalam organisasi adalah...",
    "options": [
      "Mengurangi jumlah karyawan",
      "Menentukan arah organisasi",
      "Menghapus struktur organisasi",
      "Menghindari konflik"
    ],
    "answer": 1
  },
  {
    "question": "Fungsi kepemimpinan yang berkaitan dengan menjaga semangat kerja anggota tim adalah...",
    "options": [
      "Koordinasi",
      "Motivasi",
      "Delegasi",
      "Administrasi"
    ],
    "answer": 1
  },
  {
    "question": "Faktor yang mempengaruhi gaya kepemimpinan dari sisi pemimpin adalah...",
    "options": [
      "Gaji karyawan",
      "Nilai pribadi dan pengalaman pemimpin",
      "Jumlah karyawan",
      "Lokasi kantor"
    ],
    "answer": 1
  },
  {
    "question": "Salah satu faktor dari struktural yang mempengaruhi gaya kepemimpinan adalah...",
    "options": [
      "Ukuran organisasi",
      "Kompetensi bawahan",
      "Sistem teknologi",
      "Struktur organisasi"
    ],
    "answer": 3
  },
  {
    "question": "Jika bawahan memiliki kompetensi tinggi, gaya kepemimpinan yang lebih sesuai adalah...",
    "options": [
      "Otoriter",
      "Kontrol penuh pemimpin",
      "Lebih partisipatif",
      "Tidak ada kepemimpinan"
    ],
    "answer": 2
  },
  {
    "question": "Faktor situasi yang mempengaruhi gaya kepemimpinan antara lain...",
    "options": [
      "Budaya organisasi",
      "Hobi pemimpin",
      "Warna logo perusahaan",
      "Jenis kendaraan perusahaan"
    ],
    "answer": 0
  },
  {
    "question": "Tekanan waktu dalam organisasi biasanya membuat pemimpin menggunakan gaya...",
    "options": [
      "Lebih demokratis",
      "Lebih partisipatif",
      "Lebih otoriter",
      "Tidak mengambil keputusan"
    ],
    "answer": 2
  },
  {
    "question": "Salah satu kelebihan Leadership Continuum adalah...",
    "options": [
      "Tidak membutuhkan analisis pemimpin",
      "Fleksibel terhadap situasi organisasi",
      "Menghilangkan peran bawahan",
      "Menyederhanakan komunikasi dalam organisasi"
    ],
    "answer": 1
  },
  {
    "question": "Pendekatan Leadership Continuum dianggap fleksibel karena...",
    "options": [
      "Gaya kepemimpinan dapat berubah sesuai situasi",
      "Pemimpin selalu mengambil keputusan sendiri",
      "Bawahan tidak terlibat dalam organisasi",
      "Organisasi tidak memiliki aturan"
    ],
    "answer": 0
  },
  {
    "question": "Salah satu kelemahan pendekatan Leadership Continuum adalah...",
    "options": [
      "Tidak memerlukan pemimpin",
      "Proses keputusan dapat menjadi lebih lama",
      "Tidak memerlukan komunikasi",
      "Tidak membutuhkan analisis situasi"
    ],
    "answer": 1
  },
  {
    "question": "Pemimpin yang efektif menurut teori Leadership Continuum adalah pemimpin yang...",
    "options": [
      "Selalu otoriter",
      "Selalu demokratis",
      "Mampu menyesuaikan gaya kepemimpinan dengan situasi",
      "Tidak melibatkan tim"
    ],
    "answer": 2
  },
  {
    "question": "Leadership Continuum menunjukkan bahwa kepemimpinan adalah...",
    "options": [
      "Sistem tetap yang tidak berubah",
      "Spektrum gaya kepemimpinan yang fleksibel",
      "Struktur organisasi formal",
      "Sistem kontrol karyawan"
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
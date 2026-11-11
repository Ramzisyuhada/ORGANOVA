"""Create a manual variant that includes the captured simulation flow."""

from pathlib import Path
from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.shared import Cm, Pt

SOURCE = Path("Panduan_Penggunaan_Aplikasi_Organova_Screenshot_Asli.docx")
OUTPUT = Path("Panduan_Penggunaan_Aplikasi_Organova_Semua_Halaman.docx")
OUTPUT_COPY = Path("docs/Panduan_Penggunaan_Aplikasi_Organova_Semua_Halaman.docx")
SIM = Path("assets/screenshots/actual/simulasi")

figures = [
    ("simulasi_01_intro.png", "Gambar A.1 Tampilan Dialog Pembuka Simulasi"),
    ("simulasi_02_intro.png", "Gambar A.2 Tampilan Lanjutan Narasi Simulasi"),
    ("simulasi_03_intro.png", "Gambar A.3 Tampilan Analisis Kondisi Tim"),
    ("simulasi_04_intro.png", "Gambar A.4 Tampilan Konsekuensi Keputusan"),
    ("simulasi_05_profil_organisasi.png", "Gambar A.5 Profil Organisasi yang Dihasilkan AI"),
    ("simulasi_06_diagnosis_kepemimpinan.png", "Gambar A.6 Pilihan Diagnosis Kepemimpinan"),
    ("simulasi_07_hasil_diagnosis.png", "Gambar A.7 Hasil Diagnosis Kepemimpinan"),
    ("simulasi_08_kontrol_kepemimpinan.png", "Gambar A.8 Pengaturan Tingkat Kontrol Kepemimpinan"),
    ("simulasi_09_hasil_kontrol.png", "Gambar A.9 Hasil Analisis Tingkat Kontrol"),
    ("simulasi_10_kesiapan_tim.png", "Gambar A.10 Analisis Kesiapan Tim"),
    ("simulasi_11_hasil_kesiapan_tim.png", "Gambar A.11 Hasil Evaluasi Kesiapan Tim"),
    ("simulasi_12_simulasi_krisis.png", "Gambar A.12 Pilihan Strategi Simulasi Krisis"),
    ("simulasi_13_hasil_krisis.png", "Gambar A.13 Dampak Keputusan Krisis"),
    ("simulasi_14_dashboard_kinerja.png", "Gambar A.14 Dashboard Kinerja Organisasi"),
    ("simulasi_15_ai_coaching.png", "Gambar A.15 Halaman AI Coaching dan Refleksi"),
]

for filename, _ in figures:
    if not (SIM / filename).is_file():
        raise FileNotFoundError(SIM / filename)

document = Document(SOURCE)
document.add_page_break()
document.add_heading("LAMPIRAN A: DOKUMENTASI SELURUH ALUR SIMULASI", level=1)

intro = document.add_paragraph(
    "Lampiran ini memuat tangkapan layar runtime dari alur simulasi kepemimpinan "
    "Organova. Tampilan berikut diambil langsung dari aplikasi web lokal pada saat "
    "simulasi dijalankan."
)
intro.paragraph_format.space_after = Pt(8)

for index, (filename, caption) in enumerate(figures):
    if index:
        document.add_page_break()
    paragraph = document.add_paragraph()
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    paragraph.add_run().add_picture(str(SIM / filename), width=Cm(7.0))
    caption_paragraph = document.add_paragraph(style="Caption")
    caption_paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    caption_paragraph.add_run(caption)

document.save(OUTPUT)
OUTPUT_COPY.write_bytes(OUTPUT.read_bytes())
print(f"Created {OUTPUT} with {len(figures)} simulation screenshots")

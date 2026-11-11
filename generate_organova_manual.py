"""
Script Generator: Panduan Penggunaan Aplikasi ORGANOVA
Menghasilkan dokumen Word (.docx) profesional dan presisi tinggi untuk laporan/publikasi.
Termasuk pembuatan 17 gambar UI screenshot/ilustrasi menggunakan Pillow (PIL).
"""

import os
from PIL import Image, ImageDraw, ImageFont
from docx import Document
from docx.shared import Pt, Cm, RGBColor, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.table import WD_TABLE_ALIGNMENT
import docx.oxml as oxml
from docx.oxml.ns import qn

# ─────────────────────────────────────────────
# KONSTANTA & PATH
# ─────────────────────────────────────────────
BASE_DIR        = r"d:\Flutter\organova"
OUTPUT_DOCX     = os.path.join(BASE_DIR, "Panduan_Penggunaan_Aplikasi_Organova.docx")
OUTPUT_DOCX_DOC = os.path.join(BASE_DIR, "docs", "Panduan_Penggunaan_Aplikasi_Organova.docx")
IMG_DIR         = os.path.join(BASE_DIR, "assets", "screenshots")

os.makedirs(IMG_DIR, exist_ok=True)
os.makedirs(os.path.join(BASE_DIR, "docs"), exist_ok=True)

APP_NAME        = "ORGANOVA"
APP_SUBTITLE    = "Simulasi Kepemimpinan dan Pengambilan Keputusan Organisasi"
APP_VERSION     = "1.0"
DEVELOPER       = "Ramzi Syuhada"
YEAR            = "2026"

# ─────────────────────────────────────────────
# WARNA PALET DOKUMEN & UI
# ─────────────────────────────────────────────
C_NAVY      = (26,  58, 108)   # #1A3A6C - Heading 1 & Cover Accent
C_DARK_BLUE = (46,  64,  87)   # #2E4057 - Heading 2 & Table Subheaders
C_PRIMARY   = (74, 108, 247)   # #4A6CF7 - Heading 3 & Primary UI Blue
C_WHITE     = (255,255,255)
C_GREY_TXT  = (100,116,139)   # #64748B
C_BG_CARD   = (241,245,249)   # #F1F5F9
C_DARK_BG   = (15,  23,  42)   # #0F172A - UI Dark theme

# ─────────────────────────────────────────────
# GENERATOR GAMBAR UI / SCREENSHOTS (PIL)
# ─────────────────────────────────────────────

def get_font(size=14, bold=False):
    try:
        if bold:
            return ImageFont.truetype("arialbd.ttf", size)
        return ImageFont.truetype("arial.ttf", size)
    except Exception:
        return ImageFont.load_default()

def create_base_phone(title="ORGANOVA"):
    """Membuat bingkai HP smartphone 540x960 px."""
    w, h = 540, 960
    img = Image.new("RGBA", (w, h), (15, 23, 42, 255)) # Dark navy theme
    draw = ImageDraw.Draw(img)
    
    # Status bar atas
    draw.rectangle([0, 0, w, 36], fill=(30, 41, 59))
    font_sm = get_font(12, bold=True)
    draw.text((20, 10), "09:41", fill=(255, 255, 255), font=font_sm)
    draw.text((w - 70, 10), "5G  100%", fill=(255, 255, 255), font=font_sm)
    
    # App Bar
    draw.rectangle([0, 36, w, 90], fill=(30, 58, 138))
    font_hdr = get_font(18, bold=True)
    draw.text((20, 50), title, fill=(255, 255, 255), font=font_hdr)
    
    # Top right avatar/badge
    draw.ellipse([w - 60, 44, w - 16, 82], fill=(74, 108, 247))
    draw.text((w - 47, 52), "S", fill=(255, 255, 255), font=get_font(16, bold=True))
    
    # Bottom Nav Bar
    draw.rectangle([0, h - 60, w, h], fill=(30, 41, 59))
    draw.rectangle([w//2 - 60, h - 12, w//2 + 60, h - 6], fill=(200, 200, 200)) # Home indicator
    
    return img, draw

def render_fig_1():
    img, draw = create_base_phone("ORGANOVA - Beranda")
    w, h = 540, 960
    
    # User profile header card
    draw.rounded_rectangle([20, 105, w-20, 195], radius=16, fill=(30, 41, 59), outline=(74, 108, 247), width=2)
    draw.ellipse([35, 120, 95, 180], fill=(74, 108, 247))
    draw.text((55, 135), "S", fill=(255,255,255), font=get_font(24, bold=True))
    
    draw.text((115, 120), "Stevi - Divisi Operasional", fill=(255,255,255), font=get_font(16, bold=True))
    draw.text((115, 145), "Level 5  |  XP: 1,250 / 2,000", fill=(200,210,254), font=get_font(13))
    draw.rounded_rectangle([115, 168, 320, 178], radius=5, fill=(51, 65, 85))
    draw.rounded_rectangle([115, 168, 240, 178], radius=5, fill=(74, 108, 247))
    
    # Banner Mulai Simulasi
    draw.rounded_rectangle([20, 215, w-20, 360], radius=16, fill=(74, 108, 247))
    draw.text((40, 235), "SIMULASI KEPEMIMPINAN", fill=(255,255,255), font=get_font(18, bold=True))
    draw.text((40, 268), "Skenario 2: Krisis Konflik Tim Operasional", fill=(224,231,255), font=get_font(13))
    
    draw.rounded_rectangle([40, 300, 220, 340], radius=10, fill=(255,255,255))
    draw.text((65, 310), "Mulai Simulasi", fill=(30,58,138), font=get_font(14, bold=True))
    
    # Grid Menu Belajar
    menus = [
        ("📚  Materi", "Konsep Kepemimpinan"),
        ("🎥  Video", "Tutorial & Studi Kasus"),
        ("❓  Kuis", "Uji Pemahaman"),
        ("ℹ️  Tentang", "Informasi Aplikasi")
    ]
    coords = [(20, 380), (w//2+10, 380), (20, 520), (w//2+10, 520)]
    
    for (title, desc), (x, y) in zip(menus, coords):
        draw.rounded_rectangle([x, y, x + w//2 - 30, y + 120], radius=14, fill=(30, 41, 59), outline=(51, 65, 85), width=1)
        draw.text((x+20, y+25), title, fill=(255,255,255), font=get_font(16, bold=True))
        draw.text((x+20, y+60), desc, fill=(148,163,184), font=get_font(11))
        
    img.save(os.path.join(IMG_DIR, "fig1_tampilan_utama.png"))

def render_fig_4_1():
    img, draw = create_base_phone("Google Play Store")
    w, h = 540, 960
    draw.rectangle([0, 36, w, 90], fill=(255,255,255))
    draw.text((20, 50), "Search: Organova", fill=(30,41,59), font=get_font(16))
    
    # Store App Card
    draw.rectangle([0, 100, w, h-60], fill=(255,255,255))
    draw.rounded_rectangle([30, 130, 110, 210], radius=16, fill=(74, 108, 247))
    draw.text((55, 155), "O", fill=(255,255,255), font=get_font(32, bold=True))
    
    draw.text((130, 135), "ORGANOVA: Leadership Game", fill=(15,23,42), font=get_font(16, bold=True))
    draw.text((130, 160), "Ramzi Syuhada • Edukasi Kepemimpinan", fill=(100,116,139), font=get_font(12))
    draw.text((130, 180), "4.9 ★  |  50 MB  |  Rating 3+", fill=(74,108,247), font=get_font(12, bold=True))
    
    # Update Button
    draw.rounded_rectangle([30, 230, w-30, 280], radius=8, fill=(16, 185, 129))
    draw.text((w//2 - 60, 245), "Update / Pembaruan", fill=(255,255,255), font=get_font(14, bold=True))
    
    draw.text((30, 310), "Yang Baru di Versi 1.0:", fill=(15,23,42), font=get_font(14, bold=True))
    draw.text((30, 335), "• Penambahan skenario AI Coaching interaktif\n• Perbaikan stabilitas video pembelajaran\n• Peningkatan antarmuka kuis dan skor", fill=(71,85,105), font=get_font(12))
    img.save(os.path.join(IMG_DIR, "fig4_1_membuka_store.png"))

def render_fig_4_2():
    img, draw = create_base_phone("Google Play Store")
    w, h = 540, 960
    draw.rectangle([0, 36, w, h-60], fill=(255,255,255))
    
    draw.rounded_rectangle([30, 130, 110, 210], radius=16, fill=(74, 108, 247))
    draw.text((55, 155), "O", fill=(255,255,255), font=get_font(32, bold=True))
    
    draw.text((130, 135), "ORGANOVA: Leadership Game", fill=(15,23,42), font=get_font(16, bold=True))
    draw.text((130, 160), "Mengunduh pembaruan... 78%", fill=(74,108,247), font=get_font(13, bold=True))
    
    # Progress Bar
    draw.rounded_rectangle([130, 185, w-30, 195], radius=5, fill=(226, 232, 240))
    draw.rounded_rectangle([130, 185, 130 + int((w-160)*0.78), 195], radius=5, fill=(74, 108, 247))
    
    # Cancel / Action Button
    draw.rounded_rectangle([30, 230, w-30, 280], radius=8, fill=(239, 68, 68), outline=(220,38,38))
    draw.text((w//2 - 30, 245), "Batal", fill=(255,255,255), font=get_font(14, bold=True))
    img.save(os.path.join(IMG_DIR, "fig4_2_update_aplikasi.png"))

def render_fig_4_3():
    img, draw = create_base_phone("Google Play Store")
    w, h = 540, 960
    draw.rectangle([0, 36, w, h-60], fill=(255,255,255))
    
    draw.rounded_rectangle([30, 130, 110, 210], radius=16, fill=(74, 108, 247))
    draw.text((55, 155), "O", fill=(255,255,255), font=get_font(32, bold=True))
    
    draw.text((130, 135), "ORGANOVA: Leadership Game", fill=(15,23,42), font=get_font(16, bold=True))
    draw.text((130, 160), "Aplikasi Berhasil Diperbarui ✓", fill=(16,185,129), font=get_font(13, bold=True))
    
    # Open Button
    draw.rounded_rectangle([30, 230, w-30, 280], radius=8, fill=(74, 108, 247))
    draw.text((w//2 - 50, 245), "Buka / Open", fill=(255,255,255), font=get_font(14, bold=True))
    img.save(os.path.join(IMG_DIR, "fig4_3_berhasil_update.png"))

def render_fig_5_1():
    img, draw = create_base_phone("File Manager - Downloads")
    w, h = 540, 960
    draw.rectangle([0, 36, w, h-60], fill=(248,250,252))
    
    draw.text((20, 110), "File Installer (APK)", fill=(30,41,59), font=get_font(16, bold=True))
    
    # File Card
    draw.rounded_rectangle([20, 140, w-20, 230], radius=12, fill=(255,255,255), outline=(226,232,240), width=2)
    draw.rounded_rectangle([35, 155, 95, 215], radius=10, fill=(74, 108, 247))
    draw.text((48, 172), "APK", fill=(255,255,255), font=get_font(14, bold=True))
    
    draw.text((115, 155), "Organova_v1.0_Release.apk", fill=(15,23,42), font=get_font(14, bold=True))
    draw.text((115, 180), "Ukuran: 48.5 MB  |  14 Agt 2026", fill=(100,116,139), font=get_font(12))
    draw.text((115, 200), "Status: Siap diinstal", fill=(16,185,129), font=get_font(12, bold=True))
    img.save(os.path.join(IMG_DIR, "fig5_1_file_instalasi.png"))

def render_fig_5_2():
    img, draw = create_base_phone("Package Installer")
    w, h = 540, 960
    draw.rectangle([0, 36, w, h-60], fill=(241,245,249))
    
    # Installer Modal Card
    draw.rounded_rectangle([40, 250, w-40, 650], radius=20, fill=(255,255,255), outline=(203,213,225), width=2)
    draw.rounded_rectangle([w//2-40, 280, w//2+40, 360], radius=16, fill=(74, 108, 247))
    draw.text((w//2-12, 305), "O", fill=(255,255,255), font=get_font(32, bold=True))
    
    draw.text((w//2-80, 380), "ORGANOVA v1.0", fill=(15,23,42), font=get_font(18, bold=True))
    draw.text((w//2-110, 420), "Memasang paket aplikasi...", fill=(71,85,105), font=get_font(14))
    
    # Progress Bar
    draw.rounded_rectangle([70, 470, w-70, 482], radius=6, fill=(226, 232, 240))
    draw.rounded_rectangle([70, 470, 70 + int((w-140)*0.65), 482], radius=6, fill=(74, 108, 247))
    
    draw.text((w//2-60, 500), "Harap tunggu...", fill=(100,116,139), font=get_font(12))
    img.save(os.path.join(IMG_DIR, "fig5_2_proses_instalasi.png"))

def render_fig_5_3():
    img, draw = create_base_phone("Package Installer")
    w, h = 540, 960
    draw.rectangle([0, 36, w, h-60], fill=(241,245,249))
    
    draw.rounded_rectangle([40, 250, w-40, 650], radius=20, fill=(255,255,255), outline=(203,213,225), width=2)
    draw.ellipse([w//2-40, 280, w//2+40, 360], fill=(16, 185, 129))
    draw.text((w//2-14, 302), "✓", fill=(255,255,255), font=get_font(36, bold=True))
    
    draw.text((w//2-100, 380), "Aplikasi Terpasang", fill=(15,23,42), font=get_font(18, bold=True))
    draw.text((w//2-120, 415), "Organova siap digunakan pada perangkat.", fill=(71,85,105), font=get_font(12))
    
    draw.rounded_rectangle([70, 540, w-70, 590], radius=10, fill=(74, 108, 247))
    draw.text((w//2 - 25, 555), "Buka", fill=(255,255,255), font=get_font(16, bold=True))
    img.save(os.path.join(IMG_DIR, "fig5_3_tampilan_awal.png"))

def render_fig_6_1():
    render_fig_1() # Menu Home sama dengan Gambar 1
    os.system(f'copy "{os.path.join(IMG_DIR, "fig1_tampilan_utama.png")}" "{os.path.join(IMG_DIR, "fig6_1_menu_home.png")}"')

def render_fig_6_2():
    img, draw = create_base_phone("ORGANOVA - Menu Materi")
    w, h = 540, 960
    
    draw.text((20, 110), "MODUL PEMBELAJARAN", fill=(255,255,255), font=get_font(16, bold=True))
    draw.text((20, 135), "Pilih materi untuk memperdalam pengetahuan", fill=(148,163,184), font=get_font(12))
    
    modules = [
        ("Modul 1: Kepemimpinan Transformasional", "Prinsip dasar dan visi kepemimpinan modern.", "PDF • 18 Halaman"),
        ("Modul 2: Manajemen Konflik Organisasi", "Strategi meredam konflik & komunikasi tim.", "PPT • 24 Slide"),
        ("Modul 3: Pengambilan Keputusan AI", "Evaluasi dampak keputusan berbasis AI.", "PDF • 15 Halaman"),
        ("Modul 4: Evaluasi Kinerja & Refleksi", "Analisis metrik produktivitas & trust.", "PDF • 20 Halaman")
    ]
    
    y = 175
    for title, desc, tag in modules:
        draw.rounded_rectangle([20, y, w-20, y+110], radius=14, fill=(30, 41, 59), outline=(51, 65, 85), width=1)
        draw.text((40, y+15), title, fill=(255,255,255), font=get_font(14, bold=True))
        draw.text((40, y+42), desc, fill=(148,163,184), font=get_font(12))
        
        draw.rounded_rectangle([40, y+72, 160, y+95], radius=6, fill=(74, 108, 247))
        draw.text((50, y+76), tag, fill=(255,255,255), font=get_font(10, bold=True))
        y += 125
        
    img.save(os.path.join(IMG_DIR, "fig6_2_menu_materi.png"))

def render_fig_6_3():
    img, draw = create_base_phone("ORGANOVA - Video Pembelajaran")
    w, h = 540, 960
    
    # Video Frame Player
    draw.rounded_rectangle([20, 110, w-20, 390], radius=14, fill=(0,0,0), outline=(74, 108, 247), width=2)
    draw.ellipse([w//2-35, 225, w//2+35, 295], fill=(74, 108, 247, 220))
    draw.polygon([(w//2-10, 240), (w//2-10, 280), (w//2+20, 260)], fill=(255,255,255))
    
    # Time Overlay
    draw.text((40, 350), "02:45 / 05:30", fill=(255,255,255), font=get_font(12, bold=True))
    draw.rounded_rectangle([40, 370, w-40, 376], radius=3, fill=(100,116,139))
    draw.rounded_rectangle([40, 370, 40 + int((w-80)*0.5), 376], radius=3, fill=(74, 108, 247))
    
    # Title & Controls
    draw.text((20, 415), "Studi Kasus: Menangani Konflik Divisi", fill=(255,255,255), font=get_font(16, bold=True))
    draw.text((20, 442), "Instruktur: Prof. Dr. Andi Susanto", fill=(148,163,184), font=get_font(12))
    
    # Action buttons
    draw.rounded_rectangle([20, 480, 160, 520], radius=8, fill=(30, 41, 59))
    draw.text((45, 492), "▶ Play", fill=(255,255,255), font=get_font(13, bold=True))
    
    draw.rounded_rectangle([180, 480, 320, 520], radius=8, fill=(30, 41, 59))
    draw.text((205, 492), "⏸ Pause", fill=(255,255,255), font=get_font(13, bold=True))
    
    img.save(os.path.join(IMG_DIR, "fig6_3_menu_video.png"))

def render_fig_6_4():
    img, draw = create_base_phone("ORGANOVA - Simulasi Kepemimpinan")
    w, h = 540, 960
    
    # Scenario Header Card
    draw.rounded_rectangle([20, 110, w-20, 270], radius=14, fill=(30, 41, 59), outline=(74, 108, 247), width=2)
    draw.text((35, 125), "SKENARIO 2: KONFLIK TIM OPERASIONAL", fill=(200,210,254), font=get_font(12, bold=True))
    draw.text((35, 155), "Terjadi penurunan produktivitas 25% akibat\nketidaksetujuan penetapan target mingguan.", fill=(255,255,255), font=get_font(13))
    
    # Meters
    draw.text((35, 220), "Team Trust: 65%", fill=(16,185,129), font=get_font(11, bold=True))
    draw.text((200, 220), "Productivity: 50%", fill=(245,158,11), font=get_font(11, bold=True))
    draw.text((360, 220), "Resistance: 40%", fill=(239,68,68), font=get_font(11, bold=True))
    
    draw.text((20, 290), "PILIH PENDEKATAN KEPEMIMPINAN:", fill=(255,255,255), font=get_font(14, bold=True))
    
    # Options
    options = [
        ("A. Musyawarah & Listening Session", "Mengadakan diskusi terbuka untuk mendengar aspirasi tim.", True),
        ("B. Penyesuaian Target Bertahap", "Menurunkan target sementara sambil evaluasi.", False),
        ("C. Terapkan Instruksi Ketat", "Mewajibkan eksekusi sesuai standar awal.", False)
    ]
    
    y = 325
    for title, desc, selected in options:
        border = (74, 108, 247) if selected else (51, 65, 85)
        bg = (30, 58, 138) if selected else (30, 41, 59)
        draw.rounded_rectangle([20, y, w-20, y+100], radius=12, fill=bg, outline=border, width=2)
        draw.text((35, y+15), title, fill=(255,255,255), font=get_font(13, bold=True))
        draw.text((35, y+45), desc, fill=(203,213,225), font=get_font(11))
        y += 115
        
    img.save(os.path.join(IMG_DIR, "fig6_4_menu_simulasi.png"))

def render_fig_6_5():
    img, draw = create_base_phone("ORGANOVA - Kuis Interaktif")
    w, h = 540, 960
    
    # Question Card
    draw.rounded_rectangle([20, 110, w-20, 260], radius=14, fill=(30, 41, 59), outline=(74, 108, 247), width=2)
    draw.text((35, 125), "SOAL 3 / 10", fill=(200,210,254), font=get_font(12, bold=True))
    draw.text((35, 155), "Apa langkah pertama paling tepat saat\nmenghadapi resistensi perubahan dalam tim?", fill=(255,255,255), font=get_font(14, bold=True))
    
    # Options
    opts = [
        ("A. Memberikan sanksi langsung", False),
        ("B. Melakukan komunikasi empati & klarifikasi tujuan", True),
        ("C. Mengabaikan resistensi tim", False),
        ("D. Mengganti anggota tim yang menolak", False)
    ]
    
    y = 280
    for txt, correct in opts:
        bg = (16, 185, 129) if correct else (30, 41, 59)
        draw.rounded_rectangle([20, y, w-20, y+65], radius=10, fill=bg, outline=(51,65,85), width=1)
        draw.text((35, y+22), txt, fill=(255,255,255), font=get_font(12, bold=True))
        if correct:
            draw.text((w-60, y+22), "✓", fill=(255,255,255), font=get_font(16, bold=True))
        y += 75
        
    img.save(os.path.join(IMG_DIR, "fig6_5_menu_kuis.png"))

def render_fig_6_6():
    img, draw = create_base_phone("ORGANOVA - Informasi Aplikasi")
    w, h = 540, 960
    
    draw.ellipse([w//2-45, 130, w//2+45, 220], fill=(74, 108, 247))
    draw.text((w//2-15, 155), "O", fill=(255,255,255), font=get_font(40, bold=True))
    
    draw.text((w//2-65, 235), "ORGANOVA", fill=(255,255,255), font=get_font(20, bold=True))
    draw.text((w//2-50, 265), "Versi 1.0.0 (Build 2026)", fill=(148,163,184), font=get_font(12))
    
    # Info List
    infos = [
        ("Pengembang:", "Ramzi Syuhada"),
        ("Kategori:", "Simulasi & Educative Game"),
        ("Teknologi:", "Flutter 3.10 / AI Coaching"),
        ("Hak Cipta:", "© 2026 Organova Project. All rights reserved.")
    ]
    
    y = 310
    for label, val in infos:
        draw.rounded_rectangle([20, y, w-20, y+70], radius=10, fill=(30, 41, 59))
        draw.text((35, y+15), label, fill=(148,163,184), font=get_font(11))
        draw.text((35, y+38), val, fill=(255,255,255), font=get_font(13, bold=True))
        y += 82
        
    img.save(os.path.join(IMG_DIR, "fig6_6_menu_informasi.png"))

def render_fig_7_1():
    # Hardware Device Diagram
    w, h = 600, 400
    img = Image.new("RGBA", (w, h), (248, 250, 252, 255))
    draw = ImageDraw.Draw(img)
    
    draw.rounded_rectangle([20, 20, w-20, h-20], radius=16, fill=(255,255,255), outline=(203,213,225), width=2)
    draw.text((40, 35), "DIAGRAM PERANGKAT PENDUKUNG APLIKASI", fill=(30,58,138), font=get_font(16, bold=True))
    
    # Phone graphic
    draw.rounded_rectangle([60, 80, 220, 360], radius=16, fill=(15,23,42), outline=(74,108,247), width=3)
    draw.rounded_rectangle([70, 110, 210, 330], radius=8, fill=(30,41,59))
    draw.text((100, 200), "ORGANOVA", fill=(255,255,255), font=get_font(12, bold=True))
    
    # Callout lines & text
    draw.line([(220, 140), (320, 140)], fill=(74,108,247), width=2)
    draw.text((330, 130), "1. Layar Sentuh Full HD (Touchscreen)", fill=(15,23,42), font=get_font(12, bold=True))
    
    draw.line([(220, 220), (320, 220)], fill=(74,108,247), width=2)
    draw.text((330, 210), "2. Tombol Navigasi & Kontrol Interaktif", fill=(15,23,42), font=get_font(12, bold=True))
    
    draw.line([(220, 300), (320, 300)], fill=(74,108,247), width=2)
    draw.text((330, 290), "3. Speaker / Headset (Audio Narasi)", fill=(15,23,42), font=get_font(12, bold=True))
    
    img.save(os.path.join(IMG_DIR, "fig7_1_perangkat_pendukung.png"))

def render_fig_8_1():
    img, draw = create_base_phone("ORGANOVA - Welcome")
    w, h = 540, 960
    
    draw.ellipse([w//2-60, 180, w//2+60, 300], fill=(74, 108, 247))
    draw.text((w//2-20, 215), "O", fill=(255,255,255), font=get_font(50, bold=True))
    
    draw.text((w//2-100, 330), "SELAMAT DATANG", fill=(255,255,255), font=get_font(20, bold=True))
    draw.text((w//2-150, 370), "Simulasi Kepemimpinan Interaktif", fill=(148,163,184), font=get_font(14))
    
    draw.rounded_rectangle([40, 480, w-40, 540], radius=14, fill=(74, 108, 247))
    draw.text((w//2-70, 500), "Masuk Beranda", fill=(255,255,255), font=get_font(16, bold=True))
    img.save(os.path.join(IMG_DIR, "fig8_1_tampilan_awal.png"))

def render_fig_8_2():
    img, draw = create_base_phone("ORGANOVA - Navigasi Menu")
    w, h = 540, 960
    
    draw.text((20, 110), "NAVIGASI UTAMA APLIKASI", fill=(255,255,255), font=get_font(16, bold=True))
    
    items = [
        ("1. Beranda (Home)", "Akses simulasi & profil pembelajar."),
        ("2. Modul Materi", "Membaca panduan kepemimpinan."),
        ("3. Video Pembelajaran", "Menonton studi kasus interaktif."),
        ("4. Kuis Evaluasi", "Mengukur tingkat pemahaman.")
    ]
    
    y = 160
    for name, desc in items:
        draw.rounded_rectangle([20, y, w-20, y+85], radius=12, fill=(30, 41, 59), outline=(74, 108, 247), width=1)
        draw.text((35, y+18), name, fill=(255,255,255), font=get_font(14, bold=True))
        draw.text((35, y+48), desc, fill=(148,163,184), font=get_font(12))
        y += 100
        
    img.save(os.path.join(IMG_DIR, "fig8_2_navigasi_menu.png"))

def render_fig_8_3():
    img, draw = create_base_phone("ORGANOVA - AI Coaching")
    w, h = 540, 960
    
    draw.rounded_rectangle([20, 110, w-20, 320], radius=14, fill=(30, 41, 59), outline=(16, 185, 129), width=2)
    draw.text((35, 125), "UMPAN BALIK AI COACHING", fill=(16,185,129), font=get_font(14, bold=True))
    draw.text((35, 160), "Keputusan Anda mengadakan Musyawarah\nmeningkatkan Team Trust sebesar +20% dan\nmenurunkan resistensi perubahan secara efisien.", fill=(255,255,255), font=get_font(12))
    
    draw.text((20, 340), "TULISKAN REFLEKSI ANDA:", fill=(255,255,255), font=get_font(14, bold=True))
    draw.rounded_rectangle([20, 370, w-20, 520], radius=12, fill=(15, 23, 42), outline=(51, 65, 85), width=2)
    draw.text((35, 385), "Saya belajar bahwa mendengarkan anggota tim\nadalah kunci utama sebelum mengambil keputusan...", fill=(148,163,184), font=get_font(12))
    
    draw.rounded_rectangle([20, 550, w-20, 605], radius=12, fill=(74, 108, 247))
    draw.text((w//2-60, 568), "Kirim Refleksi", fill=(255,255,255), font=get_font(14, bold=True))
    img.save(os.path.join(IMG_DIR, "fig8_3_fitur_utama.png"))

def generate_all_screenshots():
    print("Generating UI screenshots...")
    render_fig_1()
    render_fig_4_1()
    render_fig_4_2()
    render_fig_4_3()
    render_fig_5_1()
    render_fig_5_2()
    render_fig_5_3()
    render_fig_6_1()
    render_fig_6_2()
    render_fig_6_3()
    render_fig_6_4()
    render_fig_6_5()
    render_fig_6_6()
    render_fig_7_1()
    render_fig_8_1()
    render_fig_8_2()
    render_fig_8_3()
    print("Screenshots created successfully!")

# ─────────────────────────────────────────────
# HELPER UNTUK DOKUMEN WORD (.DOCX)
# ─────────────────────────────────────────────

def set_cell_bg(cell, hex_color: str):
    tc = cell._tc
    tcPr = tc.get_or_add_tcPr()
    shd = oxml.OxmlElement('w:shd')
    shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto')
    shd.set(qn('w:fill'), hex_color)
    tcPr.append(shd)

def set_table_border(tbl, color='CBD8FF', sz='4'):
    tbl_elem = tbl._tbl
    tbl_pr = tbl_elem.find(qn('w:tblPr'))
    if tbl_pr is None:
        tbl_pr = oxml.OxmlElement('w:tblPr')
        tbl_elem.insert(0, tbl_pr)
    tbl_borders = oxml.OxmlElement('w:tblBorders')
    for edge in ('top','left','bottom','right','insideH','insideV'):
        tag = oxml.OxmlElement(f'w:{edge}')
        tag.set(qn('w:val'), 'single')
        tag.set(qn('w:sz'), sz)
        tag.set(qn('w:space'), '0')
        tag.set(qn('w:color'), color)
        tbl_borders.append(tag)
    tbl_pr.append(tbl_borders)

def tnr(run, size=12, bold=False, italic=False, color=None):
    run.font.name = 'Times New Roman'
    run.font.size = Pt(size)
    run.bold = bold
    run.italic = italic
    if color:
        run.font.color.rgb = RGBColor(*color)
    return run

def para_fmt(para, before=0, after=6, line_pts=None, indent_cm=None, hanging_cm=None, align=WD_ALIGN_PARAGRAPH.JUSTIFY):
    pf = para.paragraph_format
    pf.space_before = Pt(before)
    pf.space_after  = Pt(after)
    if line_pts:
        pf.line_spacing = Pt(line_pts)
    else:
        pf.line_spacing = 1.15
    if indent_cm is not None:
        pf.first_line_indent = Cm(indent_cm)
    if hanging_cm is not None:
        pf.left_indent       = Cm(hanging_cm)
        pf.first_line_indent = Cm(-hanging_cm)
    para.alignment = align

def add_heading_1(doc, text):
    p = doc.add_paragraph(style='Heading 1')
    para_fmt(p, before=18, after=8, align=WD_ALIGN_PARAGRAPH.LEFT)
    p.text = ""
    run = p.add_run(text)
    tnr(run, size=18, bold=True, color=C_NAVY)
    return p

def add_heading_2(doc, text):
    p = doc.add_paragraph(style='Heading 2')
    para_fmt(p, before=14, after=6, align=WD_ALIGN_PARAGRAPH.LEFT)
    p.text = ""
    run = p.add_run(text)
    tnr(run, size=14, bold=True, color=C_DARK_BLUE)
    return p

def add_heading_3(doc, text):
    p = doc.add_paragraph(style='Heading 3')
    para_fmt(p, before=10, after=4, align=WD_ALIGN_PARAGRAPH.LEFT)
    p.text = ""
    run = p.add_run(text)
    tnr(run, size=12, bold=True, color=C_PRIMARY)
    return p

def add_p(doc, text, bold_prefix=None, indent=0.75):
    p = doc.add_paragraph()
    para_fmt(p, before=0, after=6, indent_cm=indent)
    if bold_prefix:
        r_pre = p.add_run(bold_prefix)
        tnr(r_pre, size=12, bold=True)
    r_txt = p.add_run(text)
    tnr(r_txt, size=12)
    return p

def add_bullet(doc, text, bold_prefix=None, level=1):
    p = doc.add_paragraph()
    para_fmt(p, before=0, after=4, hanging_cm=0.6 * level, align=WD_ALIGN_PARAGRAPH.LEFT)
    r_bullet = p.add_run("•  ")
    tnr(r_bullet, size=12, bold=True, color=C_PRIMARY)
    if bold_prefix:
        r_pre = p.add_run(bold_prefix)
        tnr(r_pre, size=12, bold=True)
    r_txt = p.add_run(text)
    tnr(r_txt, size=12)
    return p

def add_image_box(doc, img_filename, caption_text, width_cm=8.5):
    """Menambahkan gambar dengan bingkai rapi dan caption standar Microsoft Word."""
    img_path = os.path.join(IMG_DIR, img_filename)
    if not os.path.exists(img_path):
        print(f"Warning: {img_filename} not found.")
        return
        
    p_img = doc.add_paragraph()
    para_fmt(p_img, before=10, after=4, align=WD_ALIGN_PARAGRAPH.CENTER)
    r_img = p_img.add_run()
    r_img.add_picture(img_path, width=Cm(width_cm))
    
    p_cap = doc.add_paragraph(style='Caption')
    para_fmt(p_cap, before=2, after=12, align=WD_ALIGN_PARAGRAPH.CENTER)
    p_cap.text = ""
    r_cap = p_cap.add_run(caption_text)
    tnr(r_cap, size=10, bold=True, italic=True, color=C_DARK_BLUE)

def add_toc_field(doc):
    p = doc.add_paragraph()
    para_fmt(p, before=12, after=18, align=WD_ALIGN_PARAGRAPH.LEFT)
    run = p.add_run()
    fldChar1 = oxml.OxmlElement('w:fldChar')
    fldChar1.set(qn('w:fldCharType'), 'begin')
    instrText = oxml.OxmlElement('w:instrText')
    instrText.set(qn('xml:space'), 'preserve')
    instrText.text = 'TOC \\o "1-3" \\h \\z \\u'
    fldChar2 = oxml.OxmlElement('w:fldChar')
    fldChar2.set(qn('w:fldCharType'), 'separate')
    fldChar3 = oxml.OxmlElement('w:fldChar')
    fldChar3.set(qn('w:fldCharType'), 'end')
    
    run._r.append(fldChar1)
    run._r.append(instrText)
    run._r.append(fldChar2)
    run._r.append(fldChar3)

def add_page_number_field(run):
    fldSimple = oxml.OxmlElement('w:fldSimple')
    fldSimple.set(qn('w:instr'), 'PAGE')
    run._r.append(fldSimple)

# ─────────────────────────────────────────────
# GENERATOR DOKUMEN MANUAL (.DOCX)
# ─────────────────────────────────────────────

def build_document():
    print("Building Word Document (.docx)...")
    doc = Document()
    
    # Atur Margin Akademik (Top 3cm, Bottom 3cm, Left 4cm, Right 3cm)
    for section in doc.sections:
        section.top_margin    = Cm(3.0)
        section.bottom_margin = Cm(3.0)
        section.left_margin   = Cm(4.0)
        section.right_margin  = Cm(3.0)
        
        # Header & Footer setup
        header = section.header
        hp = header.paragraphs[0]
        para_fmt(hp, before=0, after=4, align=WD_ALIGN_PARAGRAPH.RIGHT)
        hrun = hp.add_run(f"Panduan Penggunaan Aplikasi {APP_NAME} v{APP_VERSION}")
        tnr(hrun, size=9, italic=True, color=C_GREY_TXT)
        
        footer = section.footer
        fp = footer.paragraphs[0]
        para_fmt(fp, before=4, after=0, align=WD_ALIGN_PARAGRAPH.CENTER)
        r_pre = fp.add_run("— Halaman ")
        tnr(r_pre, size=10, color=C_GREY_TXT)
        r_num = fp.add_run()
        add_page_number_field(r_num)
        tnr(r_num, size=10, bold=True, color=C_GREY_TXT)
        r_post = fp.add_run(" —")
        tnr(r_post, size=10, color=C_GREY_TXT)

    # ─────────────────────────────────────────────
    # COVER PAGE
    # ─────────────────────────────────────────────
    p_cov_top = doc.add_paragraph()
    para_fmt(p_cov_top, before=40, after=20, align=WD_ALIGN_PARAGRAPH.CENTER)
    r_cov_top = p_cov_top.add_run("DOKUMEN PANDUAN PENGGUNAAN RESMI")
    tnr(r_cov_top, size=12, bold=True, color=C_PRIMARY)

    p_cov_main = doc.add_paragraph()
    para_fmt(p_cov_main, before=10, after=12, align=WD_ALIGN_PARAGRAPH.CENTER)
    r_cov_main = p_cov_main.add_run(f"PANDUAN PENGGUNAAN APLIKASI\n{APP_NAME}")
    tnr(r_cov_main, size=24, bold=True, color=C_NAVY)

    p_cov_sub = doc.add_paragraph()
    para_fmt(p_cov_sub, before=0, after=40, align=WD_ALIGN_PARAGRAPH.CENTER)
    r_cov_sub = p_cov_sub.add_run(APP_SUBTITLE)
    tnr(r_cov_sub, size=14, italic=True, color=C_DARK_BLUE)

    # Metadata Box Table
    table_cov = doc.add_table(rows=4, cols=2)
    table_cov.alignment = WD_TABLE_ALIGNMENT.CENTER
    table_cov.autofit = False
    
    meta_data = [
        ("Nama Aplikasi", APP_NAME),
        ("Versi Aplikasi", f"v{APP_VERSION}"),
        ("Pengembang / Developer", DEVELOPER),
        ("Tahun Pembuatan", YEAR)
    ]
    
    for idx, (label, val) in enumerate(meta_data):
        row = table_cov.rows[idx]
        cell_lbl, cell_val = row.cells[0], row.cells[1]
        cell_lbl.width = Cm(5.0)
        cell_val.width = Cm(9.0)
        set_cell_bg(cell_lbl, "F1F5F9")
        set_cell_bg(cell_val, "FFFFFF")
        
        p_l = cell_lbl.paragraphs[0]
        para_fmt(p_l, before=4, after=4, align=WD_ALIGN_PARAGRAPH.LEFT)
        tnr(p_l.add_run(label), size=11, bold=True, color=C_DARK_BLUE)
        
        p_v = cell_val.paragraphs[0]
        para_fmt(p_v, before=4, after=4, align=WD_ALIGN_PARAGRAPH.LEFT)
        tnr(p_v.add_run(val), size=11, bold=False, color=C_NAVY)
        
    set_table_border(table_cov, color='CBD8FF', sz='6')
    doc.add_page_break()

    # ─────────────────────────────────────────────
    # DAFTAR ISI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "DAFTAR ISI")
    add_p(doc, "Daftar isi berikut dihasilkan secara otomatis berdasarkan penamaan heading dokumen akademik:")
    add_toc_field(doc)
    doc.add_page_break()

    # ─────────────────────────────────────────────
    # BAB 1 INFORMASI UMUM APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 1: INFORMASI UMUM APLIKASI")
    add_p(doc, f"Aplikasi {APP_NAME} ({APP_SUBTITLE}) merupakan media pembelajaran digital berbasis simulasi interaktif yang dirancang khusus untuk memfasilitasi pengembangan kompetensi kepemimpinan dan manajemen organisasi secara komprehensif. Aplikasi ini mengintegrasikan pendekatan pembelajaran berbasis gim (game-based learning) dengan sistem evaluasi kecerdasan buatan (Artificial Intelligence Coaching).")
    add_p(doc, "Melalui alur narasi yang dinamis, pengguna ditempatkan pada posisi strategis sebagai Manajer Operasional yang menghadapi berbagai tantangan nyata organisasi, seperti penurunan efisiensi kerja, dinamika konflik antaranggota tim, serta krisis pengambilan keputusan di bawah tekanan.")
    add_p(doc, "Tujuan utama pengembangannya adalah untuk menyediakan lingkungan belajar yang aman (risk-free environment) bagi para pembelajar dan profesional untuk melatih pemikiran kritis, analisis dampak keputusan, serta penerapan gaya kepemimpinan kontekstual.")
    add_p(doc, "Target pengguna aplikasi ini mencakup mahasiswa manajemen/organisasi, praktisi Sumber Daya Manusia (SDM), pimpinan tim, serta fasilitator pelatihan kepemimpinan yang membutuhkan instrumen simulasi praktis.")
    
    add_image_box(doc, "fig1_tampilan_utama.png", "Gambar 1. Tampilan Utama Aplikasi ORGANOVA", width_cm=8.0)

    # ─────────────────────────────────────────────
    # BAB 2 TUJUAN APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 2: TUJUAN APLIKASI")
    add_p(doc, f"Pengembangan aplikasi {APP_NAME} berorientasi pada pencapaian beberapa tujuan dan dampak positif sebagai berikut:")
    
    add_bullet(doc, "Menyediakan wahana simulasi interaktif untuk menguji efektivitas berbagai pendekatan kepemimpinan dalam merespons krisis organisasi.", bold_prefix="1. Tujuan Utama Aplikasi: ")
    add_bullet(doc, "Memungkinkan pengguna untuk memahami konsekuensi langsung dari setiap pilihan keputusan terhadap metrik utama organisasi secara objektif.", bold_prefix="2. Manfaat Bagi Pengguna: ")
    add_bullet(doc, "Meningkatkan kemampuan pemecahan masalah (problem solving), komunikasi empati, manajemen konflik, serta kecerdasan emosional manajerial.", bold_prefix="3. Kemampuan Yang Diperoleh: ")
    add_bullet(doc, "Mendorong terciptanya budaya kepemimpinan yang adaptif dan berbasis data (data-driven decision making) pada lingkungan kerja nyata.", bold_prefix="4. Dampak Penggunaan Aplikasi: ")

    # ─────────────────────────────────────────────
    # BAB 3 SPESIFIKASI ALAT YANG DIBUTUHKAN
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 3: SPESIFIKASI ALAT YANG DIBUTUHKAN")
    add_p(doc, f"Untuk memastikan aplikasi {APP_NAME} dapat berjalan secara optimal tanpa hambatan teknis, berikut adalah rincian spesifikasi perangkat keras (hardware) dan perangkat lunak (software) yang dibutuhkan:")

    # Table Hardware
    tbl_hw = doc.add_table(rows=8, cols=3)
    tbl_hw.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_hw.autofit = False
    
    headers = ["Aspek Perangkat", "Spesifikasi Minimum", "Spesifikasi Direkomendasikan"]
    hdr_row = tbl_hw.rows[0]
    for idx, h_text in enumerate(headers):
        cell = hdr_row.cells[idx]
        set_cell_bg(cell, "4A6CF7")
        p = cell.paragraphs[0]
        para_fmt(p, before=6, after=6, align=WD_ALIGN_PARAGRAPH.CENTER)
        tnr(p.add_run(h_text), size=11, bold=True, color=C_WHITE)
        
    specs = [
        ("Sistem Operasi", "Android 8.0 (Oreo) / iOS 12.0", "Android 11.0+ / iOS 15.0+"),
        ("Processor", "Octa-core 1.8 GHz ARMv8", "Octa-core 2.4 GHz+ 64-bit"),
        ("RAM", "3 GB RAM", "6 GB RAM atau lebih tinggi"),
        ("Storage (Penyimpanan)", "200 MB Ruang Kosong", "500 MB Ruang Kosong"),
        ("GPU", "Adreno 506 / Mali-G52", "Adreno 618 / Mali-G77+"),
        ("Versi Software", "Organova Runtime v1.0", "Organova Runtime v1.0 (Latest)"),
        ("Perangkat Pendukung", "Layar Sentuh, Koneksi Internet", "Layar Full HD, Speaker/Headset")
    ]
    
    for row_idx, data in enumerate(specs, start=1):
        row = tbl_hw.rows[row_idx]
        bg_col = "F8FAFC" if row_idx % 2 == 1 else "FFFFFF"
        for col_idx, text in enumerate(data):
            cell = row.cells[col_idx]
            cell.width = Cm(4.5) if col_idx == 0 else Cm(4.75)
            set_cell_bg(cell, bg_col)
            p = cell.paragraphs[0]
            align = WD_ALIGN_PARAGRAPH.LEFT if col_idx == 0 else WD_ALIGN_PARAGRAPH.CENTER
            para_fmt(p, before=4, after=4, align=align)
            bold_flag = True if col_idx == 0 else False
            tnr(p.add_run(text), size=10, bold=bold_flag, color=C_NAVY)
            
    set_table_border(tbl_hw, color='CBD8FF', sz='4')
    add_p(doc, "Penjelasan: Koneksi internet diperlukan terutama saat menjalankan modul AI Coaching untuk mengirimkan data opsi keputusan ke server evaluasi dan menerima balasan umpan balik secara real-time.", indent=0)

    # ─────────────────────────────────────────────
    # BAB 4 UPDATE APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 4: UPDATE APLIKASI")
    add_p(doc, "Pembaruan (update) aplikasi secara berkala sangat penting dilakukan untuk memperoleh fitur skenario terbaru, perbaikan performa, serta peningkatan keandalan modul evaluasi AI.")
    add_p(doc, "Tahapan pembaruan aplikasi dilakukan melalui langkah-langkah berikut:")
    
    add_bullet(doc, "Buka aplikasi Google Play Store atau Apple App Store pada perangkat seluler Anda.", bold_prefix="1. Membuka Application Store: ")
    add_image_box(doc, "fig4_1_membuka_store.png", "Gambar 4.1 Proses Membuka Store", width_cm=7.5)

    add_bullet(doc, "Ketik 'Organova' pada kolom pencarian, lalu pilih tombol 'Update' atau 'Pembaruan'.", bold_prefix="2. Memilih Menu Update: ")
    add_image_box(doc, "fig4_2_update_aplikasi.png", "Gambar 4.2 Proses Update Aplikasi", width_cm=7.5)

    add_bullet(doc, "Tunggu hingga proses pengunduhan berkas pembaruan selesai secara otomatis.", bold_prefix="3. Menjalankan Pembaruan: ")
    add_bullet(doc, "Setelah instalasi selesai, tekan tombol 'Buka' untuk memastikan aplikasi berhasil diperbarui ke versi terbaru.", bold_prefix="4. Verifikasi Berhasil: ")
    add_image_box(doc, "fig4_3_berhasil_update.png", "Gambar 4.3 Aplikasi Berhasil Diperbarui", width_cm=7.5)

    # ─────────────────────────────────────────────
    # BAB 5 PEMASANGAN APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 5: PEMASANGAN APLIKASI")
    add_p(doc, f"Proses instalasi aplikasi {APP_NAME} dapat dilakukan dari berkas mentah APK maupun melalui toko aplikasi resmi.")
    
    add_heading_2(doc, "Tahapan Instalasi Aplikasi:")
    add_bullet(doc, "Pastikan kapasitas penyimpanan internal perangkat mencukupi dan fitur 'Install Unknown Apps' diizinkan jika menggunakan berkas APK.", bold_prefix="1. Persiapan Perangkat: ")
    add_image_box(doc, "fig5_1_file_instalasi.png", "Gambar 5.1 File Instalasi Aplikasi", width_cm=7.5)

    add_bullet(doc, "Unduh berkas instalasi resmi dari repositori atau tautan yang disiapkan pengembang.", bold_prefix="2. Download Aplikasi: ")
    add_bullet(doc, "Ketuk berkas installer untuk memulai wizard pemasangan paket aplikasi.", bold_prefix="3. Instal Aplikasi: ")
    add_image_box(doc, "fig5_2_proses_instalasi.png", "Gambar 5.2 Proses Instalasi", width_cm=7.5)

    add_bullet(doc, "Buka aplikasi untuk pertama kali dan berikan izin akses yang diperlukan.", bold_prefix="4. Membuka Aplikasi Pertama Kali: ")
    add_image_box(doc, "fig5_3_tampilan_awal.png", "Gambar 5.3 Tampilan Awal Setelah Instalasi", width_cm=7.5)

    # ─────────────────────────────────────────────
    # BAB 6 MENU APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 6: MENU APLIKASI")
    add_p(doc, f"Aplikasi {APP_NAME} memiliki struktur menu intuitif yang terbagi menjadi beberapa modul utama:")

    # Menu Home
    add_heading_2(doc, "A. Menu Home (Beranda)")
    add_p(doc, "Halaman utama berfungsi sebagai pusat navigasi pembelajaran. Menampilkan profil pengguna (Stevi), indikator Level dan XP, tombol cepat 'Mulai Simulasi', serta akses ke modul belajar lainnya.")
    add_image_box(doc, "fig6_1_menu_home.png", "Gambar 6.1 Tampilan Menu Home", width_cm=7.5)

    # Menu Materi
    add_heading_2(doc, "B. Menu Materi")
    add_p(doc, "Menyediakan dokumen pembelajaran konseptual dalam format PDF interaktif maupun PPT. Pengguna dapat memilih bab yang ingin dipelajari untuk memperkuat pemahaman teori sebelum mengambil simulasi.")
    add_image_box(doc, "fig6_2_menu_materi.png", "Gambar 6.2 Tampilan Menu Materi", width_cm=7.5)

    # Menu Video
    add_heading_2(doc, "C. Menu Video")
    add_p(doc, "Berisi materi multimedia studi kasus kepemimpinan. Dilengkapi dengan kontrol pemutar video seperti Play, Pause, serta indikator durasi pembelajaran.")
    add_image_box(doc, "fig6_3_menu_video.png", "Gambar 6.3 Tampilan Menu Video", width_cm=7.5)

    # Menu Simulasi
    add_heading_2(doc, "D. Menu Simulasi")
    add_p(doc, "Modul inti aplikasi tempat pengguna mengambil keputusan dalam skenario krisis. Terdapat indikator real-time Team Trust, Productivity, dan Resistance Level.")
    add_image_box(doc, "fig6_4_menu_simulasi.png", "Gambar 6.4 Tampilan Menu Simulasi", width_cm=7.5)

    # Menu Kuis
    add_heading_2(doc, "E. Menu Kuis")
    add_p(doc, "Modul evaluasi berupa pilihan ganda interaktif untuk menguji pemahaman konsep kepemimpinan. Memberikan umpan balik instan atas jawaban pengguna.")
    add_image_box(doc, "fig6_5_menu_kuis.png", "Gambar 6.5 Tampilan Menu Kuis", width_cm=7.5)

    # Menu Informasi
    add_heading_2(doc, "F. Menu Informasi")
    add_p(doc, "Menampilkan informasi lengkap mengenai aplikasi, rincian tim pengembang, versi rilis, serta lisensi hak cipta.")
    add_image_box(doc, "fig6_6_menu_informasi.png", "Gambar 6.6 Tampilan Menu Informasi", width_cm=7.5)

    # ─────────────────────────────────────────────
    # BAB 7 INFORMASI PENGGUNAAN PERANGKAT
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 7: INFORMASI PENGGUNAAN PERANGKAT")
    add_p(doc, "Untuk memaksimalkan pengalaman berinteraksi dengan aplikasi, pengoperasian perangkat disesuaikan dengan standar gestur smartphone modern:")

    add_heading_2(doc, "1. Nama Bagian Perangkat")
    add_p(doc, "Layar sentuh utama berfungsi sebagai area tampilan visual. Panel atas menampilkan bar navigasi dan status koneksi, sedangkan bagian bawah menyediakan respon haptik dan tombol kontrol.")

    add_heading_2(doc, "2. Tombol Kontrol")
    add_bullet(doc, "Tombol Opsi Keputusan: Digunakan untuk memilih salah satu pendekatan kepemimpinan pada layar simulasi.", bold_prefix="• ")
    add_bullet(doc, "Tombol Navigasi Beranda: Mengembalikan layar aktif ke menu utama.", bold_prefix="• ")
    add_bullet(doc, "Tombol Media Player: Mengontrol fungsi putar/henti pada video pembelajaran.", bold_prefix="• ")

    add_heading_2(doc, "3. Cara Penggunaan Perangkat")
    add_p(doc, "Pengguna cukup mengetuk (tap) pada kartu menu atau opsi yang diinginkan. Pada layar materi, gestur usap (swipe) dapat digunakan untuk berpindah halaman dokumen.")
    add_image_box(doc, "fig7_1_perangkat_pendukung.png", "Gambar 7.1 Perangkat Pendukung", width_cm=9.5)

    # ─────────────────────────────────────────────
    # BAB 8 TATA CARA PENGGUNAAN APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 8: TATA CARA PENGGUNAAN APLIKASI")
    
    add_heading_2(doc, "A. Memulai Aplikasi")
    add_p(doc, "Buka aplikasi dari launcher perangkat. Layar sambutan akan tampil beberapa detik sebelum secara otomatis masuk ke halaman beranda utama.")
    add_image_box(doc, "fig8_1_tampilan_awal.png", "Gambar 8.1 Tampilan Awal Aplikasi", width_cm=7.5)

    add_heading_2(doc, "B. Navigasi Menu")
    add_p(doc, "Perpindahan antarmenu dilakukan dengan memilih salah satu ikon pada beranda. Navigasi kembali dapat dilakukan melalui tombol back pada bar atas.")
    add_image_box(doc, "fig8_2_navigasi_menu.png", "Gambar 8.2 Navigasi Menu", width_cm=7.5)

    add_heading_2(doc, "C. Menggunakan Fitur Utama")
    add_p(doc, "Langkah-langkah menjalankan simulasi dan AI Coaching:")
    add_bullet(doc, "Pengguna memilih menu 'Mulai Simulasi' dari halaman beranda.", bold_prefix="Langkah 1: ")
    add_bullet(doc, "Sistem menampilkan skenario masalah dan pilihan opsi keputusan kepemimpinan.", bold_prefix="Langkah 2: ")
    add_bullet(doc, "Pengguna melakukan analisis lalu mengetuk opsi keputusan yang dipilih.", bold_prefix="Langkah 3: ")
    add_bullet(doc, "Sistem AI memberikan umpan balik evaluasi dampak serta memuat kolom refleksi.", bold_prefix="Langkah 4: ")
    add_image_box(doc, "fig8_3_fitur_utama.png", "Gambar 8.3 Penggunaan Fitur Utama", width_cm=7.5)

    # ─────────────────────────────────────────────
    # BAB 9 TENTANG APLIKASI
    # ─────────────────────────────────────────────
    add_heading_1(doc, "BAB 9: TENTANG APLIKASI")
    
    tbl_about = doc.add_table(rows=6, cols=2)
    tbl_about.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_about.autofit = False
    
    info_about = [
        ("Nama Aplikasi", APP_NAME),
        ("Versi Aplikasi", f"v{APP_VERSION}"),
        ("Pengembang", DEVELOPER),
        ("Tujuan Pengembangan", "Media simulasi edukatif untuk menguji dan mengasah kemampuan pengambilan keputusan kepemimpinan berbasis AI."),
        ("Hak Cipta", f"© {YEAR} Organova Development Team. Seluruh hak cipta dilindungi undang-undang."),
        ("Referensi", "Model Kepemimpinan Situasional Hersey-Blanchard & Prinsip Leadership Transformasional.")
    ]
    
    for idx, (label, val) in enumerate(info_about):
        row = tbl_about.rows[idx]
        c1, c2 = row.cells[0], row.cells[1]
        c1.width = Cm(4.5)
        c2.width = Cm(9.5)
        set_cell_bg(c1, "F1F5F9")
        set_cell_bg(c2, "FFFFFF")
        
        p1 = c1.paragraphs[0]
        para_fmt(p1, before=4, after=4, align=WD_ALIGN_PARAGRAPH.LEFT)
        tnr(p1.add_run(label), size=11, bold=True, color=C_DARK_BLUE)
        
        p2 = c2.paragraphs[0]
        para_fmt(p2, before=4, after=4, align=WD_ALIGN_PARAGRAPH.LEFT)
        tnr(p2.add_run(val), size=11, bold=False, color=C_NAVY)
        
    set_table_border(tbl_about, color='CBD8FF', sz='6')

    # Simpan file docx
    doc.save(OUTPUT_DOCX)
    doc.save(OUTPUT_DOCX_DOC)
    print(f"Document successfully created at:\n1. {OUTPUT_DOCX}\n2. {OUTPUT_DOCX_DOC}")

if __name__ == "__main__":
    generate_all_screenshots()
    build_document()

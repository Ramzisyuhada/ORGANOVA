"""Replace Organova manual UI mockups with screenshots captured at runtime."""

from pathlib import Path
from tempfile import NamedTemporaryFile
from zipfile import ZIP_DEFLATED, ZipFile

SOURCE_DOCX = Path("Panduan_Penggunaan_Aplikasi_Organova.docx")
DOCX = Path("Panduan_Penggunaan_Aplikasi_Organova_Screenshot_Asli.docx")
DOCX_COPY = Path("docs/Panduan_Penggunaan_Aplikasi_Organova_Screenshot_Asli.docx")
ACTUAL = Path("assets/screenshots/actual")

# Word deduplicates the reused Beranda asset, so its first media entry serves
# both Figure 1 and Figure 6.1.  Store and installer images are deliberately
# retained because they are system screens rather than in-app views.
REPLACEMENTS = {
    "word/media/image1.png": ACTUAL / "home.png",                # Fig. 1 / 6.1
    "word/media/image7.png": ACTUAL / "home.png",                # Fig. 5.3
    "word/media/image8.png": ACTUAL / "materi.png",              # Fig. 6.2
    "word/media/image9.png": ACTUAL / "materi.png",              # Fig. 6.3 entry
    "word/media/image10.png": ACTUAL / "simulasi_intro.png",     # Fig. 6.4
    "word/media/image11.png": ACTUAL / "kuis.png",               # Fig. 6.5
    "word/media/image12.png": ACTUAL / "tentang.png",            # Fig. 6.6
    "word/media/image13.png": ACTUAL / "home.png",               # Fig. 7.1
    "word/media/image14.png": ACTUAL / "home.png",               # Fig. 8.1
    "word/media/image15.png": ACTUAL / "materi.png",             # Fig. 8.2
    "word/media/image16.png": ACTUAL / "simulasi_intro.png",     # Fig. 8.3
}

for image in REPLACEMENTS.values():
    if not image.is_file():
        raise FileNotFoundError(image)

with ZipFile(SOURCE_DOCX, "r") as source, NamedTemporaryFile(
    delete=False, suffix=".docx", dir=DOCX.parent
) as tmp:
    temporary = Path(tmp.name)
    with ZipFile(temporary, "w", ZIP_DEFLATED) as target:
        for item in source.infolist():
            replacement = REPLACEMENTS.get(item.filename)
            target.writestr(item, replacement.read_bytes() if replacement else source.read(item.filename))

temporary.replace(DOCX)
DOCX_COPY.write_bytes(DOCX.read_bytes())
print(f"Updated {len(REPLACEMENTS)} embedded UI images in {DOCX}")

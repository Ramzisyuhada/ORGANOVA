# ORGANOVA

Simulasi kepemimpinan dan pengambilan keputusan organisasi berbasis AI (Flutter).

## Konfigurasi kunci API

Kunci Mistral AI dan Supabase tidak disimpan di kode. Aplikasi membacanya saat
build melalui `--dart-define-from-file`.

1. Salin `dart_defines.example.json` menjadi `dart_defines.json`.
2. Isi nilainya:
   - `MISTRAL_API_KEY`: kunci dari console.mistral.ai
   - `SUPABASE_URL` dan `SUPABASE_ANON_KEY`: dari pengaturan proyek Supabase
3. `dart_defines.json` sudah masuk `.gitignore`; jangan di-commit.

## Menjalankan dan build

```bash
flutter run --dart-define-from-file=dart_defines.json
```

```bash
flutter build apk --release --dart-define-from-file=dart_defines.json
```

Tanpa file tersebut, aplikasi gagal terhubung ke Supabase saat dibuka dan
simulasi menampilkan pesan bahwa `MISTRAL_API_KEY` kosong.

## Catatan

- Model AI: `open-mistral-nemo` (batas akun saat ini 2 permintaan per menit).
- Kunci yang dikirim lewat dart-define tetap tertanam di APK. Untuk keamanan
  penuh, pindahkan panggilan AI ke server perantara (misalnya Supabase Edge
  Function).

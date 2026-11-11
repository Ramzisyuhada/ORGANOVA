# ORGANOVA

Simulasi kepemimpinan dan pengambilan keputusan organisasi berbasis AI (Flutter).

## Konfigurasi kunci API

Kunci Mistral AI dan Supabase tidak disimpan di kode. Aplikasi membacanya saat
build melalui `--dart-define-from-file`.

1. Salin `dart_defines.example.json` menjadi `dart_defines.json`.
2. Isi nilainya:
   - `AI_BASE_URL`: alamat API yang kompatibel OpenAI, misalnya
     `https://openrouter.ai/api/v1` (OpenRouter), `https://router.requesty.ai/v1` (Requesty),
     atau `https://api.mistral.ai/v1`
   - `AI_API_KEY`: kunci untuk alamat tersebut
   - `AI_MODEL`: nama model, misalnya `nvidia/nemotron-3-ultra-550b-a55b:free`
     (gratis di OpenRouter, sekitar 15 detik per analisis) atau `openai/gpt-4o-mini`
     (berbayar, lebih cepat)
   - `SUPABASE_URL` dan `SUPABASE_ANON_KEY`: dari pengaturan proyek Supabase
3. `dart_defines.json` sudah masuk `.gitignore`; jangan di-commit.

Untuk mengganti model atau penyedia AI, cukup ubah `dart_defines.json` lalu
build ulang; kode tidak perlu diubah.

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

- Penyedia AI saat ini: OpenRouter dengan model gratis
  `nvidia/nemotron-3-ultra-550b-a55b:free`. Model gratis OpenRouter memiliki
  batas permintaan harian; untuk pemakaian satu kelas gunakan model berbayar.
- Kunci yang dikirim lewat dart-define tetap tertanam di APK. Untuk keamanan
  penuh, pindahkan panggilan AI ke server perantara (misalnya Supabase Edge
  Function).

class PromptId {
  PromptId._();

  static String analyzeDecision({
    required String category,
    required String jsonSchema,
    required String userInput,
  }) {
    return '''
Kamu adalah seorang ahli manajemen risiko dan analis strategis.
Tugas kamu adalah menganalisis keputusan berikut dan memberikan simulasi kegagalan (pre-mortem) yang realistis.

KATEGORI: "$category"
KEPUTUSAN: "$userInput"

INSTRUKSI:
1. Buat TEPAT 3 skenario kegagalan berbeda yang sangat mungkin terjadi.
2. Untuk setiap skenario, isi field sesuai schema dan pastikan:
   - id: "s1", "s2", "s3"
   - title maks 10 kata
   - narrative maks 100 kata
   - likelihood hanya: "rendah" | "sedang" | "tinggi"
   - main_cause maks 50 kata
   - early_indicators tepat 3 item
   - prevention_actions minimal 1 item dengan field action dan timing
   - timing hanya: "hari ini" | "besok" | "minggu ini" | "bulan ini"
3. overall_confidence hanya: "rendah" | "sedang" | "tinggi".
4. confidence_reason wajib diisi jika overall_confidence = "rendah", selain itu null.
5. clarification_needed berisi pertanyaan singkat jika informasi kurang jelas; jika cukup maka null.
6. Gunakan Bahasa Indonesia.

SCHEMA JSON (WAJIB DIIKUTI TEPAT):
$jsonSchema

KEMBALIKAN OUTPUT HANYA DALAM JSON VALID SESUAI SCHEMA, TANPA TEKS TAMBAHAN.
''';
  }
}

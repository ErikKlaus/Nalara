# Implementation Plan — Nalara MVP (Fase Lanjutan)

Ringkasan status implementasi setelah perbaikan schema, Firestore, Cloud Functions, dan UI dasar.

---

## Status Implementasi Saat Ini

### Selesai
- Core theme + AppTheme terpasang di main.dart.
- Decision entity/model sesuai DB Schema (inputText, category, updatedAt, notes, expiresAt).
- Firestore rules + indexes sesuai subcollection.
- Prompt ID + EN sesuai PRD 7.2.
- Cloud Functions (TypeScript): analyzeDecision, checkUsageLimit, cleanupExpiredData.
- Analysis feature: domain + data + presentation dasar.
- Decision UI dasar: Home, Input, History, Detail.
- Reminder data layer + provider.
- L10n dasar + AppLocalizations (ID/EN).
- Hive AnalysisCache adapter + box.
- SyncManager dasar.

### Masih Belum Ditambahkan (PRD / DB Schema / TSD)
- Onboarding tooltip overlay (FSD 2.3).
- Language selection flow terhubung ke locale controller (screen ada, belum dipakai).
- Create/read user profile (/users/{uid}) dipanggil saat login.
- Reminder banner terhubung ke data reminders (bukan placeholder statis).
- Offline banner + otomatis sync saat online (SyncManager belum dipakai di app flow).
- Draft auto-delete > 24 jam saat app launch.
- Detail screen menampilkan hasil analisis penuh (card scenario, indicator, prevention).
- Unit tests untuk parsing/validation AI output.
- Telemetri penggunaan AI (UI menampilkan limit dan error states secara konsisten).

---

## Saran Urutan Eksekusi Berikutnya

1. Integrasi user profile + language selection (Auth flow).
2. Hook SyncManager (startup + connectivity changes).
3. Hubungkan reminder banner ke Firestore reminders.
4. Lengkapi detail screen dengan hasil analisis.
5. Add onboarding tooltip + polish.
6. Tambah unit tests parsing/validation.

---

## Verification (Target)

- flutter analyze (0 errors)
- flutter test (semua pass)
- flutter build web --release
- Firebase emulator untuk rules + functions

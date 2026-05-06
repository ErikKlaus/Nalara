# Changelog - Nalara App

## [Unreleased] - 2026-05-07

### Added
- ✨ Bouncing scroll physics di semua screen untuk pengalaman scrolling yang lebih smooth
  - Dashboard/Home screen
  - History screen
  - Draft screen
  - Input screen
  - Detail screen
  - Analysis result screen
- 🔄 Pull-to-refresh functionality di:
  - Dashboard untuk refresh usage limit
  - History screen untuk refresh decision list
  - Draft screen untuk refresh draft list
- 🔥 Icon fire di streak panel untuk visual yang lebih menarik

### Changed
- 🌐 Perbaikan localization untuk language selection screen
  - Menghapus hardcoded text "Pilih Bahasa", "Gunakan bahasa yang paling nyaman untuk berpikir jernih", dll
  - Menambahkan string localization yang hilang:
    - `languageSelectionDescription`
    - `languageIndonesianSubtitle`
    - `languageEnglishSubtitle`
- 🎨 Redesign streak panel
  - Menghapus circle putih yang tidak diperlukan
  - Menampilkan icon fire dan teks streak dalam satu baris horizontal
  - Animasi gradient yang lebih smooth

### Fixed
- 🐛 Teks bahasa Indonesia yang masih hardcoded di language selection screen
- 🐛 Teks bahasa Indonesia yang masih hardcoded di profile menu sheet (dialog logout)
- 🐛 Localization message untuk language changed notification

### Technical
- ✅ Semua fitur menggunakan Firebase Spark (free tier)
- ✅ Firestore rules sudah dikonfigurasi dengan benar
- ✅ Firestore indexes sudah optimal
- ✅ Clean architecture sudah diterapkan sesuai TSD
- ✅ Database schema sesuai dengan dokumentasi
- ✅ Semua fitur MVP sesuai dengan PRD

### Compliance
- 📋 Sesuai dengan PRD (Product Requirements Document)
- 🗄️ Sesuai dengan Database Schema
- 🔧 Sesuai dengan TSD (Technical Specification Document)
- 🔥 Menggunakan Firebase Spark plan (free tier)

---

## Catatan Implementasi

### Bouncing Scroll Physics
Semua ListView dan scrollable widgets menggunakan:
```dart
physics: const BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
)
```

### Pull-to-Refresh
Implementasi menggunakan `RefreshIndicator`:
```dart
RefreshIndicator(
  onRefresh: () async {
    // Refresh logic
  },
  child: ListView(...),
)
```

### Localization
Semua string UI menggunakan `AppLocalizations`:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.languageLabel)
```

### Firebase Spark Compliance
- Authentication: Google Sign-In (gratis)
- Firestore: Optimized queries dengan composite indexes
- Cloud Functions: Akan menggunakan free tier quota (2M invocations/month)
- Hosting: Gratis untuk usage rendah (10GB storage, 360MB/day transfer)
- Storage: Tidak digunakan di MVP

---

## Next Steps

### Fitur yang Perlu Ditambahkan (Post-MVP)
1. Decision Journal dengan AI-assisted insights
2. Emotional Tagging untuk bias awareness
3. Success Scenario Balancing
4. Decision Quality Score
5. Anonymous Benchmark
6. Contextual Data Enrichment
7. Voice Input
8. Decision Template

### Optimizations
1. Implement caching strategy dengan Hive
2. Optimize Firestore queries dengan pagination
3. Add offline support untuk draft management
4. Implement background sync untuk outbox queue

### Testing
1. Unit tests untuk business logic
2. Widget tests untuk UI components
3. Integration tests untuk user flows
4. Performance testing untuk AI response time

---

**Versi:** 1.0.0-MVP  
**Tanggal:** 7 Mei 2026  
**Status:** Development

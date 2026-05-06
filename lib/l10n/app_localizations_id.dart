// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Nalara';

  @override
  String get helloWorld => 'Halo Dunia!';

  @override
  String get dashboard => 'Dashboard';

  @override
  String remainingAnalysis(int count) {
    return 'Tersisa $count analisis hari ini';
  }

  @override
  String get loadingLimit => 'Memuat limit...';

  @override
  String get limitUnavailable => 'Limit tidak tersedia';

  @override
  String get newAnalysis => 'Analisis Baru';

  @override
  String get decisionHistory => 'Histori Keputusan';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(int count) {
    return '$count hari berturut-turut';
  }

  @override
  String get career => 'Karier 💼';

  @override
  String get financial => 'Finansial 💰';

  @override
  String get emptyHistoryTitle => 'Belum ada histori';

  @override
  String get emptyHistoryMessage =>
      'Mulai analisis keputusan untuk melihat histori di sini.';

  @override
  String get continueWithGoogle => 'Lanjut dengan Google';

  @override
  String get welcomeHeadline =>
      'Berpikir lebih jernih sebelum mengambil keputusan besar.';

  @override
  String get welcomeSubheadline =>
      'Nalara membantu kamu melihat risiko, tanda awal, dan langkah pencegahan sebelum keputusan terasa mahal.';

  @override
  String get riskSimulationTitle => 'Simulasi risiko';

  @override
  String get riskSimulationDescription => 'Tiga skenario gagal yang realistis.';

  @override
  String get earlyIndicatorsTitle => 'Indikator dini';

  @override
  String get earlyIndicatorsDescription =>
      'Sinyal awal yang perlu kamu pantau.';

  @override
  String get preventiveActionsTitle => 'Tindakan preventif';

  @override
  String get preventiveActionsDescription =>
      'Langkah praktis dengan timing jelas.';

  @override
  String get draft => 'Draft';

  @override
  String get decisionIntelligence => 'Decision Intelligence';

  @override
  String get homeHeroHeadline => 'Lihat risiko sebelum keputusan terasa mahal.';

  @override
  String get homeHeroDescription =>
      'Nalara menyusun pre-mortem: skenario gagal, penyebab, indikator dini, dan tindakan pencegahan yang bisa langsung kamu lakukan.';

  @override
  String analysisUsed(int used, int limit) {
    return '$used/$limit terpakai';
  }

  @override
  String get decisionPromptTitle =>
      'Mulai dari keputusan yang paling mengganjal';

  @override
  String get careerShortcutMessage => 'Resign, pindah tim, tawaran baru.';

  @override
  String get financialShortcutMessage => 'KPR, investasi besar, cicilan.';

  @override
  String get draftShortcutTitle => 'Lanjutkan Draft';

  @override
  String get draftShortcutMessage => 'Draft offline tersimpan otomatis.';

  @override
  String get reviewReminderTitle => 'Review keputusan penting';

  @override
  String get reviewReminderMessage =>
      'Reminder D+7 dan D+30 akan muncul di sini setelah keputusan disimpan.';

  @override
  String get limitUnavailableChip => 'Limit tidak tersedia';

  @override
  String get analysisTitle => 'Analisis Keputusan';

  @override
  String get analysisIntro =>
      'Beri konteks yang cukup, lalu biarkan Nalara mencari risiko yang mungkin terlewat.';

  @override
  String get decisionContextTitle => 'Keputusan yang dipertimbangkan';

  @override
  String get decisionContextHint =>
      'Contoh: Saya sedang mempertimbangkan pindah kerja ke startup dengan gaji lebih rendah tapi peluang belajar lebih besar...';

  @override
  String get analysisContextEnough => 'Konteks cukup untuk analisis awal.';

  @override
  String get analysisContextMinimum =>
      'Minimal 10 kata agar analisis tidak terlalu dangkal.';

  @override
  String wordCountLabel(int count) {
    return '$count kata';
  }

  @override
  String charactersLeft(int count) {
    return '$count karakter';
  }

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get analyzeAction => 'Analisis';

  @override
  String get analysisLimitReached =>
      'Limit harian tercapai. Coba lagi setelah reset harian.';

  @override
  String get analysisLoadingMessage => 'Menganalisis keputusan...';

  @override
  String get analysisLoadingDescription =>
      'Nalara sedang menyusun skenario gagal, indikator dini, dan tindakan pencegahan yang paling masuk akal.';

  @override
  String get analysisResultTitle => 'Hasil Analisis';

  @override
  String get analysisRemainingToday => 'Sisa hari ini';

  @override
  String analysisRemainingChip(int remaining, int limit) {
    return 'Sisa $remaining/$limit hari ini';
  }

  @override
  String get analysisRootCauseLabel => 'Penyebab utama';

  @override
  String get confidenceHigh => 'Confidence Tinggi';

  @override
  String get confidenceMedium => 'Confidence Sedang';

  @override
  String get confidenceLow => 'Confidence Rendah';

  @override
  String get likelihoodHigh => 'Tinggi';

  @override
  String get likelihoodMedium => 'Sedang';

  @override
  String get likelihoodLow => 'Rendah';

  @override
  String get analysisCompleteTitle => 'Pre-mortem selesai';

  @override
  String get analysisCompleteDescription =>
      'Gunakan hasil ini sebagai peta risiko, bukan vonis akhir. Fokuskan energi ke tindakan pencegahan.';

  @override
  String get analysisScenarioTitle => 'Skenario Kegagalan';

  @override
  String get analysisFixInput => 'Perbaiki Input';

  @override
  String get analysisSaveResult => 'Simpan';

  @override
  String get analysisSavedSnackbar => 'Analisis siap disimpan ke histori.';

  @override
  String get analysisLowConfidence =>
      'Analisis ini memiliki confidence rendah karena informasi yang diberikan masih terbatas.';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterDraft => 'Draft';

  @override
  String get filterAnalyzed => 'Dianalisis';

  @override
  String get filterDone => 'Selesai';

  @override
  String get emptyDraftTitle => 'Belum ada draft';

  @override
  String get emptyDraftMessage =>
      'Draft keputusan akan muncul di sini saat tersedia.';

  @override
  String get emptyFilteredTitle => 'Belum ada item';

  @override
  String get emptyFilteredMessage =>
      'Coba pilih filter lain untuk melihat histori.';

  @override
  String get historyLoading => 'Memuat histori keputusan...';

  @override
  String get languageLabel => 'Bahasa';

  @override
  String get languageSelectionDescription =>
      'Gunakan bahasa yang paling nyaman untuk berpikir jernih.';

  @override
  String get languageIndonesianSubtitle =>
      'Direkomendasikan untuk konteks keputusan lokal.';

  @override
  String get languageEnglishSubtitle => 'Use Nalara in English.';

  @override
  String get languageOptionIndonesian => 'Bahasa Indonesia';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String languageChangedMessage(String language) {
    return 'Bahasa diubah ke $language';
  }

  @override
  String get logout => 'Keluar';

  @override
  String get logoutTitle => 'Keluar';

  @override
  String get logoutMessage => 'Apakah Anda yakin ingin keluar?';

  @override
  String get cancel => 'Batal';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// The name of the application
  ///
  /// In id, this message translates to:
  /// **'Nalara'**
  String get appName;

  /// A greeting message
  ///
  /// In id, this message translates to:
  /// **'Halo Dunia!'**
  String get helloWorld;

  /// Title for the dashboard screen
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Message showing how many analysis requests are left
  ///
  /// In id, this message translates to:
  /// **'Tersisa {count} analisis hari ini'**
  String remainingAnalysis(int count);

  /// Message shown while checking analysis limit
  ///
  /// In id, this message translates to:
  /// **'Memuat limit...'**
  String get loadingLimit;

  /// Message shown when limit cannot be loaded
  ///
  /// In id, this message translates to:
  /// **'Limit tidak tersedia'**
  String get limitUnavailable;

  /// Button text to start a new analysis
  ///
  /// In id, this message translates to:
  /// **'Analisis Baru'**
  String get newAnalysis;

  /// Title for the decision history section
  ///
  /// In id, this message translates to:
  /// **'Histori Keputusan'**
  String get decisionHistory;

  /// Label for the user streak
  ///
  /// In id, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Message showing streak days
  ///
  /// In id, this message translates to:
  /// **'{count} hari berturut-turut'**
  String streakDays(int count);

  /// Category for career decisions
  ///
  /// In id, this message translates to:
  /// **'Karier 💼'**
  String get career;

  /// Category for financial decisions
  ///
  /// In id, this message translates to:
  /// **'Finansial 💰'**
  String get financial;

  /// Title shown when history is empty
  ///
  /// In id, this message translates to:
  /// **'Belum ada histori'**
  String get emptyHistoryTitle;

  /// Message shown when history is empty encouraging user to start an analysis
  ///
  /// In id, this message translates to:
  /// **'Mulai analisis keputusan untuk melihat histori di sini.'**
  String get emptyHistoryMessage;

  /// Primary Google sign-in CTA on the welcome screen
  ///
  /// In id, this message translates to:
  /// **'Lanjut dengan Google'**
  String get continueWithGoogle;

  /// Main headline on the welcome screen
  ///
  /// In id, this message translates to:
  /// **'Berpikir lebih jernih sebelum mengambil keputusan besar.'**
  String get welcomeHeadline;

  /// Short value explanation on the welcome screen
  ///
  /// In id, this message translates to:
  /// **'Nalara membantu kamu melihat risiko, tanda awal, dan langkah pencegahan sebelum keputusan terasa mahal.'**
  String get welcomeSubheadline;

  /// Feature preview title for risk simulation
  ///
  /// In id, this message translates to:
  /// **'Simulasi risiko'**
  String get riskSimulationTitle;

  /// Feature preview description for risk simulation
  ///
  /// In id, this message translates to:
  /// **'Tiga skenario gagal yang realistis.'**
  String get riskSimulationDescription;

  /// Feature preview title for early indicators
  ///
  /// In id, this message translates to:
  /// **'Indikator dini'**
  String get earlyIndicatorsTitle;

  /// Feature preview description for early indicators
  ///
  /// In id, this message translates to:
  /// **'Sinyal awal yang perlu kamu pantau.'**
  String get earlyIndicatorsDescription;

  /// Feature preview title for preventive actions
  ///
  /// In id, this message translates to:
  /// **'Tindakan preventif'**
  String get preventiveActionsTitle;

  /// Feature preview description for preventive actions
  ///
  /// In id, this message translates to:
  /// **'Langkah praktis dengan timing jelas.'**
  String get preventiveActionsDescription;

  /// Draft status and navigation label
  ///
  /// In id, this message translates to:
  /// **'Draft'**
  String get draft;

  /// Product category chip on dashboard
  ///
  /// In id, this message translates to:
  /// **'Decision Intelligence'**
  String get decisionIntelligence;

  /// Dashboard hero headline
  ///
  /// In id, this message translates to:
  /// **'Lihat risiko sebelum keputusan terasa mahal.'**
  String get homeHeroHeadline;

  /// Dashboard hero description
  ///
  /// In id, this message translates to:
  /// **'Nalara menyusun pre-mortem: skenario gagal, penyebab, indikator dini, dan tindakan pencegahan yang bisa langsung kamu lakukan.'**
  String get homeHeroDescription;

  /// Usage count text
  ///
  /// In id, this message translates to:
  /// **'{used}/{limit} terpakai'**
  String analysisUsed(int used, int limit);

  /// Dashboard shortcut section title
  ///
  /// In id, this message translates to:
  /// **'Mulai dari keputusan yang paling mengganjal'**
  String get decisionPromptTitle;

  /// Career shortcut description
  ///
  /// In id, this message translates to:
  /// **'Resign, pindah tim, tawaran baru.'**
  String get careerShortcutMessage;

  /// Financial shortcut description
  ///
  /// In id, this message translates to:
  /// **'KPR, investasi besar, cicilan.'**
  String get financialShortcutMessage;

  /// Draft shortcut title
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Draft'**
  String get draftShortcutTitle;

  /// Draft shortcut description
  ///
  /// In id, this message translates to:
  /// **'Draft offline tersimpan otomatis.'**
  String get draftShortcutMessage;

  /// Dashboard reminder banner title
  ///
  /// In id, this message translates to:
  /// **'Review keputusan penting'**
  String get reviewReminderTitle;

  /// Dashboard reminder banner message
  ///
  /// In id, this message translates to:
  /// **'Reminder D+7 dan D+30 akan muncul di sini setelah keputusan disimpan.'**
  String get reviewReminderMessage;

  /// Limit unavailable chip text
  ///
  /// In id, this message translates to:
  /// **'Limit tidak tersedia'**
  String get limitUnavailableChip;

  /// No description provided for @analysisTitle.
  ///
  /// In id, this message translates to:
  /// **'Analisis Keputusan'**
  String get analysisTitle;

  /// No description provided for @analysisIntro.
  ///
  /// In id, this message translates to:
  /// **'Beri konteks yang cukup, lalu biarkan Nalara mencari risiko yang mungkin terlewat.'**
  String get analysisIntro;

  /// No description provided for @decisionContextTitle.
  ///
  /// In id, this message translates to:
  /// **'Keputusan yang dipertimbangkan'**
  String get decisionContextTitle;

  /// No description provided for @decisionContextHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Saya sedang mempertimbangkan pindah kerja ke startup dengan gaji lebih rendah tapi peluang belajar lebih besar...'**
  String get decisionContextHint;

  /// No description provided for @analysisContextEnough.
  ///
  /// In id, this message translates to:
  /// **'Konteks cukup untuk analisis awal.'**
  String get analysisContextEnough;

  /// No description provided for @analysisContextMinimum.
  ///
  /// In id, this message translates to:
  /// **'Minimal 10 kata agar analisis tidak terlalu dangkal.'**
  String get analysisContextMinimum;

  /// Word count label
  ///
  /// In id, this message translates to:
  /// **'{count} kata'**
  String wordCountLabel(int count);

  /// Characters left label
  ///
  /// In id, this message translates to:
  /// **'{count} karakter'**
  String charactersLeft(int count);

  /// No description provided for @categoryLabel.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get categoryLabel;

  /// No description provided for @analyzeAction.
  ///
  /// In id, this message translates to:
  /// **'Analisis'**
  String get analyzeAction;

  /// No description provided for @analysisLimitReached.
  ///
  /// In id, this message translates to:
  /// **'Limit harian tercapai. Coba lagi setelah reset harian.'**
  String get analysisLimitReached;

  /// No description provided for @analysisLoadingMessage.
  ///
  /// In id, this message translates to:
  /// **'Menganalisis keputusan...'**
  String get analysisLoadingMessage;

  /// No description provided for @analysisLoadingDescription.
  ///
  /// In id, this message translates to:
  /// **'Nalara sedang menyusun skenario gagal, indikator dini, dan tindakan pencegahan yang paling masuk akal.'**
  String get analysisLoadingDescription;

  /// No description provided for @analysisResultTitle.
  ///
  /// In id, this message translates to:
  /// **'Hasil Analisis'**
  String get analysisResultTitle;

  /// No description provided for @analysisRemainingToday.
  ///
  /// In id, this message translates to:
  /// **'Sisa hari ini'**
  String get analysisRemainingToday;

  /// Remaining usage chip
  ///
  /// In id, this message translates to:
  /// **'Sisa {remaining}/{limit} hari ini'**
  String analysisRemainingChip(int remaining, int limit);

  /// No description provided for @analysisRootCauseLabel.
  ///
  /// In id, this message translates to:
  /// **'Penyebab utama'**
  String get analysisRootCauseLabel;

  /// No description provided for @confidenceHigh.
  ///
  /// In id, this message translates to:
  /// **'Confidence Tinggi'**
  String get confidenceHigh;

  /// No description provided for @confidenceMedium.
  ///
  /// In id, this message translates to:
  /// **'Confidence Sedang'**
  String get confidenceMedium;

  /// No description provided for @confidenceLow.
  ///
  /// In id, this message translates to:
  /// **'Confidence Rendah'**
  String get confidenceLow;

  /// No description provided for @likelihoodHigh.
  ///
  /// In id, this message translates to:
  /// **'Tinggi'**
  String get likelihoodHigh;

  /// No description provided for @likelihoodMedium.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get likelihoodMedium;

  /// No description provided for @likelihoodLow.
  ///
  /// In id, this message translates to:
  /// **'Rendah'**
  String get likelihoodLow;

  /// No description provided for @analysisCompleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Pre-mortem selesai'**
  String get analysisCompleteTitle;

  /// No description provided for @analysisCompleteDescription.
  ///
  /// In id, this message translates to:
  /// **'Gunakan hasil ini sebagai peta risiko, bukan vonis akhir. Fokuskan energi ke tindakan pencegahan.'**
  String get analysisCompleteDescription;

  /// No description provided for @analysisScenarioTitle.
  ///
  /// In id, this message translates to:
  /// **'Skenario Kegagalan'**
  String get analysisScenarioTitle;

  /// No description provided for @analysisFixInput.
  ///
  /// In id, this message translates to:
  /// **'Perbaiki Input'**
  String get analysisFixInput;

  /// No description provided for @analysisSaveResult.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get analysisSaveResult;

  /// No description provided for @analysisSavedSnackbar.
  ///
  /// In id, this message translates to:
  /// **'Analisis siap disimpan ke histori.'**
  String get analysisSavedSnackbar;

  /// No description provided for @analysisLowConfidence.
  ///
  /// In id, this message translates to:
  /// **'Analisis ini memiliki confidence rendah karena informasi yang diberikan masih terbatas.'**
  String get analysisLowConfidence;

  /// No description provided for @filterAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get filterAll;

  /// No description provided for @filterDraft.
  ///
  /// In id, this message translates to:
  /// **'Draft'**
  String get filterDraft;

  /// No description provided for @filterAnalyzed.
  ///
  /// In id, this message translates to:
  /// **'Dianalisis'**
  String get filterAnalyzed;

  /// No description provided for @filterDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get filterDone;

  /// No description provided for @emptyDraftTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada draft'**
  String get emptyDraftTitle;

  /// No description provided for @emptyDraftMessage.
  ///
  /// In id, this message translates to:
  /// **'Draft keputusan akan muncul di sini saat tersedia.'**
  String get emptyDraftMessage;

  /// No description provided for @emptyFilteredTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada item'**
  String get emptyFilteredTitle;

  /// No description provided for @emptyFilteredMessage.
  ///
  /// In id, this message translates to:
  /// **'Coba pilih filter lain untuk melihat histori.'**
  String get emptyFilteredMessage;

  /// No description provided for @historyLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat histori keputusan...'**
  String get historyLoading;

  /// No description provided for @languageLabel.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get languageLabel;

  /// No description provided for @languageSelectionDescription.
  ///
  /// In id, this message translates to:
  /// **'Gunakan bahasa yang paling nyaman untuk berpikir jernih.'**
  String get languageSelectionDescription;

  /// No description provided for @languageIndonesianSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Direkomendasikan untuk konteks keputusan lokal.'**
  String get languageIndonesianSubtitle;

  /// No description provided for @languageEnglishSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Use Nalara in English.'**
  String get languageEnglishSubtitle;

  /// No description provided for @languageOptionIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageOptionIndonesian;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageChangedMessage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa diubah ke {language}'**
  String languageChangedMessage(String language);

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

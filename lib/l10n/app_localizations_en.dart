// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nalara';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get dashboard => 'Dashboard';

  @override
  String remainingAnalysis(int count) {
    return '$count analysis remaining today';
  }

  @override
  String get loadingLimit => 'Loading limit...';

  @override
  String get limitUnavailable => 'Limit unavailable';

  @override
  String get newAnalysis => 'New Analysis';

  @override
  String get decisionHistory => 'Decision History';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(int count) {
    return '$count consecutive days';
  }

  @override
  String get career => 'Career 💼';

  @override
  String get financial => 'Financial 💰';

  @override
  String get emptyHistoryTitle => 'No history yet';

  @override
  String get emptyHistoryMessage =>
      'Start a new decision analysis to see your history here.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get welcomeHeadline =>
      'Think more clearly before making a big decision.';

  @override
  String get welcomeSubheadline =>
      'Nalara helps you see risks, early signals, and preventive steps before a decision becomes costly.';

  @override
  String get riskSimulationTitle => 'Risk simulation';

  @override
  String get riskSimulationDescription => 'Three realistic failure scenarios.';

  @override
  String get earlyIndicatorsTitle => 'Early indicators';

  @override
  String get earlyIndicatorsDescription => 'Signals worth watching early.';

  @override
  String get preventiveActionsTitle => 'Preventive actions';

  @override
  String get preventiveActionsDescription =>
      'Practical next steps with clear timing.';

  @override
  String get draft => 'Draft';

  @override
  String get decisionIntelligence => 'Decision Intelligence';

  @override
  String get homeHeroHeadline => 'See the risk before a decision gets costly.';

  @override
  String get homeHeroDescription =>
      'Nalara structures a pre-mortem: failure scenarios, root causes, early indicators, and preventive actions you can take.';

  @override
  String analysisUsed(int used, int limit) {
    return '$used/$limit used';
  }

  @override
  String get decisionPromptTitle =>
      'Start with the decision that feels most unresolved';

  @override
  String get careerShortcutMessage => 'Resigning, changing teams, new offers.';

  @override
  String get financialShortcutMessage =>
      'Mortgage, major purchases, installments.';

  @override
  String get draftShortcutTitle => 'Continue Draft';

  @override
  String get draftShortcutMessage => 'Offline drafts are saved automatically.';

  @override
  String get reviewReminderTitle => 'Review important decisions';

  @override
  String get reviewReminderMessage =>
      'D+7 and D+30 reminders will appear here after a decision is saved.';

  @override
  String get limitUnavailableChip => 'Limit unavailable';

  @override
  String get analysisTitle => 'Decision Analysis';

  @override
  String get analysisIntro =>
      'Provide enough context, then let Nalara surface the risks you might miss.';

  @override
  String get decisionContextTitle => 'Decision in focus';

  @override
  String get decisionContextHint =>
      'Example: I am considering moving to a startup with lower pay but more learning opportunities...';

  @override
  String get analysisContextEnough =>
      'Context is sufficient for an initial analysis.';

  @override
  String get analysisContextMinimum =>
      'Use at least 10 words to avoid shallow analysis.';

  @override
  String wordCountLabel(int count) {
    return '$count words';
  }

  @override
  String charactersLeft(int count) {
    return '$count characters';
  }

  @override
  String get categoryLabel => 'Category';

  @override
  String get analyzeAction => 'Analyze';

  @override
  String get analysisLimitReached =>
      'Daily limit reached. Try again after reset.';

  @override
  String get analysisLoadingMessage => 'Analyzing your decision...';

  @override
  String get analysisLoadingDescription =>
      'Nalara is assembling failure scenarios, early indicators, and the most practical preventive actions.';

  @override
  String get analysisResultTitle => 'Analysis Result';

  @override
  String get analysisRemainingToday => 'Remaining today';

  @override
  String analysisRemainingChip(int remaining, int limit) {
    return '$remaining/$limit remaining today';
  }

  @override
  String get analysisRootCauseLabel => 'Root cause';

  @override
  String get confidenceHigh => 'High confidence';

  @override
  String get confidenceMedium => 'Medium confidence';

  @override
  String get confidenceLow => 'Low confidence';

  @override
  String get likelihoodHigh => 'High';

  @override
  String get likelihoodMedium => 'Medium';

  @override
  String get likelihoodLow => 'Low';

  @override
  String get analysisCompleteTitle => 'Pre-mortem complete';

  @override
  String get analysisCompleteDescription =>
      'Use this as a risk map, not a final verdict. Focus your energy on preventive actions.';

  @override
  String get analysisScenarioTitle => 'Failure Scenarios';

  @override
  String get analysisFixInput => 'Edit Input';

  @override
  String get analysisSaveResult => 'Save';

  @override
  String get analysisSavedSnackbar =>
      'Analysis is ready to be saved to history.';

  @override
  String get analysisLowConfidence =>
      'This analysis has low confidence because the provided information is limited.';

  @override
  String get filterAll => 'All';

  @override
  String get filterDraft => 'Draft';

  @override
  String get filterAnalyzed => 'Analyzed';

  @override
  String get filterDone => 'Completed';

  @override
  String get emptyDraftTitle => 'No drafts yet';

  @override
  String get emptyDraftMessage =>
      'Draft decisions will show up here once available.';

  @override
  String get emptyFilteredTitle => 'No items yet';

  @override
  String get emptyFilteredMessage => 'Try another filter to view your history.';

  @override
  String get historyLoading => 'Loading decision history...';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSelectionDescription =>
      'Use the language that feels most comfortable for clear thinking.';

  @override
  String get languageIndonesianSubtitle =>
      'Recommended for local decision context.';

  @override
  String get languageEnglishSubtitle => 'Use Nalara in English.';

  @override
  String get languageOptionIndonesian => 'Indonesian';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String languageChangedMessage(String language) {
    return 'Language changed to $language';
  }

  @override
  String get logout => 'Logout';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';
}

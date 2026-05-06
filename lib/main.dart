import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

import 'core/constants/hive_constants.dart';
import 'core/localization/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/decision/data/models/decision_model.dart';
import 'features/decision/presentation/screens/home_screen.dart';
import 'features/analysis/data/models/analysis_cache.dart';
import 'l10n/app_localizations.dart';
import 'shared/widgets/error_widget.dart';
import 'shared/widgets/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initFirebase();
  await _initGoogleSignIn();
  await _initHive();

  runApp(const ProviderScope(child: NalaraApp()));
}

Future<void> _initGoogleSignIn() async {
  try {
    await GoogleSignIn.instance.initialize(
      serverClientId: '786210665746-gbkjl6llc4qn0hkha97rfh6os8cdvtgi.apps.googleusercontent.com',
    );
  } catch (e) {
    debugPrint('Google Sign-In initialization error: $e');
  }
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DecisionModelAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AnalysisCacheAdapter());
  }

  await Hive.openBox<DecisionModel>(HiveConstants.decisionBox);
  await Hive.openBox<DecisionModel>(HiveConstants.outboxBox);
  await Hive.openBox<AnalysisCache>(HiveConstants.analysisBox);
  await Hive.openBox<dynamic>(HiveConstants.settingsBox);
  await Hive.openBox<dynamic>(HiveConstants.userCacheBox);
}

class NalaraApp extends ConsumerWidget {
  const NalaraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp(
      title: 'Nalara',
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return const HomeScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: LoadingIndicator(message: 'Menyiapkan Nalara...')),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: AppErrorWidget(message: 'Login bermasalah. Silakan coba lagi.'),
      ),
    );
  }
}

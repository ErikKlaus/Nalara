# 📝 Implementation Notes - Nalara App
**Versi:** 1.0.0-MVP | **Tanggal:** 7 Mei 2026 | **Status:** Development

---

## 1. Overview

Dokumen ini berisi catatan implementasi untuk aplikasi Nalara, termasuk perubahan yang telah dilakukan, best practices, dan panduan untuk developer.

---

## 2. Perubahan Terbaru (7 Mei 2026)

### 2.1 UI/UX Improvements

#### Bouncing Scroll Physics
**Implementasi:**
```dart
ListView(
  physics: const BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  ),
  children: [...],
)
```

**Lokasi:**
- `lib/features/decision/presentation/screens/home_screen.dart`
- `lib/features/decision/presentation/screens/history_screen.dart`
- `lib/features/decision/presentation/screens/input_screen.dart`
- `lib/features/decision/presentation/screens/detail_screen.dart`
- `lib/features/analysis/presentation/screens/result_screen.dart`

**Alasan:**
- Memberikan pengalaman scrolling yang lebih natural dan smooth
- Sesuai dengan iOS design guidelines
- Meningkatkan user experience saat scrolling

#### Pull-to-Refresh
**Implementasi:**
```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(dataProvider);
    await Future<void>.delayed(const Duration(milliseconds: 350));
  },
  child: ListView(...),
)
```

**Lokasi:**
- Dashboard: Refresh usage limit
- History: Refresh decision list
- Draft: Refresh draft list

**Alasan:**
- Memberikan cara mudah untuk refresh data
- Sesuai dengan mobile app best practices
- Meningkatkan user engagement

#### Streak Panel Redesign
**Sebelum:**
```dart
Center(
  child: Text(widget.l10n.streakDays(0)),
)
```

**Sesudah:**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Icon(Icons.local_fire_department_rounded, color: AppColors.surface),
    const SizedBox(width: AppSpacing.xs),
    Text(widget.l10n.streakDays(0)),
  ],
)
```

**Alasan:**
- Menghapus circle putih yang tidak diperlukan
- Menambahkan icon fire untuk visual yang lebih menarik
- Lebih konsisten dengan design system

### 2.2 Localization Improvements

#### String Localization Baru
**File:** `lib/l10n/app_id.arb` dan `lib/l10n/app_en.arb`

```json
{
  "languageSelectionDescription": "Gunakan bahasa yang paling nyaman untuk berpikir jernih.",
  "languageIndonesianSubtitle": "Direkomendasikan untuk konteks keputusan lokal.",
  "languageEnglishSubtitle": "Use Nalara in English."
}
```

**Alasan:**
- Menghapus hardcoded text di language selection screen
- Memastikan semua text dapat diterjemahkan
- Sesuai dengan best practices Flutter localization

#### Language Selection Screen Update
**Sebelum:**
```dart
appBar: const NalaraAppBar(title: 'Pilih Bahasa', showBackButton: true),
```

**Sesudah:**
```dart
final l10n = lookupAppLocalizations(Locale(selectedLanguage));
appBar: NalaraAppBar(title: l10n.languageLabel, showBackButton: true),
```

**Alasan:**
- Menggunakan localization untuk semua text
- Mendukung multi-language dengan benar
- Konsisten dengan arsitektur aplikasi

---

## 3. Firebase Spark Compliance

### 3.1 Firestore Configuration

#### Security Rules
**File:** `firestore.rules`

**Key Points:**
- User-scoped data: Semua data ter-isolasi per UID
- No cross-user access: Security rules mencegah akses data user lain
- Cloud Functions only write: Analyses dan AI usage logs hanya bisa ditulis oleh Cloud Functions
- Read-only system config: System config hanya bisa dibaca oleh authenticated users

#### Indexes
**File:** `firestore.indexes.json`

**Composite Indexes:**
1. `decisions` collection:
   - `uid` ASC + `createdAt` DESC
   - Untuk query histori per user dengan sorting

2. `ai_usage_logs` collection:
   - `uid` ASC + `timestamp` DESC
   - Untuk query usage logs per user

**Alasan:**
- Optimized queries untuk performa
- Mengurangi read operations
- Sesuai dengan Firestore best practices

### 3.2 Authentication

**Provider:** Google Sign-In

**Configuration:**
```json
{
  "auth": {
    "providers": {
      "googleSignIn": {
        "oAuthBrandDisplayName": "Nalara",
        "supportEmail": "setetes.id@gmail.com"
      }
    }
  }
}
```

**Free Tier Limits:**
- Unlimited authentication
- No cost for Google Sign-In

### 3.3 Cloud Functions

**Runtime:** Node.js 18+

**Free Tier Limits:**
- 2M invocations/month
- 400,000 GB-seconds/month
- 200,000 CPU-seconds/month
- 5GB outbound networking/month

**Estimated Usage (500 MAU):**
- 3 analyses/user/day = 45,000 invocations/month
- Well within free tier limits

### 3.4 Hosting

**Configuration:**
```json
{
  "hosting": {
    "public": "build/web",
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

**Free Tier Limits:**
- 10GB storage
- 360MB/day transfer
- Custom domain (1 free)

---

## 4. Clean Architecture Implementation

### 4.1 Layer Structure

```
lib/
├── core/                    # Shared utilities, theme, constants
├── features/                # Feature modules
│   ├── auth/
│   │   ├── data/           # Data sources, models, repositories impl
│   │   ├── domain/         # Entities, repositories interfaces, use cases
│   │   └── presentation/   # Screens, widgets, providers
│   ├── decision/
│   └── analysis/
└── shared/                  # Shared widgets, helpers, layouts
```

### 4.2 Dependency Rule

**Outer → Inner:**
- Presentation → Domain → Data
- Domain layer has zero dependencies on Flutter, Firebase, or any external package
- Data layer implements interfaces defined in Domain

### 4.3 State Management

**Provider:** Riverpod

**Pattern:**
```dart
// Provider
final dataProvider = StreamProvider<List<Data>>((ref) {
  final repository = ref.watch(repositoryProvider);
  return repository.watchData();
});

// Consumer
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    return data.when(
      data: (items) => ListView(...),
      loading: () => LoadingIndicator(),
      error: (error, _) => ErrorWidget(message: error.toString()),
    );
  }
}
```

---

## 5. Best Practices

### 5.1 Localization

**DO:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcomeHeadline)
```

**DON'T:**
```dart
Text('Welcome to Nalara')  // ❌ Hardcoded text
```

### 5.2 Theming

**DO:**
```dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.titleMedium,
)
```

**DON'T:**
```dart
Text(
  'Hello',
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // ❌ Hardcoded style
)
```

### 5.3 Colors

**DO:**
```dart
Container(color: AppColors.primary)
```

**DON'T:**
```dart
Container(color: Color(0xFF6750A4))  // ❌ Hardcoded color
```

### 5.4 Spacing

**DO:**
```dart
const SizedBox(height: AppSpacing.md)
```

**DON'T:**
```dart
const SizedBox(height: 16)  // ❌ Hardcoded spacing
```

### 5.5 Error Handling

**DO:**
```dart
try {
  await repository.saveData(data);
} catch (e) {
  if (e is NetworkException) {
    // Handle network error
  } else if (e is ValidationException) {
    // Handle validation error
  } else {
    // Handle generic error
  }
}
```

**DON'T:**
```dart
try {
  await repository.saveData(data);
} catch (e) {
  print(e);  // ❌ Just printing error
}
```

---

## 6. Performance Optimization

### 6.1 Firestore Queries

**Optimized Query:**
```dart
final query = firestore
  .collection('users')
  .doc(uid)
  .collection('decisions')
  .orderBy('createdAt', descending: true)
  .limit(10);
```

**Alasan:**
- Limit results untuk mengurangi read operations
- Use composite indexes untuk performa
- Implement pagination untuk large datasets

### 6.2 Widget Rebuilds

**Optimized:**
```dart
final data = ref.watch(dataProvider.select((state) => state.value));
```

**Alasan:**
- Hanya rebuild widget saat value berubah
- Mengurangi unnecessary rebuilds
- Meningkatkan performa aplikasi

### 6.3 Image Loading

**Optimized:**
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

**Alasan:**
- Cache images untuk mengurangi network requests
- Provide placeholder untuk better UX
- Handle errors gracefully

---

## 7. Testing Strategy

### 7.1 Unit Tests

**Target:**
- Business logic di use cases
- Data transformations di models
- Validation logic di helpers

**Example:**
```dart
test('should validate input with minimum 10 words', () {
  final input = 'This is a test input with more than ten words here';
  expect(ValidationHelper.isValidInput(input), true);
});
```

### 7.2 Widget Tests

**Target:**
- UI components
- User interactions
- State changes

**Example:**
```dart
testWidgets('should show error message when input is invalid', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byType(TextField), 'short');
  await tester.pump();
  expect(find.text('Minimal 10 kata'), findsOneWidget);
});
```

### 7.3 Integration Tests

**Target:**
- User flows
- Navigation
- Data persistence

**Example:**
```dart
testWidgets('should complete analysis flow', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('Analisis Baru'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), validInput);
  await tester.tap(find.text('Analisis'));
  await tester.pumpAndSettle();
  expect(find.text('Hasil Analisis'), findsOneWidget);
});
```

---

## 8. Deployment Checklist

### 8.1 Pre-Deployment

- [ ] Run `flutter analyze` - No issues
- [ ] Run `flutter test` - All tests pass
- [ ] Check Firebase configuration
- [ ] Verify Firestore rules
- [ ] Test on multiple devices
- [ ] Test on multiple screen sizes
- [ ] Test offline functionality
- [ ] Test error scenarios

### 8.2 Deployment

- [ ] Build release APK/IPA
- [ ] Deploy Cloud Functions
- [ ] Deploy Firestore rules
- [ ] Deploy Firestore indexes
- [ ] Deploy web app to Firebase Hosting
- [ ] Test production environment
- [ ] Monitor Firebase usage
- [ ] Monitor error logs

### 8.3 Post-Deployment

- [ ] Monitor user feedback
- [ ] Monitor Firebase costs
- [ ] Monitor performance metrics
- [ ] Monitor error rates
- [ ] Plan next iteration

---

## 9. Known Issues & Limitations

### 9.1 MVP Limitations

**Out of Scope:**
- Flowchart / visualisasi kompleks
- Google Calendar integration
- Personal bias profiling
- Collaborative workspace
- Analisis komparatif antar keputusan
- Push notification
- Social sharing
- Premium subscription / payment gateway
- Export PDF

### 9.2 Technical Debt

**To Address:**
1. Implement comprehensive error handling
2. Add retry logic untuk network failures
3. Implement offline queue untuk draft sync
4. Add analytics tracking
5. Implement crash reporting
6. Add performance monitoring

---

## 10. Resources

### 10.1 Documentation

- [PRD](./01_PRD_Nalara.md)
- [Database Schema](./02_Database_Schema_Nalara.md)
- [TSD](./03_TSD_Nalara.md)
- [FSD](./04_FSD_Nalara.md)
- [BRD](./05_BRD_Nalara.md)
- [Implementation Plan](./06_Implementation_Plan_Nalara.md)

### 10.2 External Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design 3](https://m3.material.io/)

---

**Last Updated:** 7 Mei 2026  
**Maintainer:** Development Team  
**Status:** Active Development

<div align="center">

# 🚀 Flutter Riverpod Boilerplate

### A Production-Ready, Opinionated Flutter Starter Template

![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.6+-0553B1?style=for-the-badge)
![GoRouter](https://img.shields.io/badge/GoRouter-14.x-4CAF50?style=for-the-badge)
![Gradle](https://img.shields.io/badge/Gradle-9.1-02303A?style=for-the-badge&logo=gradle&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-9C27B0?style=for-the-badge)

**Clone → Build → Ship.** No architecture debates. No rewrites at scale.

[Features](#-features) • [Quick Start](#-quick-start) • [Developer Guide](DEVELOPER_GUIDE.md) • [Architecture](#-architecture)

</div>

---

## 📖 Table of Contents

- [Why This Boilerplate?](#-why-this-boilerplate)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Quick Start](#-quick-start)
- [Step-by-Step Setup](#-step-by-step-setup)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Core Concepts](#-core-concepts)
- [Commands](#-commands)
- [Creating Your First Feature](#-creating-your-first-feature)
- [Firebase Setup](#-firebase-setup)
- [Testing](#-testing)
- [CI/CD Pipeline](#-cicd-pipeline)
- [AI Agents & LLM Development](#-ai-agents--llm-development)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🤔 Why This Boilerplate?

<table>
<tr>
<td width="50%">

### ✅ This IS For You If...

- You want a **production-ready** starting point
- You prefer **conventions over configuration**
- You value **clean architecture** and **testability**
- You're building apps that need to **scale**
- You want to skip weeks of initial setup
- You need **offline-first** capabilities
- You want built-in **Firebase integration**

</td>
<td width="50%">

### ❌ This Is NOT...

- A tutorial or learning resource
- A minimal starter (it's comprehensive)
- A flexible "choose your own adventure" template
- A playground for experimentation
- A beginner-level project

</td>
</tr>
</table>

> 💡 **Philosophy**: This boilerplate enforces **feature-first Clean Architecture** with **Riverpod Code Generation** to ensure consistency across teams and projects. Every decision is made for you—just code your features.

---

## 🎯 2026 Modern Patterns

This boilerplate is built on **2026 best practices** for maximum productivity:

| Pattern                        | What It Means                                             | Your Benefit                                   |
| :----------------------------- | :-------------------------------------------------------- | :--------------------------------------------- |
| **Riverpod 3.0 Offline-First** | `@JsonPersist()` with auto stale-while-revalidate caching | Instant data loading, seamless offline support |
| **Mutations API**              | Declarative loading/error states for writes               | No more manual loading spinners                |
| **Extension Types**            | Zero-cost type-safe wrappers (e.g., `UserId`)             | Compile-time safety without runtime overhead   |
| **Impeller Rendering**         | Precompiled shader engine (default)                       | Smooth 120fps animations, no jank              |
| **Golden Tests**               | Visual regression testing                                 | Catch UI changes automatically                 |
| **Dot Shorthand Syntax**       | `variant: .primary` instead of `AppButtonVariant.primary` | Cleaner, more readable code                    |
| **Pattern Matching**           | `if (data case Success(:final value))`                    | Type-safe destructuring                        |

---

## ✨ Features

<table>
<tr>
<td width="33%">

### 🏗️ Architecture

- ✅ Feature-first Clean Architecture
- ✅ Riverpod 3.x (Code Generation)
- ✅ Dependency Injection
- ✅ Result Pattern (Error Handling)
- ✅ Strict Lints (very_good_analysis)
- ✅ SOLID Principles

</td>
<td width="33%">

### 📱 State & Navigation

- ✅ Type-safe GoRouter 17.x
- ✅ Auth Guards & Redirects
- ✅ Deep Links (Universal Links)
- ✅ Event-driven Startup Logic
- ✅ Reactive Forms
- ✅ Flutter Hooks Integration

</td>
<td width="33%">

### 🌐 Networking & Caching

- ✅ Dio with Interceptors
- ✅ **Offline-First Caching (Drift)** ✨2026
- ✅ **Stale-While-Revalidate** ✨2026
- ✅ Auto Token Refresh & Retry
- ✅ HTTP/3 & Brotli Support
- ✅ ETag Caching

</td>
</tr>
<tr>
<td width="33%">

### 💾 Storage

- ✅ Secure Storage (Encrypted)
- ✅ SQLite (Drift ORM)
- ✅ SharedPreferences
- ✅ Fresh Install Handler (iOS)
- ✅ Cache Expiry Management

</td>
<td width="33%">

### 🔐 Security & Auth

- ✅ Biometric Auth (Face/Touch ID)
- ✅ Secure Token Management
- ✅ Auto-Session Expiry
- ✅ Concurrent Token Refresh
- ✅ iOS Keychain Handling

</td>
<td width="33%">

### 🎨 UI/UX

- ✅ Material 3 Theming
- ✅ Light/Dark/System Modes
- ✅ **Impeller Engine** ✨2026
- ✅ 25+ Animation Widgets
- ✅ Shimmer Loading States
- ✅ Localized (en/bn)

</td>
</tr>
<tr>
<td width="33%">

### 📊 Firebase Suite

- ✅ Crashlytics (Crash Reporting)
- ✅ Analytics (User Tracking)
- ✅ Performance Monitoring
- ✅ Remote Config (Feature Flags)
- ✅ Screen Trace Auto-Tracking

</td>
<td width="33%">

### 🔔 Notifications & UX

- ✅ Local Notifications
- ✅ Scheduled Notifications
- ✅ In-App Review Prompts
- ✅ **Figma Integration** ✨2026
- ✅ Badge Management

</td>
<td width="33%">

### 🛡️ Testing & Quality

- ✅ **Golden Tests** ✨2026
- ✅ Unit + Widget + Integration
- ✅ **80%+ Code Coverage**
- ✅ Mocktail for Mocking
- ✅ **Riverpod 3.0 Mutations** ✨2026

</td>
</tr>
</table>

---

## 🛠️ Tech Stack

| Category          | Technology                      | Description                                  |
| :---------------- | :------------------------------ | :------------------------------------------- |
| **Framework**     | `Flutter 3.10+`                 | Cross-platform UI toolkit                    |
| **Language**      | `Dart 3.x`                      | Modern, null-safe language                   |
| **State**         | `riverpod_generator` (3.0)      | **Compile-safe state + offline persistence** |
| **Hooks**         | `flutter_hooks`                 | React-like hooks for Flutter                 |
| **Routing**       | `go_router`                     | Declarative routing with guards              |
| **Network**       | `dio` + `native_dio_adapter`    | HTTP client with HTTP/3 support              |
| **Persistence**   | `drift` + `@JsonPersist()`      | **Stale-while-revalidate caching**           |
| **Forms**         | `reactive_forms`                | Model-driven form validation                 |
| **Auth**          | `local_auth`                    | Biometric authentication                     |
| **Firebase**      | `firebase_*`                    | Analytics, Crashlytics, Perf, RC             |
| **I18n**          | `flutter_localizations`         | Intl with ARB files                          |
| **Animations**    | `flutter_animate` + `lottie`    | Declarative & Lottie animations              |
| **Code Style**    | `very_good_analysis`            | Strict lint rules (500+ rules)               |
| **Testing**       | `mocktail` + `flutter_test`     | **Golden + Unit + Widget tests**             |
| **Serialization** | `freezed` + `json_serializable` | Immutable models with codegen                |

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK **3.47+** ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart SDK **3.13+** (included with Flutter)
- Java 17 or Java 21 (for Android builds with Gradle 9.1 / AGP 9.0)
- Git ([Download](https://git-scm.com/downloads))
- A code editor (VS Code recommended with Flutter extension)
- Xcode (for iOS development on macOS)
- Android Studio (for Android development)

### 5-Minute Setup

```bash
# 1. Clone the repository
git clone https://github.com/ShahriarHossainRifat/riverpod_go_router_boilerplate.git my_app
cd my_app

# 2. Remove existing git history and start fresh
rm -rf .git && git init

# 3. Rename project to your app name
make rename NAME=my_app ORG=com.example DISPLAY="My Awesome App"

# 4. Setup dependencies and generate code
make prepare

# 5. Run the app
flutter run
```

That's it! 🎉 Your app is running.

---

## 📋 Step-by-Step Setup

For beginners, here's a detailed walkthrough:

### Step 1: Clone the Repository

```bash
git clone https://github.com/ShahriarHossainRifat/riverpod_go_router_boilerplate.git my_app
cd my_app
```

This downloads the boilerplate code into a folder called `my_app`.

### Step 2: Remove Git History

```bash
rm -rf .git
git init
```

This removes the boilerplate's git history so you can start fresh with your own commits.

### Step 3: Rename the Project

```bash
make rename NAME=myapp ORG=com.yourcompany DISPLAY="Your App Name"
```

This updates:

- Package name in pubspec.yaml
- Bundle identifiers (iOS/Android)
- Display name shown on devices

**Parameters:**

- `NAME`: lowercase, no spaces (e.g., `myshoppingapp`)
- `ORG`: reverse domain notation (e.g., `com.yourcompany`)
- `DISPLAY`: Human-readable name with spaces allowed

### Step 4: Install Dependencies & Generate Code

```bash
make prepare
```

This command:

1. Cleans any previous builds
2. Gets all Flutter dependencies (`flutter pub get`)
3. Generates localization files
4. Runs build_runner to generate Riverpod code

### Step 5: Run the App

```bash
# iOS Simulator
flutter run -d iPhone

# Android Emulator
flutter run -d emulator

# All connected devices
flutter run
```

### Step 6: Verify Everything Works

The app should launch with:

- A splash screen
- Demo login page
- Home page after "login"

---

## 🏛️ Architecture

We follow a strict **Feature-First Clean Architecture**:

```
lib/features/my_feature/
├── data/                  # 💾 Data Layer
│   ├── datasources/       # API/DB calls
│   ├── models/            # DTOs (Data Transfer Objects)
│   └── repositories/      # Repository Implementations
│
├── domain/                # 🧠 Domain Layer (Pure Dart)
│   ├── entities/          # Business Objects
│   └── repositories/      # Repository Interfaces
│
└── presentation/          # 🎨 Presentation Layer
    ├── pages/             # Full-screen Widgets
    ├── providers/         # Riverpod Notifiers
    └── widgets/           # Feature-specific Widgets
```

### Key Architecture Rules

| Rule                 | Description                                                                |
| :------------------- | :------------------------------------------------------------------------- |
| **Dependency Rule**  | Domain depends on nothing. Data implements Domain. Presentation uses both. |
| **Logic Placement**  | Business logic goes in Notifiers or Services. Never in UI widgets.         |
| **State Management** | Use `@riverpod` codegen exclusively. No raw `StateProvider`.               |
| **Error Handling**   | Use `Result<T>` monad for all fallible operations.                         |

---

## 📁 Project Structure

```
lib/
├── app/                   # Global app config
│   ├── router/            # GoRouter configuration & routes
│   └── startup/           # App lifecycle & startup logic
├── config/                # Environment configuration
├── core/                  # Shared kernel (27 modules)
│   ├── analytics/         # Firebase Analytics
│   ├── biometric/         # Biometric authentication
│   ├── cache/             # Offline caching (Drift)
│   ├── constants/         # App constants, API endpoints
│   ├── crashlytics/       # Firebase Crashlytics
│   ├── deep_link/         # Deep links & universal links
│   ├── extensions/        # Dart/Flutter extensions
│   ├── feedback/          # Context-free snackbars/dialogs
│   ├── forms/             # Reactive Forms configs
│   ├── hooks/             # Custom Flutter Hooks
│   ├── localization/      # Locale management & persistence
│   ├── network/           # Dio, interceptors, API client
│   ├── notifications/     # Local notifications
│   ├── performance/       # Firebase Performance
│   ├── permissions/       # Permission handling
│   ├── remote_config/     # Firebase Remote Config
│   ├── result/            # Result monad
│   ├── review/            # In-app review prompts
│   ├── session/           # Session state
│   ├── storage/           # Secure storage
│   ├── theme/             # App theming
│   ├── utils/             # Validators, logger, etc.
│   ├── version/           # App version & force update
│   └── widgets/           # Reusable UI components (25+)
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   ├── home/              # Home screen
│   ├── onboarding/        # Onboarding flow
│   └── settings/          # App settings
├── l10n/                  # Localization (ARB files)
└── main.dart              # Entry point
```

### Core Module Highlights

| Directory       | Contents                                                       |
| :-------------- | :------------------------------------------------------------- |
| `constants/`    | `AppConstants`, `ApiEndpoints`, `Assets`, `StorageKeys`        |
| `extensions/`   | `context.colorScheme`, `'str'.capitalized`, `123.formatted`    |
| `widgets/`      | 25+ reusable widgets (buttons, animations, dialogs, inputs)    |
| `hooks/`        | `useOnMount`, `useDebounce`, `useToggle`, `usePagination`      |
| `analytics/`    | Screen tracking, event logging, user properties                |
| `network/`      | API client, interceptors, caching, token refresh               |
| `deep_link/`    | Universal links (iOS) & App Links (Android) handling           |
| `feedback/`     | Context-free `FeedbackService` for snackbars/dialogs           |
| `review/`       | Smart in-app review prompting with eligibility tracking        |
| `version/`      | App version checking, force update & optional update prompts   |
| `localization/` | `LocaleNotifier` with persistence, supports en/bn (extensible) |

---

## 🎯 Core Concepts

### Result Pattern (Error Handling)

Instead of throwing exceptions, we use the `Result<T>` monad:

```dart
// In repository
Future<Result<User>> fetchUser(String id) async {
  try {
    final response = await apiClient.get('/users/$id');
    return Success(User.fromJson(response));
  } catch (e) {
    return Failure(ApiException.from(e));
  }
}

// In UI/Notifier
final result = await repo.fetchUser('123');
result.fold(
  onSuccess: (user) => state = AsyncData(user),
  onFailure: (error) => state = AsyncError(error, StackTrace.current),
);
```

### Riverpod Patterns

```dart
// Read-only async data
@riverpod
Future<User> currentUser(Ref ref) async {
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getCurrentUser();
  return result.getOrThrow();
}

// Mutable state with notifier
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}
```

### Reusable Widgets

```dart
// ✅ Use built-in components
AsyncValueWidget<User>(
  value: ref.watch(userProvider),
  data: (user) => Text(user.name),
)

AppButton(
  label: 'Submit',
  onPressed: _submit,
  variant: AppButtonVariant.primary,
)

VerticalSpace.md()  // 16px gap
HorizontalSpace.sm() // 8px gap

// Staggered list animations
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => FadeIn.staggered(
    index: index,
    child: ListTile(title: Text(items[index].name)),
  ),
)

// ❌ Don't create custom alternatives
SizedBox(height: 16)  // Use VerticalSpace.md() instead
Duration(milliseconds: 300)  // Use AppConstants.animationNormal instead
```

### Screen Analytics (Important!)

```dart
// ✅ Track screen views using useOnMount (HookConsumerWidget)
class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });
    return Scaffold(...);
  }
}

// ❌ NEVER track analytics in build() - fires on every rebuild!
```

---

## 💻 Commands

We use `make` to simplify common tasks:

| Command               | Description                            |
| :-------------------- | :------------------------------------- |
| `make prepare`        | Full setup: Clean + L10n + Gen Code    |
| `make gen`            | Run code gen (build_runner + l10n)     |
| `make l10n`           | Generate localization files only       |
| `make watch`          | Run `build_runner watch` (Development) |
| `make clean`          | Clean build artifacts & deps           |
| `make format`         | Format code & Apply fixes              |
| `make lint`           | Run static analysis                    |
| `make test`           | Run all tests                          |
| `make upgrade`        | Upgrade dependencies                   |
| `make ci`             | Run CI checks (Lint + Test)            |
| `make feature NAME=x` | Create new feature module              |
| `make rename NAME=x`  | Rename the project                     |
| `make help`           | Show all available commands            |

---

## 🎨 App Icons & Splash Screen

### App Launcher Icons

The boilerplate uses `flutter_launcher_icons` for generating app icons across all platforms.

**Setup:**

1. Place your icon file at `assets/images/app_logo.png` (1024x1024 recommended)
2. Configure in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  image_path: "assets/images/app_logo.png"
  android: true
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/app_logo.png"
  ios: true
  remove_alpha_ios: true
```

3. Generate icons:

```bash
dart run flutter_launcher_icons
```

### Native Splash Screen

The splash screen is configured via `flutter_native_splash`:

```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/images/app_logo.png
  android_12:
    color: "#FFFFFF"
    image: assets/images/app_logo.png
```

Generate:

```bash
dart run flutter_native_splash:create
```

---

## 🎬 Lottie Animations

Lottie enables high-performance, vector-based animations created in After Effects.

### Usage

```dart
import 'package:lottie/lottie.dart';
import 'package:your_app/core/constants/assets.dart';

// Basic usage
Lottie.asset(Assets.loadingAnimation)

// With controller
Lottie.asset(
  Assets.successAnimation,
  width: 100,
  height: 100,
  repeat: false,
  onLoaded: (composition) {
    // Animation loaded
  },
)

// Network animations
Lottie.network('https://example.com/animation.json')
```

### Available Placeholders

| Asset                      | Path                              | Use For        |
| :------------------------- | :-------------------------------- | :------------- |
| `Assets.loadingAnimation`  | `assets/animations/loading.json`  | Loading states |
| `Assets.successAnimation`  | `assets/animations/success.json`  | Success states |
| `Assets.errorAnimation`    | `assets/animations/error.json`    | Error states   |
| `Assets.emptyAnimation`    | `assets/animations/empty.json`    | Empty lists    |
| `Assets.confettiAnimation` | `assets/animations/confetti.json` | Celebrations   |

Find free animations at [LottieFiles.com](https://lottiefiles.com/).

---

## 📐 Responsive Design Guidelines

The boilerplate enforces a strict responsive layout system. **Never use magic numbers for dimensions.**

### Breakpoints

| Breakpoint | Width        | Usage                          |
| :--------- | :----------- | :----------------------------- |
| Mobile     | `< 600px`    | Single-column layouts          |
| Tablet     | `600-1024px` | 2-column layouts, larger touch |
| Desktop    | `> 1024px`   | Multi-column, dense layouts    |

### Responsive Widgets

```dart
// Check screen size
if (context.isMobile) { ... }
if (context.isTablet) { ... }
if (context.isDesktop) { ... }

// Responsive values
final padding = context.responsive<double>(
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// ResponsiveBuilder for complex layouts
ResponsiveBuilder(
  mobile: (context) => MobileLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)

// Show/hide based on screen size
ResponsiveVisibility(
  hiddenOnMobile: true,
  child: SideNavigationRail(),
)
```

### Strict Rules

1. **Always use `AppSpacing`** for padding/margin: `AppSpacing.sm`, `AppSpacing.md`, `AppSpacing.lg`
2. **Always use `AppConstants`** for dimensions: `AppConstants.borderRadiusMD`, `AppConstants.iconSizeMD`
3. **Test on multiple screen sizes** before submitting
4. **Use `VerticalSpace` / `HorizontalSpace`** widgets instead of raw `SizedBox`

---

## 🔐 Auth-Aware Navigation

The boilerplate includes convenient auth-aware navigation extensions.

### Navigate Based on Auth Status

```dart
// Push authenticated route OR redirect to login
context.pushRouteIfAuthenticatedElse(
  widgetRef: ref,
  authenticatedRoute: AppRoute.settings,
  unauthenticatedRoute: AppRoute.login,
);

// Go (replace stack) based on auth
context.goRouteIfAuthenticatedElse(
  widgetRef: ref,
  authenticatedRoute: AppRoute.home,
  unauthenticatedRoute: AppRoute.login,
);
```

### Execute Action Only If Authenticated

```dart
// Execute action if authenticated, else redirect to login
context.executeIfAuthenticatedElse(
  widgetRef: ref,
  action: () => sendNotification(),
  unauthenticatedRoute: AppRoute.login,
);

// Example with async action
onPressed: () {
  context.executeIfAuthenticatedElse(
    widgetRef: ref,
    action: () => _submitForm(ref),
    unauthenticatedRoute: AppRoute.login,
  );
},
```

---

## 🛠️ Creating Your First Feature

### Using the Generator

**Always use the generator to create new features:**

```bash
make feature NAME=products
```

This creates the correct folder structure:

```
lib/features/products/
├── data/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```

### Implementation Steps

1. **Define Entity** (`domain/entities/product.dart`):

```dart
class Product {
  final String id;
  final String name;
  final double price;

  const Product({required this.id, required this.name, required this.price});
}
```

2. **Define Repository Interface** (`domain/repositories/product_repository.dart`):

```dart
abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts();
  Future<Result<Product>> getProduct(String id);
}
```

3. **Implement Repository** (`data/repositories/product_repository_impl.dart`):

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient;

  ProductRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<Product>>> getProducts() async {
    // Implementation
  }
}
```

4. **Create Provider** (`presentation/providers/products_provider.dart`):

```dart
@riverpod
Future<List<Product>> products(Ref ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await repo.getProducts();
  return result.getOrThrow();
}
```

5. **Build Page** (`presentation/pages/products_page.dart`):

```dart
class ProductsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return AsyncValueWidget<List<Product>>(
      value: productsAsync,
      data: (products) => ProductsList(products: products),
    );
  }
}
```

6. **Add Route** (`lib/app/router/app_router.dart`):

```dart
// Add to AppRoute enum
enum AppRoute {
  // ...existing routes
  products,
}

// Add route definition
GoRoute(
  path: '/products',
  name: AppRoute.products.name,
  builder: (context, state) => const ProductsPage(),
),
```

---

## 🔥 Firebase Setup

### Prerequisites

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`

### Step 1: Configure FlutterFire

Run this command in your project root:

```bash
flutterfire configure
```

This will:

- Ask you to select your Firebase project
- Generate `lib/firebase_options.dart` automatically
- Update your pubspec.yaml with required Firebase packages

**This file is essential** — without it, Firebase initialization will fail with "DefaultFirebaseOptions not found".

### Step 2: Enable Firebase Services in Console

In your Firebase Console, enable the services you need:

- **Analytics**: Usually enabled by default
- **Crashlytics**: Dashboard → Crashlytics → Enable
- **Performance**: Dashboard → Performance → Get Started
- **Remote Config**: Dashboard → Remote Config → Create configuration

### Step 3: Uncomment Firebase Initialization

After `flutterfire configure` generates the file, uncomment the initialization code.

#### 3a. Uncomment import in `lib/core/crashlytics/crashlytics_service.dart`

Find the commented section and uncomment the import:

```dart
// Add this import at the top of the file:
import 'package:riverpod_go_router_boilerplate/firebase_options.dart';
```

#### 3b. Uncomment Firebase init in `lib/core/crashlytics/crashlytics_service.dart`

Find the `initialize()` method and uncomment:

```dart
if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
```

#### 3c. Uncomment Crashlytics in `lib/app/bootstrap.dart`

In the `AppBootstrap.initialize()` method, uncomment:

```dart
await CrashlyticsService.initialize(
  environment: environment,
  enableInDebug: false,
);
```

### Step 4: Regenerate and Test

```bash
# Regenerate code to apply changes
make gen

# Run the app
flutter run
```

### Troubleshooting Firebase

<details>
<summary><strong>Error: "DefaultFirebaseOptions" cannot be found</strong></summary>

**Solution:**

1. Ensure `firebase_options.dart` exists in `lib/`
2. Uncomment the import in `crashlytics_service.dart`
3. Run `make gen` to regenerate code
4. Clean and rebuild: `flutter clean && flutter pub get`

</details>

<details>
<summary><strong>Error: "FirebaseCore platform not initialized"</strong></summary>

**Solution:**

1. Ensure Firebase is initialized in `CrashlyticsService.initialize()`
2. Call this method early in `AppBootstrap.initialize()` before any Firebase services are used
3. Make sure the Crashlytics initialization is uncommented in `bootstrap.dart`

</details>

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
make test

# Run specific test file
flutter test test/core/validators_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure

```
test/
├── core/
│   ├── validators_test.dart
│   └── widgets_test.dart
├── features/
│   └── auth/
│       └── auth_repository_test.dart
├── helpers/
│   └── mocks.dart           # Shared mock classes
└── widget_test.dart
```

### Writing Tests

```dart
// Unit test example
test('email validator returns error for invalid email', () {
  final validator = Validators.email('Invalid email');
  expect(validator('not-an-email'), equals('Invalid email'));
  expect(validator('valid@email.com'), isNull);
});

// Widget test example
testWidgets('AppButton shows loading state', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AppButton(
        label: 'Submit',
        onPressed: () {},
        isLoading: true,
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Mocking with Mocktail

```dart
// In test/helpers/mocks.dart
class MockAuthRepository extends Mock implements AuthRepository {}

// In test file
final mockRepo = MockAuthRepository();
when(() => mockRepo.login(any(), any()))
    .thenAnswer((_) async => const Success(mockUser));
```

---

## � CI/CD Pipeline

The project includes a comprehensive GitHub Actions workflow (`.github/workflows/ci.yml`).

### Pipeline Overview

| Trigger            | Jobs                           | Output                       |
| ------------------ | ------------------------------ | ---------------------------- |
| **Pull Request**   | Analyze & Test                 | Coverage report              |
| **Push to `main`** | Analyze & Test → Build Release | GitHub Release with APKs     |
| **Push to `dev`**  | Analyze & Test → Build Debug   | GitHub Pre-release with APKs |

### Analyze & Test Job

Runs on every PR and push:

- ✅ Dependency installation
- ✅ Code generation verification
- ✅ Format checking (`dart format`)
- ✅ Static analysis (`flutter analyze --fatal-infos`)
- ✅ Unit & widget tests with coverage
- ✅ Coverage upload to Codecov

### Build Outputs

APKs are built with `--split-per-abi` for optimized file sizes. The project name is automatically extracted from `pubspec.yaml`:

| Architecture  | Target Devices                | APK Name Format                        |
| ------------- | ----------------------------- | -------------------------------------- |
| `arm64-v8a`   | Modern Android phones (2017+) | `{project}-v{version}-arm64-v8a.apk`   |
| `armeabi-v7a` | Older 32-bit Android phones   | `{project}-v{version}-armeabi-v7a.apk` |
| `x86_64`      | Emulators, Chromebooks        | `{project}-v{version}-x86_64.apk`      |

> **Note**: When you rename your project using `scripts/rename_project.sh`, the CI/CD pipeline automatically uses the new project name for APK artifacts.

### Version Control Philosophy

Versioning is **manual and intentional**:

```yaml
# pubspec.yaml
version: 1.0.0+1 # X.Y.Z+build_number
```

- **X.Y.Z** = Semantic version (developer controls)
- **+N** = Build number (optional tracking)

**CI Guardrails:**

- ❌ Blocks `-dev` versions from shipping to `main`
- ✅ Validates CHANGELOG.md is updated
- ✅ Creates proper GitHub Releases with tags

---

## 📋 Changelog

All notable changes are documented in [CHANGELOG.md](CHANGELOG.md), following the [Keep a Changelog](https://keepachangelog.com/) format.

### Version Format

```
X.Y.Z+N
```

| Part   | Meaning                               | Example   |
| ------ | ------------------------------------- | --------- |
| **X**  | Major (breaking changes)              | `2.0.0`   |
| **Y**  | Minor (new features, backward compat) | `1.1.0`   |
| **Z**  | Patch (bug fixes)                     | `1.0.1`   |
| **+N** | Build number (optional)               | `1.0.0+5` |

### Updating the Changelog

When releasing a new version:

1. Move items from `[Unreleased]` to a new version section
2. Update `pubspec.yaml` version
3. Commit: `git commit -m "chore: release vX.Y.Z"`
4. Push to `main` — CI creates the GitHub Release automatically

---

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><strong>Build runner errors</strong></summary>

```bash
# Clean and regenerate
make clean
make prepare
```

</details>

<details>
<summary><strong>iOS Pod install fails</strong></summary>

```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

</details>

<details>
<summary><strong>Android Gradle sync issues</strong></summary>

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

</details>

<details>
<summary><strong>Code generation not working</strong></summary>

Make sure you have the `part` directive in files using `@riverpod`:

```dart
// At top of file
part 'my_provider.g.dart';

@riverpod
// ...
```

Then run:

```bash
make gen
```

</details>

<details>
<summary><strong>iOS Keychain issues after reinstall</strong></summary>

The boilerplate includes `FreshInstallHandler` that automatically clears stale Keychain data. If you're still having issues:

1. Delete the app from simulator/device
2. Reset the simulator (iOS Simulator → Device → Erase All Content and Settings)
3. Reinstall the app
</details>

### Getting Help

1. Check existing [Issues](https://github.com/ShahriarHossainRifat/riverpod_go_router_boilerplate/issues)
2. Read the [Developer Guide](DEVELOPER_GUIDE.md)
3. Open a new issue with:
   - Flutter version (`flutter --version`)
   - Error message/logs
   - Steps to reproduce

---

## 🤖 AI Agents & LLM Development

This boilerplate includes pre-configured, battle-tested rules and architecture guidelines for autonomous AI coding agents (such as Google DeepMind Antigravity, Gemini, Claude, Cursor, and GitHub Copilot).

- **Global Specifications**:
  - [`AGENTS.md`](AGENTS.md): Full architectural invariants, Riverpod rules, GoRouter guards, and commands for all AI agents.
  - [`CLAUDE.md`](CLAUDE.md): Quick reference and context for Claude / Claude Code.
  - [`.github/copilot-instructions.md`](.github/copilot-instructions.md): Context and rules for GitHub Copilot.
- **Modular Rule Files** (`.agents/rules/`):
  - [`architecture.md`](.agents/rules/architecture.md): Feature-first Clean Architecture, layer boundaries, dependency rules.
  - [`riverpod.md`](.agents/rules/riverpod.md): Riverpod 2.6+ code generation, Notifier vs AsyncNotifier, hook integration, session invalidation.
  - [`routing.md`](.agents/rules/routing.md): `AppRoute` enum, typed paths, centralized redirect guards.
  - [`coding_standards.md`](.agents/rules/coding_standards.md): Modern Dart 3.13+ (`avoid_final_parameters`), pattern matching, `Result<T>` error handling.
  - [`testing.md`](.agents/rules/testing.md): Unit and widget testing standards with `mocktail` and `ProviderContainer`.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Keep PRs focused and small

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Riverpod](https://riverpod.dev/) - Reactive caching and data-binding framework
- [GoRouter](https://pub.dev/packages/go_router) - Declarative routing package
- [Dio](https://pub.dev/packages/dio) - Powerful HTTP client
- [Drift](https://drift.simonbinder.eu/) - Reactive persistence library
- Flutter team for an amazing framework

---

<div align="center">

**Made with ❤️ for the Flutter community**

⭐ Star this repo if you find it helpful!

</div>

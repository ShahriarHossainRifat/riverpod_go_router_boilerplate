# AI Agent Guidelines & Architecture Rules

This document serves as the authoritative specification and rulebook for all AI coding agents (Antigravity, Gemini, Claude, Cursor, GitHub Copilot) operating on this repository.

---

## 1. Project Overview & Tech Stack

This project is an enterprise-grade Flutter boilerplate built with modern Dart 3.13+ and Flutter 3.47+.

- **Language & Runtime:** Dart 3.13+, Flutter 3.47+
- **Architecture:** Feature-First Clean Architecture (`core`, `features`, `app`, `config`)
- **State Management:** Riverpod 2.6+ with code generation (`@riverpod`, `hooks_riverpod`)
- **Navigation:** Declarative routing via GoRouter 14+ with reactive redirect guards
- **Data & Network:** Dio 5.8+ with custom cache, retry, and auth interceptors; functional `Result<T>` sealed class
- **Local Storage:** `shared_preferences` (typed settings) + `flutter_secure_storage` (auth tokens)
- **Forms & Hooks:** `flutter_hooks` + `reactive_forms` / custom form hooks
- **Tooling:** `build_runner`, `very_good_analysis` 11.0, Android Gradle Plugin 9.0.1, Gradle 9.1, Kotlin 2.3.20

---

## 2. Essential Commands

AI agents must use these exact commands when interacting with the project:

| Action | Command | Notes |
| :--- | :--- | :--- |
| **Code Generation** | `dart run build_runner build` | **NEVER** use `--delete-conflicting-outputs` (deprecated/removed). |
| **Watch Generation** | `dart run build_runner watch` | Continuous build during editing. |
| **Generate Localization**| `flutter gen-l10n` | Runs before code generation if l10n ARB files change. |
| **Run Unit/Widget Tests** | `flutter test` | Run all 143+ unit and widget tests. |
| **Run Single Test** | `flutter test test/path_to_test.dart` | Target specific test file. |
| **Code Formatting** | `dart format lib test` | Format according to project style (line length 100). |
| **Static Analysis** | `flutter analyze --no-fatal-infos` | Run static analysis. Zero errors and zero warnings required. |
| **Apply Auto-Fixes** | `dart fix --apply` | Automatically fixes mechanical lint issues. |
| **Scaffold Feature** | `./scripts/create_feature.sh <name>` | Generates Clean Architecture folder layout for new feature. |
| **Android Build** | `flutter build apk --debug` | Validates Android toolchain compilation. |

---

## 3. Architecture & Directory Boundaries

```
lib/
├── app/                  # Application lifecycle, routing, startup state machine, bootstrap
│   ├── router/           # GoRouter configuration, AppRoute enum, route guards
│   ├── startup/          # StartupStateMachine, AppLifecycleNotifier, AppStartupWidget
│   ├── app.dart          # Root MaterialApp.router widget
│   └── bootstrap.dart    # Error zones, Crashlytics, initialization sequence
├── config/               # Global environment configurations (.env, EnvConfig)
├── core/                 # Shared foundations (strictly feature-agnostic)
│   ├── errors/           # Typed AppException hierarchy, error converter
│   ├── extensions/       # Context, String, DateTime, Num extensions
│   ├── hooks/            # Reusable Flutter hooks
│   ├── network/          # ApiClient, DioProvider, Interceptors
│   ├── result/           # Sealed Result<T> (Success, Failure)
│   ├── session/          # SessionState, SessionService
│   ├── storage/          # SecureStorage, SharedPreferencesProvider
│   ├── theme/            # AppTheme, AppColors, AppTypography
│   ├── utils/            # AppLogger, Connectivity, Pagination
│   └── widgets/          # Shared atomic widgets, buttons, animations, dialogs
├── features/             # Business domain features (feature-first)
│   └── <feature_name>/
│       ├── data/         # Repositories (Remote/Mock), data sources, DTOs
│       ├── domain/       # Entities, repository interfaces, domain value objects
│       └── presentation/ # UI Pages, widgets, Riverpod notifiers/providers
└── l10n/                 # Localization ARB files and generated delegates
```

### Architectural Rules & Invariants

1. **Dependency Inversion:**
   - Presentation depends on Domain (`entities`, `repositories` contracts).
   - Data implements Domain contracts (`implements SomeRepository`).
   - Domain has **zero** dependencies on Presentation or Data.
   - Core has **zero** dependencies on Features. No file in `lib/core/` may import from `lib/features/`.
2. **Feature Isolation:**
   - Features should communicate through domain entities or public services, never by directly reaching into another feature's internal `data/` or `presentation/widgets/`.
3. **No Dead Barrel Files:**
   - When creating a barrel export (`feature.dart` or `data.dart`), ensure it uses `library;` and exports valid declarations. Never leave bare doc comments without code or `library;` directive.

---

## 4. Riverpod State Management Rules

1. **Always Use Annotations & Code Generation:**
   - Define all providers with `@riverpod` or `@Riverpod(keepAlive: true)`.
   - Never use legacy `StateProvider`, `StateNotifierProvider`, or raw `ChangeNotifier`.
   - Always include `part '<filename>.g.dart';` in files with Riverpod annotations.
2. **Class-based Notifiers vs Functional Providers:**
   - Use functional `@riverpod` for read-only or derived computation:
     ```dart
     @riverpod
     ApiClient apiClient(Ref ref) => ApiClient(ref.watch(dioProvider));
     ```
   - Use class-based `_$NotifierName` for stateful or mutating business logic:
     ```dart
     @riverpod
     class CounterNotifier extends _$CounterNotifier {
       @override
       int build() => 0;
       void increment() => state++;
     }
     ```
3. **Async State Handling:**
   - Async operations MUST return `AsyncValue<T>` (e.g. extending `_$MyAsyncNotifier` with `Future<T> build()`).
   - In UI, render `AsyncValue` using `AsyncValueWidget` or pattern matching (`asyncVal.when(...)`).
4. **Ref Usage Rules:**
   - In `build()` methods: use `ref.watch(myProvider)` to subscribe reactively.
   - In event callbacks (`onPressed`, `onTap`): use `ref.read(myProvider.notifier)` to call methods.
   - For side effects (navigation, snackbars, dialogs): use `ref.listen(myProvider, (prev, next) { ... })`.
   - Do NOT store `Ref` in long-lived state objects or domain entities.
5. **Session & Auth Disambiguation:**
   - Reactive auth check: `ref.watch(sessionStateProvider)` or `ref.watch(isAuthenticatedProvider)`.
   - Direct user access: `ref.watch(currentAuthUserProvider)`.
   - Session mutations: `ref.read(sessionServiceProvider).endSession()`.

---

## 5. Navigation & GoRouter Standards

1. **Declarative Routes:**
   - Every route MUST be declared in the `AppRoute` enum (`lib/app/router/app_route.dart`).
   - Never hardcode string paths like `context.go('/home')`. Always use `AppRoute.home.go(context)` or `context.go(AppRoute.home.path)`.
2. **Centralized Redirect Guards:**
   - All navigation routing guards live inside `lib/app/router/app_router.dart`:
     - `_guardLoading`: Holds navigation on splash during session initialization.
     - `_guardInitialization`: Redirects uninitialized state to splash.
     - `_guardMaintenance`: Redirects to `/maintenance` if maintenance flag is active.
     - `_guardForceUpdate`: Redirects to `/force-update` if client version is deprecated.
     - `_guardAuth`: Redirects unauthenticated access to `/login`, and prevents authenticated users from viewing `/login`.
3. **Diagnostics:**
   - Router diagnostics are gated on `kDebugMode`: `debugLogDiagnostics: kDebugMode`.

---

## 6. Coding Standards (Modern Dart 3.13+)

1. **Parameter Conventions:**
   - **DO NOT** use `final` on formal method or function parameters (`avoid_final_parameters: true`).
   - Correct: `void handleUser(User user, String query)`
   - Incorrect: `void handleUser(final User user, final String query)`
2. **Pattern Matching & Switch Expressions:**
   - Prefer switch expressions over multiple `if-else` or ternary trees:
     ```dart
     final message = switch (result) {
       Success(:final data) => 'Loaded ${data.length} items',
       Failure(:final exception) => 'Failed: ${exception.message}',
     };
     ```
3. **Functional Result Pattern:**
   - Repositories must return `Result<T>` (`Success<T>` or `Failure<T>`).
   - Never throw raw exceptions out of repositories into presentation layers.
4. **Exception Handling:**
   - Never use bare catch clauses: `catch (e)`. Always use typed catch: `on Exception catch (e)`.
   - Log uncaught errors via `AppLogger.instance.e(...)`.
5. **Flutter Hooks with Riverpod:**
   - When using text controllers, animation controllers, or tab controllers, extend `HookConsumerWidget`.
   - Instantiate controllers with `useTextEditingController()`, `useFocusNode()`, `useMemoized()`.
   - Do not manually dispose hook controllers.

---

## 7. Android & Platform Quirks

1. **Gradle 9 & AGP 9:**
   - AGP `9.0.1`, Gradle `9.1.0`, Kotlin `2.3.20`.
   - `android.builtInKotlin=false` is required in `android/gradle.properties` until third-party plugins (`firebase_*`, `cronet_http`) migrate from legacy KGP. Do not remove this flag.
   - `kotlin.incremental=false` in `android/gradle.properties` prevents Windows cross-drive path cache exceptions.
   - `android.uniquePackageNames=false` resolves Android manifest merger namespace collisions in older plugin subprojects.

---

## 8. Checklist for AI Agent Modifications

Before completing any task, ensure:
- [ ] No `final` on parameters.
- [ ] Code generation executed if `@riverpod` or `@freezed` models changed (`dart run build_runner build`).
- [ ] Code formatted (`dart format lib test`).
- [ ] No warnings or errors in static analysis (`flutter analyze --no-fatal-infos`).
- [ ] All tests pass (`flutter test`).
- [ ] No files committed to git that match `.gitignore` (build folders, .gradle, etc.).

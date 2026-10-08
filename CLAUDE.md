# Claude Coding Guide

This file provides quick context and instructions for Claude / Claude Code when working on this repository.

See [AGENTS.md](AGENTS.md) for the authoritative architecture specification.

---

## Quick Reference Commands

- **Code generation:** `dart run build_runner build` (Do NOT pass `--delete-conflicting-outputs`)
- **Watch generation:** `dart run build_runner watch`
- **Run tests:** `flutter test`
- **Run single test:** `flutter test test/path_to_test.dart`
- **Format code:** `dart format lib test`
- **Analyze code:** `flutter analyze --no-fatal-infos`
- **Apply fixes:** `dart fix --apply`
- **Generate localization:** `flutter gen-l10n`
- **Scaffold new feature:** `./scripts/create_feature.sh <feature_name>`

---

## Architectural Guidelines

1. **Clean Architecture:**
   - `lib/core/`: Shared, feature-agnostic utilities, network, storage, theme, and widgets. Core never imports from features.
   - `lib/features/<name>/`: Feature domain, data, presentation.
   - `domain`: Entities, contracts. Zero external Flutter/Data dependencies.
   - `data`: Concrete repositories (`AuthRepositoryRemote`, `AuthRepositoryMock`), data sources, API models.
   - `presentation`: UI pages, widgets, and Riverpod notifiers.
2. **State Management:**
   - Riverpod 2.6+ with code generation (`@riverpod`, `part '<file>.g.dart';`).
   - Class-based notifiers: `class MyNotifier extends _$MyNotifier`.
   - UI hooks: Extend `HookConsumerWidget` when using `useTextEditingController` or hooks with `ref`.
3. **Routing:**
   - GoRouter with `AppRoute` enum. Never hardcode path strings in UI.
   - Centralized redirect guards in `lib/app/router/app_router.dart`.
4. **Style & Linting:**
   - Dart 3.13+ syntax: `avoid_final_parameters: true` (omit `final` on parameters).
   - Use switch expressions and pattern matching for sealed classes (`Result<T>`, `StartupState`, `SessionState`).
   - Repositories return `Result<T>` (`Success` or `Failure`).
   - Specify exception type in catch blocks: `on Exception catch (e)`.

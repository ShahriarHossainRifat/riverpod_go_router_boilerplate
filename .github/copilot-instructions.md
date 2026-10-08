# GitHub Copilot Instructions

You are assisting with development on an enterprise Flutter boilerplate with Riverpod 2.6+, GoRouter 14+, and Clean Architecture.

## Key Rules & Conventions

1. **Dart 3.13+ Parameters:**
   - Do NOT mark parameters as `final`. The project enforces `avoid_final_parameters: true`.
   - Write `Widget build(BuildContext context, WidgetRef ref)` instead of `final BuildContext context`.

2. **Riverpod Code Generation:**
   - Always use `@riverpod` annotations and `part '<filename>.g.dart';`.
   - For stateful classes, inherit from generated `_$<ClassName>`.
   - Use `AsyncValue<T>` for async operations and render with `AsyncValueWidget`.
   - Read providers inside UI using `ref.watch(provider)`.
   - Read providers inside callbacks using `ref.read(provider.notifier)`.

3. **Navigation:**
   - Use `AppRoute` enum from `lib/app/router/app_route.dart`.
   - Never use string literals like `context.go('/settings')`; use `AppRoute.settings.go(context)`.

4. **Error Handling:**
   - Repositories return `Result<T>` (`Success(data)` or `Failure(exception)`).
   - Catch exceptions using typed catches: `on Exception catch (e)`.

5. **Flutter Hooks:**
   - For widgets using `TextEditingController` or hooks, use `HookConsumerWidget`.

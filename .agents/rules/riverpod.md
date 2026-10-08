# Riverpod State Management Standards

## Riverpod 2.6+ with Code Generation

All providers and notifiers must use Riverpod code generation annotations.

### Provider Declaration Rules

1. **Read-only / Computed Providers:**
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part 'user_provider.g.dart';

   @riverpod
   User? currentAuthUser(Ref ref) {
     return ref.watch(authProvider).value;
   }
   ```

2. **Stateful Synchronous Notifiers:**
   ```dart
   @riverpod
   class CounterNotifier extends _$CounterNotifier {
     @override
     int build() => 0;

     void increment() => state++;
     void decrement() => state--;
   }
   ```

3. **Asynchronous Notifiers:**
   ```dart
   @riverpod
   class ProfileNotifier extends _$ProfileNotifier {
     @override
     Future<Profile> build() async {
       final repository = ref.watch(profileRepositoryProvider);
       final result = await repository.fetchProfile();
       return switch (result) {
         Success(:final data) => data,
         Failure(:final exception) => throw exception,
       };
     }

     Future<void> updateBio(String bio) async {
       state = const AsyncValue.loading();
       final repository = ref.read(profileRepositoryProvider);
       final result = await repository.updateBio(bio);
       state = switch (result) {
         Success(:final data) => AsyncValue.data(data),
         Failure(:final exception) => AsyncValue.error(exception, StackTrace.current),
       };
     }
   }
   ```

### UI Consumption

1. **`ConsumerWidget`:** Use for general stateless widgets needing `WidgetRef`.
2. **`HookConsumerWidget`:** Use when combining Flutter Hooks (`useTextEditingController`, `useState`) with `WidgetRef`.
3. **Reading Providers:**
   - `ref.watch(provider)`: Inside `build()` to trigger rebuild on change.
   - `ref.read(provider.notifier)`: Inside button handlers or callbacks to invoke methods.
   - `ref.listen(provider, (prev, next) { ... })`: Inside `build()` to trigger side-effects like SnackBars or navigation without rebuilding.

### Session & Logout Cleanup

When logging out, do not reset providers manually inside UI. Instead, register cleanup callbacks with `SessionService`:
```dart
sessionService.addLogoutCallback((ref) {
  ref.invalidate(userSpecificProvider);
});
```
Calling `sessionService.endSession()` automatically invokes all registered cleanup callbacks before terminating authentication.

# 📘 Developer Guide

**Welcome to the codebase!** 👋

This guide documents **every reusable component** in the boilerplate. Use these utilities to maintain consistency, reduce code, and build professional apps faster.

---

## 🚀 Quick Start for New Developers

### 1. Setup the Project

```bash
# Clone and setup
git clone https://github.com/ShahriarHossainRifat/riverpod_go_router_boilerplate.git my_app
cd my_app
rm -rf .git && git init

# Rename to your project
make rename NAME=myapp ORG=com.yourcompany DISPLAY="Your App Name"

# Install dependencies and generate code
make prepare

# Run the app
flutter run
```

### 2. Understand the Core Concepts

Before diving in, familiarize yourself with:

| Concept                | What It Is                            | Where to Learn                                                   |
| :--------------------- | :------------------------------------ | :--------------------------------------------------------------- |
| **Riverpod**           | State management with code generation | [riverpod.dev](https://riverpod.dev)                             |
| **GoRouter**           | Declarative navigation                | [pub.dev/packages/go_router](https://pub.dev/packages/go_router) |
| **Result Pattern**     | Error handling without exceptions     | See `lib/core/result/`                                           |
| **Clean Architecture** | Separation of concerns                | See [Architecture](#-architecture) section                       |

### 3. Key Rules to Follow

| ❌ Don't                          | ✅ Do                                                           |
| :-------------------------------- | :-------------------------------------------------------------- |
| Use magic numbers (`16`, `300ms`) | Use constants (`AppSpacing.md`, `AppConstants.animationNormal`) |
| Track analytics in `build()`      | Use `useOnMount()` or `initState()`                             |
| Create custom loading widgets     | Use `LoadingWidget`, `AsyncValueWidget`                         |
| Use `SizedBox` for spacing        | Use `VerticalSpace.md()`, `HorizontalSpace.sm()`                |
| Hardcode strings                  | Use localization (`AppLocalizations.of(context).key`)           |
| Use `StatefulWidget` for logic    | Use Riverpod Notifiers                                          |

### 4. Daily Commands

```bash
make gen       # Run code generation after modifying providers/models
make format    # Format code before committing
make lint      # Check for issues
make test      # Run tests
```

### 5. Developing with AI Assistants & Coding Agents

This repository includes specialized instructions for AI coding agents (Antigravity, Gemini, Claude, Cursor, GitHub Copilot):
- **[`AGENTS.md`](AGENTS.md)**: Architectural invariants, provider rules, GoRouter guards, and commands.
- **[`.agents/rules/`](.agents/rules/)**: Deep dive rules for Clean Architecture, Riverpod 2.6+, GoRouter, modern Dart 3.13+, and testing.
- **[`CLAUDE.md`](CLAUDE.md)** and **[`.github/copilot-instructions.md`](.github/copilot-instructions.md)**: Tool-specific agent configurations.

---

## Table of Contents

- [🏗️ Architecture](#-architecture)
- [📦 Constants](#-constants)
- [🧩 Widgets](#-widgets)
- [🔧 Utilities](#-utilities)
- [🎨 Extensions](#-extensions)
- [🪝 Hooks](#-hooks)
- [📋 Forms](#-forms)
- [🌐 Services](#-services)
- [👷 Workflow](#-workflow)
- [⚡ State Management](#-state-management)
- [🔐 Security](#-security)
- [🧪 Testing](#-testing)
- [❓ FAQ](#-faq)

---

## 🏗️ Architecture

We follow **Feature-First Clean Architecture**. Every feature has:

```
lib/features/<feature_name>/
├── data/          # Repository implementations, DTOs
├── domain/        # Entities, Repository interfaces
└── presentation/  # Pages, Widgets, Providers (Notifiers)
```

**Dependency Rule**: Domain → pure Dart, Data → implements Domain, Presentation → uses both.

---

## 📦 Constants

**Path**: `lib/core/constants/`

The constants are organized into separate files for better maintainability:

| File                 | Purpose                            |
| :------------------- | :--------------------------------- |
| `app_constants.dart` | Durations, dimensions, validation  |
| `api_endpoints.dart` | All API endpoint paths             |
| `assets.dart`        | Image, icon, animation asset paths |
| `storage_keys.dart`  | Secure storage and prefs keys      |

### `AppConstants`

**File**: `lib/core/constants/app_constants.dart`

| Constant            | Value  | Usage                          |
| :------------------ | :----- | :----------------------------- |
| `animationFast`     | 150ms  | Quick transitions              |
| `animationNormal`   | 300ms  | Standard animations            |
| `animationSlow`     | 500ms  | Emphasized animations          |
| `connectTimeout`    | 30s    | HTTP connection timeout        |
| `receiveTimeout`    | 30s    | HTTP receive timeout           |
| `debounceDelay`     | 500ms  | Input debouncing               |
| `defaultPageSize`   | 20     | Pagination page size           |
| `borderRadiusSM`    | 4.0    | Subtle corners                 |
| `borderRadiusMD`    | 8.0    | Standard corners               |
| `borderRadiusLG`    | 12.0   | Prominent corners              |
| `borderRadiusXL`    | 16.0   | Very rounded corners           |
| `buttonHeight`      | 48.0   | Standard button height         |
| `inputHeight`       | 56.0   | Standard input height          |
| `maxContentWidth`   | 600.0  | Content max-width (responsive) |
| `minPasswordLength` | 8      | Password validation            |
| `emailPattern`      | RegExp | Email validation regex         |

```dart
// ✅ Correct
Duration(milliseconds: AppConstants.animationNormal.inMilliseconds)
BorderRadius.circular(AppConstants.borderRadiusMD)

// ❌ Wrong - Magic numbers
Duration(milliseconds: 300)
BorderRadius.circular(8)
```

### `ApiEndpoints`

**File**: `lib/core/constants/api_endpoints.dart`

Pre-defined API endpoint paths organized by feature:

```dart
// Auth
ApiEndpoints.login            // '/auth/login'
ApiEndpoints.register         // '/auth/register'
ApiEndpoints.logout           // '/auth/logout'
ApiEndpoints.refreshToken     // '/auth/refresh'
ApiEndpoints.forgotPassword   // '/auth/forgot-password'

// User
ApiEndpoints.currentUser      // '/users/me'
ApiEndpoints.updateProfile    // '/users/me'
ApiEndpoints.changePassword   // '/users/me/password'

// Notifications
ApiEndpoints.notifications    // '/notifications'
ApiEndpoints.registerDevice   // '/notifications/device'
```

### `Assets` & `AppIcons`

**File**: `lib/core/constants/assets.dart`

```dart
// Images
Assets.logo                   // 'assets/images/logo.png'
Assets.placeholder            // 'assets/images/placeholder.png'
Assets.emptyState             // 'assets/images/empty_state.png'
Assets.onboarding.page1       // 'assets/images/onboarding_1.png'

// Animations (Lottie)
Assets.loadingAnimation       // 'assets/animations/loading.json'
Assets.successAnimation       // 'assets/animations/success.json'
Assets.errorAnimation         // 'assets/animations/error.json'
Assets.emptyAnimation         // 'assets/animations/empty.json'
Assets.confettiAnimation      // 'assets/animations/confetti.json'

// Icons (SVG)
AppIcons.home                 // 'assets/icons/home.svg'
AppIcons.settings             // 'assets/icons/settings.svg'
AppIcons.google               // 'assets/icons/google.svg'
```

#### Lottie Animation Usage

The boilerplate includes `lottie` package for high-performance vector animations.

```dart
import 'package:lottie/lottie.dart';

// Basic usage
Lottie.asset(Assets.loadingAnimation)

// With size and repeat control
Lottie.asset(
  Assets.successAnimation,
  width: 100,
  height: 100,
  repeat: false,  // Play once
)

// With animation controller
class AnimatedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController();

    return Lottie.asset(
      Assets.confettiAnimation,
      controller: controller,
      onLoaded: (composition) {
        controller
          ..duration = composition.duration
          ..forward();
      },
    );
  }
}

// From network (for dynamic content)
Lottie.network('https://example.com/animation.json')
```

**Find animations**: [LottieFiles.com](https://lottiefiles.com) has thousands of free animations.

### `StorageKeys`

**File**: `lib/core/constants/storage_keys.dart`

Centralized storage keys for secure storage and shared preferences:

| Category          | Keys                                                   |
| :---------------- | :----------------------------------------------------- |
| **Auth**          | `accessToken`, `refreshToken`, `tokenExpiry`, `userId` |
| **Preferences**   | `themeMode`, `locale`, `notificationsEnabled`          |
| **App State**     | `onboardingCompleted`, `launchCount`, `hasRatedApp`    |
| **Cache**         | `cachedUserProfile`, `lastSyncTimestamp`               |
| **Notifications** | `fcmToken`, `badgeCount`, `lastNotificationRead`       |

```dart
await secureStorage.write(key: StorageKeys.accessToken, value: token);
final token = await secureStorage.read(key: StorageKeys.accessToken);
```

### `PrefsKeys`

Non-sensitive shared preferences keys:

```dart
PrefsKeys.lastTabIndex       // UI state
PrefsKeys.recentSearches     // Search history
PrefsKeys.shownTooltips      // Feature discovery
```

---

## 🧩 Widgets

**Path**: `lib/core/widgets/`

The widgets are organized into separate files for better maintainability. The main `inputs.dart`, `animations.dart`, and `dialogs.dart` files act as barrel exports.

### Widget File Structure

| File                        | Contents                                                             |
| :-------------------------- | :------------------------------------------------------------------- |
| `async_value_widget.dart`   | `AsyncValueWidget`, `LoadingWidget`, `AppErrorWidget`, `EmptyWidget` |
| `buttons.dart`              | `AppButton`, `AppIconButton`                                         |
| `spacing.dart`              | `VerticalSpace`, `HorizontalSpace`, `ResponsivePadding`              |
| `text_fields.dart`          | `AppTextField`, `AppSearchField`                                     |
| `chips.dart`                | `AppChip`, `AppChipVariant`                                          |
| `badges.dart`               | `AppBadge`, `AppBadgeSize`, `AppBadgePosition`                       |
| `status_indicators.dart`    | `StatusDot`, `StatusType`                                            |
| `dividers.dart`             | `AppDivider`                                                         |
| `app_dialogs.dart`          | `AppDialogs` (confirm, alert, error, etc.)                           |
| `bottom_sheets.dart`        | `AppBottomSheets`, `BottomSheetAction`                               |
| `entry_animations.dart`     | `FadeIn`, `SlideIn`, `ScaleIn`, `SlideDirection`                     |
| `staggered_list.dart`       | `StaggeredList`                                                      |
| `attention_animations.dart` | `ShakeWidget`, `ShakeController`, `Pulse`                            |
| `app_animations.dart`       | `AppAnimations` (static utilities)                                   |
| `shimmer_loading.dart`      | `ShimmerLoading`, `ShimmerListTile`, etc.                            |

### Async State Widgets

| Widget                | Purpose                                            |
| :-------------------- | :------------------------------------------------- |
| `AsyncValueWidget<T>` | Handles Riverpod `AsyncValue` (loading/error/data) |
| `LoadingWidget`       | Centered spinner with optional message             |
| `AppErrorWidget`      | Error display with retry button                    |
| `EmptyWidget`         | Empty state with icon and action                   |

```dart
AsyncValueWidget<User>(
  value: ref.watch(userProvider),
  data: (user) => Text(user.name),
  // Optional custom loading/error builders
)

LoadingWidget(message: 'Fetching data...')

AppErrorWidget(message: 'Failed to load', onRetry: () => ref.invalidate(provider))

// Or use the factory constructor for exception handling:
AppErrorWidget.fromError(
  error: exception,
  onRetry: () => ref.invalidate(provider),
)

EmptyWidget(
  message: 'No items yet',
  actionLabel: 'Add Item',
  action: () => context.go('/add'),
)
```

### Buttons

| Widget          | Variants                                        |
| :-------------- | :---------------------------------------------- |
| `AppButton`     | `primary`, `secondary`, `text`                  |
| `AppIconButton` | `standard`, `filled`, `outlined`, `filledTonal` |

```dart
AppButton(
  label: 'Submit',
  onPressed: _submit,
  isLoading: isSubmitting,
  variant: AppButtonVariant.primary,
  size: AppButtonSize.medium, // small, medium, large
)

AppIconButton(
  icon: Icons.add,
  onPressed: _add,
  variant: AppIconButtonVariant.filled,
)
```

**Important**: Always use explicit enum values like `AppButtonVariant.primary` instead of `.primary` for better code clarity.

### Spacing

**NEVER use magic numbers for spacing!**

| Class               | Description                                                          |
| :------------------ | :------------------------------------------------------------------- |
| `AppSpacing`        | Constants: `xs(4)`, `sm(8)`, `md(16)`, `lg(24)`, `xl(32)`, `xxl(48)` |
| `HorizontalSpace`   | Horizontal gap widget                                                |
| `VerticalSpace`     | Vertical gap widget                                                  |
| `ResponsivePadding` | Symmetric padding wrapper                                            |
| `ContentContainer`  | Centered max-width container                                         |

```dart
// ✅ Correct
VerticalSpace.md()         // 16px vertical gap
HorizontalSpace.sm()       // 8px horizontal gap
Padding(padding: EdgeInsets.all(AppSpacing.lg))

// ❌ Wrong
SizedBox(height: 16)
Padding(padding: EdgeInsets.all(24))
```

### Other Widgets

| Widget                | Purpose                                          |
| :-------------------- | :----------------------------------------------- |
| `CachedImage`         | Network image with caching & shimmer placeholder |
| `ConnectivityWrapper` | Shows offline banner when disconnected           |
| `ResponsiveBuilder`   | Adaptive layout (mobile/tablet/desktop)          |
| `ShimmerLoading`      | Skeleton loading effect                          |

```dart
CachedImage(imageUrl: user.avatarUrl, height: 100, width: 100)

ConnectivityWrapper(child: MyPage())

ResponsiveBuilder(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

#### Responsive Design Guidelines

**Breakpoints:**
| Screen Type | Width | Usage |
|:------------|:------|:------|
| Mobile | `< 600px` | Single-column, full-width content |
| Tablet | `600-1024px` | 2-column layouts, larger touch targets |
| Desktop | `> 1024px` | Multi-column, dense information |

**Strict Rules:**

1. **Always use `AppSpacing`** for padding/margin (`AppSpacing.sm`, `AppSpacing.md`, `AppSpacing.lg`)
2. **Always use `AppConstants`** for dimensions (`borderRadiusMD`, `iconSizeMD`, `buttonHeight`)
3. **Test on multiple screen sizes** - use `flutter run -d <device>` with different screen sizes
4. **Use responsive context extensions** - `context.isMobile`, `context.isTablet`, `context.isDesktop`

```dart
// ✅ Responsive padding
padding: EdgeInsets.all(
  context.responsive<double>(
    mobile: AppSpacing.sm,
    tablet: AppSpacing.md,
    desktop: AppSpacing.lg,
  ),
)

// ✅ Conditional layout
if (context.isMobile) {
  return SingleColumnLayout();
} else {
  return TwoColumnLayout();
}

// ✅ ResponsiveVisibility
ResponsiveVisibility(
  hiddenOnMobile: true,
  child: SideNavigation(),
)

// ❌ DON'T use magic numbers
padding: EdgeInsets.all(16)  // Use AppSpacing.md instead
```

### Input Widgets

**Files**: `text_fields.dart`, `chips.dart`, `badges.dart`, `status_indicators.dart`, `dividers.dart`

| Widget           | Purpose                                   | File                     |
| :--------------- | :---------------------------------------- | :----------------------- |
| `AppTextField`   | Styled text field with consistent styling | `text_fields.dart`       |
| `AppSearchField` | Search input with clear button            | `text_fields.dart`       |
| `AppChip`        | Filter/input chips                        | `chips.dart`             |
| `AppBadge`       | Count/status badges                       | `badges.dart`            |
| `AppDivider`     | Divider with optional label               | `dividers.dart`          |
| `StatusDot`      | Status indicator (online/offline/busy)    | `status_indicators.dart` |

```dart
AppTextField(
  label: 'Email',
  prefixIcon: Icons.email,
  validator: Validators.email(),
)

AppSearchField(
  controller: searchController,
  onChanged: (query) => ref.read(searchProvider.notifier).search(query),
)

AppChip(
  label: 'Flutter',
  selected: isSelected,
  onSelected: (selected) => toggleFilter('flutter'),
)

AppBadge(
  count: notificationCount,
  child: Icon(Icons.notifications),
)

StatusDot.online()  // Green pulsing dot
StatusDot.busy()    // Red dot
```

### Dialogs & Bottom Sheets

**Files**: `app_dialogs.dart`, `bottom_sheets.dart`

| Helper                 | Purpose                          | File               |
| :--------------------- | :------------------------------- | :----------------- |
| `AppDialogs.confirm()` | Confirmation dialog              | `app_dialogs.dart` |
| `AppDialogs.alert()`   | Simple alert                     | `app_dialogs.dart` |
| `AppDialogs.error()`   | Error dialog with icon           | `app_dialogs.dart` |
| `AppDialogs.success()` | Success dialog with icon         | `app_dialogs.dart` |
| `AppDialogs.input()`   | Input dialog with validation     | `app_dialogs.dart` |
| `AppDialogs.select()`  | Selection dialog                 | `app_dialogs.dart` |
| `AppDialogs.loading()` | Loading dialog (returns dismiss) | `app_dialogs.dart` |

```dart
final confirmed = await AppDialogs.confirm(
  context,
  title: 'Delete Item',
  message: 'This action cannot be undone.',
  isDangerous: true,
);

if (confirmed == true) {
  await deleteItem();
}

// Input dialog
final name = await AppDialogs.input(
  context,
  title: 'Rename',
  initialValue: currentName,
  validator: Validators.required(),
);

// Loading dialog
final dismiss = AppDialogs.loading(context, message: 'Saving...');
await saveData();
dismiss();
```

**Bottom Sheets:**

```dart
AppBottomSheets.confirm(
  context,
  title: 'Sign Out',
  message: 'Are you sure?',
);

AppBottomSheets.actions<String>(
  context,
  title: 'Options',
  actions: [
    BottomSheetAction(value: 'edit', label: 'Edit', icon: Icons.edit),
    BottomSheetAction(value: 'delete', label: 'Delete', icon: Icons.delete, isDestructive: true),
  ],
);
```

### Animation Widgets

**Path**: `lib/core/widgets/`

The boilerplate includes a comprehensive set of animation widgets for creating polished, modern UIs. Animation widgets are organized into separate files:

| File                        | Contents                                         |
| :-------------------------- | :----------------------------------------------- |
| `entry_animations.dart`     | `FadeIn`, `SlideIn`, `ScaleIn`, `SlideDirection` |
| `staggered_list.dart`       | `StaggeredList`                                  |
| `attention_animations.dart` | `ShakeWidget`, `ShakeController`, `Pulse`        |
| `app_animations.dart`       | `AppAnimations` (static utilities)               |
| `bounce.dart`               | `Bounce`                                         |
| `flip_card.dart`            | `FlipCard`, `FlipCardController`                 |
| `expandable_widget.dart`    | `ExpandableWidget`                               |
| `animated_counter.dart`     | `AnimatedCounter`                                |
| `animated_progress.dart`    | `AnimatedProgress`, `AnimatedCircularProgress`   |
| `typewriter_text.dart`      | `TypewriterText`                                 |
| `shimmer_loading.dart`      | `ShimmerLoading`, `ShimmerListTile`, etc.        |

#### Entry Animations

| Widget          | Purpose                        | File                    |
| :-------------- | :----------------------------- | :---------------------- |
| `FadeIn`        | Fade in on mount               | `entry_animations.dart` |
| `SlideIn`       | Slide in from direction        | `entry_animations.dart` |
| `ScaleIn`       | Scale in on mount              | `entry_animations.dart` |
| `StaggeredList` | Staggered list item animations | `staggered_list.dart`   |

```dart
// Automatic fade-in animation
FadeIn(
  duration: AppConstants.animationNormal,
  delay: AppConstants.staggerDelay * 2,
  child: Text('Hello'),
)

// Slide from bottom
SlideIn(
  direction: SlideDirection.fromBottom,
  child: Card(...),
)

// ✨ NEW: Staggered factories for lists (cleaner than manual delay calculation)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => FadeIn.staggered(
    index: index,
    child: ListTile(title: Text(items[index].name)),
  ),
)

// Or with SlideIn
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => SlideIn.staggered(
    index: index,
    direction: SlideDirection.fromLeft,
    child: ItemCard(item: items[index]),
  ),
)

// Staggered list for beautiful list animations
StaggeredList(
  staggerDelay: AppConstants.staggerDelay,
  children: items.map((item) => ItemCard(item)).toList(),
)
```

#### Attention & Feedback Animations

| Widget        | Purpose                   | File                        |
| :------------ | :------------------------ | :-------------------------- |
| `ShakeWidget` | Shake effect (for errors) | `attention_animations.dart` |
| `Pulse`       | Pulsing animation         | `attention_animations.dart` |
| `Bounce`      | Bounce attention effect   | `bounce.dart`               |

```dart
// Shake on error
final shakeController = ShakeController();
ShakeWidget(
  controller: shakeController,
  child: TextField(...),
)
// Trigger: shakeController.shake();

// Bouncing attention animation
Bounce(
  repeat: true,
  child: Icon(Icons.notification_important),
)

// Pulsing effect
Pulse(
  duration: const Duration(seconds: 1),
  child: Badge(label: Text('New')),
)
```

#### Interactive Animations

| Widget             | Purpose                | File                     |
| :----------------- | :--------------------- | :----------------------- |
| `FlipCard`         | 3D flip between faces  | `flip_card.dart`         |
| `ExpandableWidget` | Smooth expand/collapse | `expandable_widget.dart` |

```dart
// Flip card with controller
final flipController = FlipCardController();
FlipCard(
  controller: flipController,
  front: CardFront(),
  back: CardBack(),
  direction: FlipDirection.horizontal,
)
// Trigger: flipController.flip();

// Expandable section (FAQ, details)
ExpandableWidget(
  header: Text('Click to expand'),
  child: Text('Expanded content here...'),
  expandIcon: Icons.expand_more,
)
```

#### Data Display Animations

| Widget                     | Purpose                    | File                     |
| :------------------------- | :------------------------- | :----------------------- |
| `AnimatedCounter`          | Animated number changes    | `animated_counter.dart`  |
| `AnimatedProgress`         | Animated progress bar      | `animated_progress.dart` |
| `AnimatedCircularProgress` | Animated circular progress | `animated_progress.dart` |
| `TypewriterText`           | Typing effect text         | `typewriter_text.dart`   |

```dart
// Animated counter for stats/scores
AnimatedCounter(
  value: 1234,
  duration: AppConstants.counterAnimation,
  prefix: '\$',
  separator: ',',
  style: Theme.of(context).textTheme.headlineLarge,
)

// Animated progress bar
AnimatedProgress(
  value: 0.75,
  height: 8,
  color: Theme.of(context).colorScheme.primary,
)

// Circular progress
AnimatedCircularProgress(
  value: 0.65,
  size: 64,
  child: Text('65%'),
)

// Typewriter text effect
TypewriterText(
  text: 'Welcome to the app!',
  style: Theme.of(context).textTheme.headlineMedium,
  onComplete: () => print('Done typing'),
)
```

#### Skeleton Loading

| Widget            | Purpose                | File                   |
| :---------------- | :--------------------- | :--------------------- |
| `ShimmerLoading`  | Shimmer effect wrapper | `shimmer_loading.dart` |
| `ShimmerLine`     | Text line placeholder  | `shimmer_loading.dart` |
| `ShimmerCircle`   | Avatar placeholder     | `shimmer_loading.dart` |
| `ShimmerBox`      | Rectangle placeholder  | `shimmer_loading.dart` |
| `ShimmerListTile` | List tile skeleton     | `shimmer_loading.dart` |
| `ShimmerCard`     | Card skeleton          | `shimmer_loading.dart` |
| `ShimmerList`     | List of shimmer tiles  | `shimmer_loading.dart` |

```dart
// Shimmer wrapper for custom content
ShimmerLoading(
  child: Container(width: 100, height: 100, color: Colors.white),
)

// Basic shimmer shapes
ShimmerLine(width: 200, height: 16)
ShimmerCircle(size: 48)
ShimmerBox(width: 100, height: 100)

// Pre-built shimmer components
ShimmerListTile(
  hasLeading: true,
  lines: 2,
)

ShimmerCard(
  imageHeight: 120,
)

// Multiple shimmer list items
ShimmerList(
  itemCount: 5,
  hasLeading: true,
)
```

#### Animation Constants

Use these constants for consistent animation timing:

| Constant               | Value  | Use Case                 |
| :--------------------- | :----- | :----------------------- |
| `animationFast`        | 150ms  | Quick micro-interactions |
| `animationNormal`      | 300ms  | Standard animations      |
| `animationSlow`        | 500ms  | Emphasized animations    |
| `staggerDelay`         | 50ms   | List item delays         |
| `typewriterCharDelay`  | 50ms   | Typewriter effect        |
| `counterAnimation`     | 800ms  | Counter animations       |
| `flipAnimation`        | 400ms  | Card flip                |
| `bounceAnimation`      | 600ms  | Bounce effects           |
| `expandAnimation`      | 250ms  | Expand/collapse          |
| `shakeAnimation`       | 500ms  | Shake effects            |
| `pulseAnimation`       | 1000ms | Pulsing effects          |
| `cursorBlinkAnimation` | 500ms  | Cursor blink             |

**Best Practices:**

- Always use `AppConstants.staggerDelay * N` for delay calculations
- Use `.staggered()` factory constructors for cleaner list animations
- All animation widgets use constants as defaults—no magic numbers needed

---

## 🔧 Utilities

**Path**: `lib/core/utils/`

### Validators

Composable form validators:

```dart
// Single validator
TextFormField(validator: Validators.required())

// Composed validators (first error wins)
TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email('Invalid email format'),
  ]),
)
```

| Validator          | Purpose                                      |
| :----------------- | :------------------------------------------- |
| `required()`       | Non-empty check                              |
| `email()`          | Email format                                 |
| `minLength(n)`     | Minimum characters                           |
| `maxLength(n)`     | Maximum characters                           |
| `exactLength(n)`   | Exact characters                             |
| `pattern(regex)`   | Custom regex                                 |
| `numeric()`        | Digits only                                  |
| `phone()`          | Phone format                                 |
| `url()`            | URL format (requires http/https scheme)      |
| `match(getter)`    | Match another field (e.g., confirm password) |
| `strongPassword()` | 8+ chars, upper, lower, digit, special       |

**Important Notes:**

- `strongPassword()` already includes minimum 8 character requirement. Don't add redundant `minLength(8)` validators.
- `url()` validates that the URL has a scheme (http/https) and authority component.

### Logger

```dart
final logger = ref.read(loggerProvider);
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', error: exception, stackTrace: stack);
```

### Pagination

```dart
final pagination = PaginationController<Product>(
  fetcher: (page, limit) => repo.getProducts(page, limit),
);
```

---

## 🎨 Extensions

**Path**: `lib/core/extensions/`

### BuildContext Extensions

```dart
// Theme
context.theme           // ThemeData
context.colorScheme     // ColorScheme
context.textTheme       // TextTheme
context.isDarkMode      // bool

// Screen
context.screenWidth     // double
context.screenHeight    // double
context.isMobile        // < 600
context.isTablet        // 600-1024
context.isDesktop       // >= 1024

// Responsive helper
context.responsive<Widget>(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)

// Navigation
context.pop()
context.canPop

// Focus
context.unfocus()       // Dismiss keyboard

// Snackbar
context.showSnackBar('Message')
context.showErrorSnackBar('Error!')
context.showSuccessSnackBar('Success!')

// Auth-Aware Navigation (requires WidgetRef)
// Push to authenticated route OR redirect to login
context.pushRouteIfAuthenticatedElse(
  widgetRef: ref,
  authenticatedRoute: AppRoute.settings,
  unauthenticatedRoute: AppRoute.login,
)

// Go (replace) based on auth status
context.goRouteIfAuthenticatedElse(
  widgetRef: ref,
  authenticatedRoute: AppRoute.home,
  unauthenticatedRoute: AppRoute.login,
)

// Execute action if authenticated, else redirect
context.executeIfAuthenticatedElse(
  widgetRef: ref,
  action: () => sendNotification(),
  unauthenticatedRoute: AppRoute.login,
)
```

### String Extensions

```dart
'hello'.capitalized         // 'Hello'
'hello world'.titleCase     // 'Hello World'
'test@email.com'.isValidEmail // true
'  '.isBlank                // true
'hello world'.truncate(8)   // 'hello...'
'Hello World'.toSlug        // 'hello-world'
```

### DateTime Extensions

```dart
DateTime.now().formatMedium    // 'Jan 1, 2024'
DateTime.now().formatShort     // '1/1/2024'
DateTime.now().formatTime      // '10:30 AM'
DateTime.now().formatDateTime  // 'Jan 1, 2024 10:30 AM'
DateTime.now().isToday         // true
DateTime.now().timeAgo         // '2 hours ago'
```

### Nullable Extensions

```dart
String? name;
name.isNullOrEmpty     // true
name.orEmpty           // ''
name.orDefault('N/A')  // 'N/A'
```

### Number Extensions

**File**: `lib/core/extensions/num_extensions.dart`

```dart
// Formatting
1234567.formatted              // '1,234,567'
1234567.89.compactFormatted    // '1.2M'
0.1234.toPercentage()          // '12.34%'
99.99.toCurrency()             // '$99.99'
99.99.toCurrency('€')          // '€99.99'

// File sizes
1024.toFileSize()              // '1.0 KB'
1048576.toFileSize()           // '1.0 MB'

// Time formatting
125.toMinutesSeconds()         // '02:05'
3665.toHoursMinutesSeconds()   // '01:01:05'

// Clamping
150.clampPercentage            // 100.0
(-5).clampPercentage           // 0.0

// Duration shortcuts (works with int and double)
5.seconds                      // Duration(seconds: 5)
500.ms                         // Duration(milliseconds: 500)
2.5.minutes                    // Duration(seconds: 150)

// Spacing shortcuts
16.h                           // SizedBox(height: 16)
8.w                            // SizedBox(width: 8)
```

### Iterable Extensions

**File**: `lib/core/extensions/iterable_extensions.dart`

```dart
// Safe access
[1, 2, 3].firstOrNull          // 1
[].firstOrNull                 // null
[1, 2, 3].lastOrNull           // 3

// Grouping & Chunking
users.groupBy((u) => u.role)   // Map<Role, List<User>>
[1, 2, 3, 4, 5].chunk(2)       // [[1, 2], [3, 4], [5]]

// Filtering
[1, 2, 2, 3, 3].distinct()     // [1, 2, 3]
users.distinctBy((u) => u.id)  // Unique by ID

// Finding
users.maxBy((u) => u.score)    // User with highest score
users.minBy((u) => u.age)      // User with lowest age

// Transformations
users.associate((u) => MapEntry(u.id, u))  // Map<int, User>
users.sortedBy((u) => u.name)              // Sorted copy
users.sortedByDescending((u) => u.score)   // Descending sort

// Conditional
items.takeWhileInclusive((i) => i < 5)  // Includes boundary element
```

### Duration Extensions

**File**: `lib/core/extensions/duration_extensions.dart`

```dart
// Formatting
Duration(seconds: 125).formatHHMMSS    // '00:02:05'
Duration(seconds: 3665).formatHHMMSS   // '01:01:05'
Duration(minutes: 5).formatCompact     // '5m'
Duration(hours: 2, minutes: 30).formatCompact  // '2h 30m'

// Time from now/ago
Duration(hours: 2).fromNow             // DateTime 2 hours from now
Duration(days: 1).ago                  // DateTime 1 day ago

// Comparison
Duration(seconds: 30).isLongerThan(Duration(seconds: 20))  // true
Duration(seconds: 10).isShorterThan(Duration(seconds: 20)) // true

// Rounding
Duration(seconds: 125).roundToMinutes  // Duration(minutes: 2)
Duration(minutes: 45).roundToHours     // Duration(hours: 1)
```

---

## 🪝 Hooks

**Path**: `lib/core/hooks/`

Use in `HookWidget` or `HookConsumerWidget` classes only.

| Hook                        | Purpose                            |
| :-------------------------- | :--------------------------------- |
| `useOnMount(callback)`      | **One-time effect on mount**       |
| `useDebounce(value, delay)` | Debounced value                    |
| `useToggle(initial)`        | Boolean toggle state               |
| `usePrevious(value)`        | Previous render's value            |
| `useTextController()`       | TextEditingController with dispose |
| `useFocusNode()`            | FocusNode with auto-dispose        |
| `useScrollController()`     | ScrollController with dispose      |
| `usePageController()`       | PageController with dispose        |

### `useOnMount` - Critical for Analytics

**Always use `useOnMount` for screen tracking and one-time initialization:**

```dart
class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Correct: Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });

    return Scaffold(...);
  }
}

// ❌ WRONG: This fires on EVERY rebuild!
class BadPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This will track screen view every time the widget rebuilds
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'bad_page');
    return Scaffold(...);
  }
}
```

### Other Hooks Usage

```dart
class SearchPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Toggle state
    final (isVisible, toggleVisible) = useToggle(false);

    // Debounced search
    final searchController = useTextController();
    final searchDebounced = useDebounce(searchController.text, 500.ms);

    // Track previous value
    final prevSearch = usePrevious(searchDebounced);

    return Column(
      children: [
        AppSearchField(controller: searchController),
        if (isVisible) SearchResults(query: searchDebounced),
      ],
    );
  }
}
```

### For ConsumerStatefulWidget (Alternative Pattern)

If you can't use hooks, track analytics in `initState`:

```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(...);
  }
}
```

---

## 📋 Forms

**Path**: `lib/core/forms/`

We use `reactive_forms` for complex forms. Pre-built form groups:

```dart
// Auth forms
final loginForm = AuthForms.login();  // email + password
final registerForm = AuthForms.register();  // name + email + password + confirm

// Common forms
final profileForm = CommonForms.profile();  // name + email + phone + bio
```

Custom validators for `reactive_forms`:

```dart
FormControl<String>(validators: [
  CustomValidators.required,
  CustomValidators.email,
  CustomValidators.strongPassword,
])
```

---

## 🌐 Services

### Network (`lib/core/network/`)

| Service            | Purpose                                |
| :----------------- | :------------------------------------- |
| `ApiClient`        | Type-safe HTTP client with `Result<T>` |
| `dioProvider`      | Pre-configured Dio instance            |
| `CacheInterceptor` | ETag-based caching                     |

```dart
final result = await apiClient.get<User>(
  '/users/1',
  fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
);

result.fold(
  onSuccess: (user) => print(user.name),
  onFailure: (error) => print(error.message),
);
```

#### Auth Interceptor

The `AuthInterceptor` handles token injection and automatic refresh:

- Automatically injects `Authorization: Bearer <token>` header
- Handles 401 responses with automatic token refresh
- Uses `Completer` for concurrent request coordination (prevents multiple simultaneous refresh calls)
- Failed requests are automatically retried after successful token refresh

### Storage (`lib/core/storage/`)

| Provider                    | Purpose                     |
| :-------------------------- | :-------------------------- |
| `secureStorageProvider`     | Encrypted key-value storage |
| `sharedPreferencesProvider` | Non-sensitive preferences   |

Storage Keys:

```dart
StorageKeys.accessToken       // 'access_token'
StorageKeys.refreshToken      // 'refresh_token'
StorageKeys.userId            // 'user_id'
StorageKeys.onboardingCompleted // 'onboarding_completed'
```

### Other Services

| Service                    | Purpose                      |
| :------------------------- | :--------------------------- |
| `BiometricService`         | Face ID / Touch ID           |
| `LocalNotificationService` | Local notifications          |
| `PermissionService`        | Runtime permissions          |
| `FeedbackService`          | Context-free snackbars       |
| `DeepLinkService`          | Universal link handling      |
| `InAppReviewService`       | App store reviews            |
| `AppVersionService`        | Version check & force update |
| `LocaleNotifier`           | Locale management            |
| `CrashlyticsService`       | Crash reporting              |
| `AnalyticsService`         | User analytics               |
| `PerformanceService`       | Performance monitoring       |
| `RemoteConfigService`      | Feature flags & config       |

### Firebase Suite (`lib/core/`)

The boilerplate includes a complete Firebase integration:

#### Crashlytics (`lib/core/crashlytics/`)

```dart
// Record non-fatal errors
ref.read(crashlyticsServiceProvider).recordError(
  exception,
  stackTrace,
  reason: 'API call failed',
);

// Log breadcrumbs
ref.read(crashlyticsServiceProvider).log('User tapped checkout');

// Set user identifier
ref.read(crashlyticsServiceProvider).setUserId('user_123');
```

#### Analytics (`lib/core/analytics/`)

**⚠️ IMPORTANT: Screen tracking must be done correctly!**

```dart
// ✅ CORRECT: Use useOnMount in HookConsumerWidget
class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });
    return Scaffold(...);
  }
}

// ✅ CORRECT: Use initState in ConsumerStatefulWidget
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}
class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(...);
}

// ❌ WRONG: Never track in build() - fires on every rebuild!
class BadPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'bad'); // BAD!
    return Scaffold(...);
  }
}
```

**Standard Analytics Events:**

```dart
final analytics = ref.read(analyticsServiceProvider);

// Predefined events
await analytics.logLogin(method: 'email');
await analytics.logSignUp(method: 'google');
await analytics.logSearch(searchTerm: 'shoes');
await analytics.logPurchase(
  transactionId: 'txn_123',
  value: 99.99,
  currency: 'USD',
);

// Custom events (use constants from AnalyticsEvents)
await analytics.logEvent(
  AnalyticsEvents.featureUsed,
  parameters: {'feature': 'dark_mode'},
);

// User properties (use constants from AnalyticsUserProperties)
await analytics.setUserProperty(
  AnalyticsUserProperties.subscriptionTier,
  'premium',
);
```

#### Performance Monitoring (`lib/core/performance/`)

```dart
final performance = ref.read(performanceServiceProvider);

// Trace async operations
final result = await performance.traceAsync(
  'checkout_flow',
  () => processCheckout(),
  attributes: {'payment_method': 'credit_card'},
  metrics: {'items_count': 5},
);

// Manual traces for fine-grained control
final trace = await performance.startTrace('image_upload');
trace?.putAttribute('image_type', 'profile');
// ... perform operation ...
await trace?.stop();

// HTTP metrics are automatic via PerformanceHttpInterceptor
// Screen traces are automatic via PerformanceRouteObserver
```

#### Remote Config (`lib/core/remote_config/`)

```dart
final remoteConfig = ref.read(remoteConfigServiceProvider);

// Feature flags
final isFeatureEnabled = remoteConfig.getBool(RemoteConfigKeys.newFeatureEnabled);
final apiVersion = remoteConfig.getString(RemoteConfigKeys.apiVersion);
final maxRetries = remoteConfig.getInt(RemoteConfigKeys.maxApiRetries);

// Force update check
if (remoteConfig.isForceUpdateRequired) {
  final minVersion = remoteConfig.minAppVersion;
  // Show force update dialog
}

// Maintenance mode
if (remoteConfig.isMaintenanceMode) {
  // Show maintenance screen
}

// Fetch latest config
await remoteConfig.fetchAndActivate();

// Real-time updates
remoteConfig.listenForUpdates((updatedKeys) {
  if (updatedKeys.contains(RemoteConfigKeys.maintenanceMode)) {
    // Handle maintenance mode change
  }
});
```

#### Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Add your Android and iOS apps
3. Download configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
4. Run `flutterfire configure` to generate `firebase_options.dart`
5. Uncomment initialization in `lib/app/bootstrap.dart`

---

## 👷 Workflow

### Creating a New Feature

**Always use the generator!**

```bash
make feature NAME=profile
```

This creates the correct folder structure with placeholder files.

### Implementation Steps

1. **Define Entity** in `domain/entities/`
2. **Define Repository Interface** in `domain/repositories/`
3. **Implement Repository** in `data/repositories/`
4. **Create Provider** in `presentation/providers/`
5. **Build Page** in `presentation/pages/`
6. **Add Route** to `lib/app/router/app_router.dart`

### Build Commands

```bash
make gen       # Run code generation (build_runner + l10n)
make format    # Format code & apply fixes
make lint      # Run static analysis
make test      # Run all tests
make prepare   # Full setup (clean + l10n + gen)
```

### App Icons & Splash Screen

```bash
# Generate app launcher icons (run after updating icon in assets/images/app_logo.png)
dart run flutter_launcher_icons

# Generate native splash screen
dart run flutter_native_splash:create
```

**Icon Configuration** (in `pubspec.yaml`):

```yaml
flutter_launcher_icons:
  image_path: "assets/images/app_logo.png" # 1024x1024 recommended
  android: true
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/app_logo.png"
  ios: true
  remove_alpha_ios: true
```

### Releasing a New Version

Follow these steps when preparing a release:

1. **Update CHANGELOG.md** - Add your changes under `[Unreleased]` or create a new version section
2. **Update version** in `pubspec.yaml` (e.g., `1.0.1+2`)
3. **Run tests** - `make test`
4. **Commit** with message: `chore: release vX.Y.Z`
5. **Push to `main`** - CI will automatically create a GitHub Release

**Changelog Format** (Keep a Changelog):

```markdown
## [1.1.0] - 2026-02-01

### Added

- New feature X

### Changed

- Updated behavior of Y

### Fixed

- Bug in Z
```

---

## ⚡ State Management

Use **Riverpod Generator** for all providers.

### Riverpod 3.0: Offline Persistence with `@JsonPersist()`

**2026 Pattern**: Riverpod 3.0 includes native offline-first support with automatic stale-while-revalidate caching.

#### Basic Offline Persistence Pattern

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_provider.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String task,
    required bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

// ✨ Offline-first provider with automatic JSON persistence
@riverpod
@JsonPersist()  // Auto-handles JSON serialization with Freezed
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    // Set up persistence layer
    persist(
      ref.watch(storageProvider.future),
      // No manual encode/decode needed!
    );

    // Instantly shows cached data, then fetches fresh data
    return fetchTodosFromServer();
  }

  // Mutations automatically persisted to DB
  Future<void> addTodo(String task) async {
    state = AsyncData([...await state.future, Todo(id: uuid(), task: task, completed: false)]);
    // Auto-persisted to local DB

    // Optional: Persist to server
    try {
      await ref.read(apiClientProvider).post('/todos', data: {'task': task});
    } catch (e) {
      // Local data remains - graceful offline handling
    }
  }
}

// Provider for storage instance
@riverpod
Future<JsonSqFliteStorage> storage(Ref ref) async {
  return JsonSqFliteStorage.open(
    join((await getDatabasesPath()), 'app.db'),
  );
}
```

**Key Features**:

- ✅ Instant cached data display (UI never blank)
- ✅ Background network fetch updates UI when data arrives
- ✅ On network error, cached data remains visible
- ✅ Automatic JSON persistence with Freezed models
- ✅ Zero boilerplate encoding/decoding

#### When to Use Offline Persistence

**Use `@JsonPersist()` for:**

- Lists that users browse frequently (todos, products, news)
- Data that rarely changes instantly (user profile, settings)
- Features where temporary offline access is valuable

**Don't use for:**

- Real-time data requiring instant updates (chat messages, live scores)
- Sensitive data (passwords,auth tokens already in secure storage)
- Frequently-changing data with complex sync logic

### Riverpod 3.0: Mutations API for Side-Effects

**2026 Pattern**: Use Mutations for write operations (form submissions, button actions).

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // Check authentication status
    return ref.read(authRepositoryProvider).getCurrentUser();
  }

  // Mutation for login
  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).login(email, password);

    state = result.fold(
      onSuccess: (user) {
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.login);
        return AsyncData(user);
      },
      onFailure: (error) => AsyncError(error, StackTrace.current),
    );
  }

  Future<void> logout() async {
    // Mutation for logout (typically Success(null))
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).logout();

    state = result.fold(
      onSuccess: (_) => AsyncData<User?>(null),  // Return null for logged out state
      onFailure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
```

**In UI - Access mutation state automatically:**

```dart
class LoginForm extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () => Column(
        children: [
          AppTextField(label: 'Email', enabled: false),
          VerticalSpace.md(),
          AppButton(label: 'Logging in...', isLoading: true, onPressed: null),
        ],
      ),
      error: (error, stack) => Column(
        children: [
          AppTextField(label: 'Email'),
          VerticalSpace.md(),
          AppErrorWidget(
            message: error.toString(),
            onRetry: () => ref.read(authProvider.notifier).loginWithEmail(email, password),
          ),
        ],
      ),
      data: (user) => user == null
          ? LoginView(onLogin: (e, p) => ref.read(authProvider.notifier).loginWithEmail(e, p))
          : HomeView(),
    );
  }
}
```

### Standard Riverpod Patterns

```dart
// Read-only / Async data
@riverpod
Future<User> fetchUser(FetchUserRef ref, int id) async {
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getUser(id);
  return result.getOrThrow();
}

// Mutable state
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}

// With parameters (family)
@riverpod
Future<List<Product>> productsByCategory(ProductsByCategoryRef ref, String category) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getByCategory(category);
}

// Family with both required and optional params
@riverpod
Future<List<Post>> postsForUser(PostsForUserRef ref, {
  required String userId,
  String? filter,
  int limit = 20,
}) async {
  final repo = ref.watch(postRepositoryProvider);
  return repo.getPosts(userId: userId, filter: filter, limit: limit);
}
```

### keepAlive Guidelines

Use `@Riverpod(keepAlive: true)` **ONLY** for:

- Global app state (auth, theme, user preferences)
- Expensive services (network clients, database connections)
- State that must survive navigation (audio player, download manager)

**Default to autoDispose** for page-specific providers.

```dart
// ✅ Correct - Global state kept alive
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  void toggle() => state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}

// ✅ Correct - Page-local provider auto-disposes
@riverpod
Future<PageData> pageData(PageDataRef ref) => fetchData();  // Auto-disposed on page exit

// ❌ Wrong - Page-local provider kept alive unnecessarily
@Riverpod(keepAlive: true)
Future<PageData> badPageData(BadPageDataRef ref) => fetchData();  // Leaks memory!
```

### UI Consumption

```dart
class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(fetchUserProvider(1));

    return AsyncValueWidget<User>(
      value: userAsync,
      data: (user) => Text(user.name),
    );
  }
}

// Watch multiple providers
class Dashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final notifications = ref.watch(notificationsProvider);

    return user.when(
      data: (u) => notifications.when(
        data: (n) => Text('${u.name}: ${n.length} notifications'),
        loading: () => LoadingWidget(),
        error: (e, st) => AppErrorWidget(message: e.toString()),
      ),
      loading: () => LoadingWidget(),
      error: (e, st) => AppErrorWidget(message: e.toString()),
    );
  }
}
```

---

## 🧅 Modern Dart Language Features (Dart 3.10+)

**2026 Standard**: Leverage Dart 3.10+ language features for cleaner, safer code.

### Extension Types (Zero-Cost Type Safety)

Create type-safe abstractions with no runtime overhead:

```dart
// Define extension type for user ID
extension type UserId(int _id) {
  bool get isValid => _id > 0;

  static const invalid = UserId(-1);
}

// Define extension type for email
extension type EmailAddress(String _email) {
  bool get isValid => RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(_email);
}

// ✅ Type-safe - compiler prevents wrong types
void updateUser(UserId id, EmailAddress email) {
  print('User $id: $email');
}

updateUser(UserId(123), EmailAddress('user@example.com'));  // ✅ OK
updateUser(123, 'user@example.com');  // ❌ Compile error!
updateUser(EmailAddress('...'), UserId(123));  // ❌ Type mismatch!
```

**When to use Extension Types:**

- ✅ Wrap primitives: IDs, email addresses, phone numbers, URLs, monetary amounts
- ✅ Business logic requiring type safety
- ❌ Not for collections (use typedef for `List<UserId>`)

### Dart 3.10+ Dot Shorthand Syntax

Omit enum type names when context is clear:

```dart
// ✅ Modern - Dot shorthand
AppButton(
  variant: .primary,           // Instead of AppButtonVariant.primary
  size: .medium,               // Instead of AppButtonSize.medium
  alignment: .center,          // Instead of Alignment.center
)

Column(
  mainAxisAlignment: .center,  // Instead of MainAxisAlignment.center
  mainAxisSize: .min,          // Instead of MainAxisSize.min,
  crossAxisAlignment: .end,    // Instead of CrossAxisAlignment.end
)

FloatingActionButton(
  onPressed: () {},
  child: Icon(.add),           // Instead of Icons.add
)

// ✅ Works with any enum or type with named constructors
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    alignment: .topCenter,     // Position-based alignment
    backgroundColor: .primary, // ColorScheme extension
  ),
)
```

**Rule**: Always use dot shorthand with enums when the compiler can infer the type.

### Pattern Matching & Destructuring

Declaratively match and extract data:

```dart
// Record destructuring
final (name, age, email) = getUserData();

// Pattern matching in if statements
User? user = fetchUser();
if (user case User(role: Admin(:final permissions))) {
  // user is Admin with permissions extracted
  handleAdmin(permissions);
}

// Switch expressions with patterns
final message = switch (result) {
  Success(value: final data) => 'Success: $data',
  Failure(error: AuthException(:final message)) => 'Auth error: $message',
  Failure(error: NetworkException()) => 'Network error',
  Failure(error: _) => 'Unknown error',  // Wildcard for remaining cases
};

// Type-casting pattern
if (widget case Text(:final data)) {
  print('Got text: $data');
}

// List pattern matching
const [first, second, ...rest] = items;
print('$first, $second, and ${rest.length} more');

// Guard clauses in patterns (.where becomes unnecessary)
if (numbers case [var a, var b, ...] when a + b > 10) {
  print('Sum exceeds 10');
}
```

**Why it's better:**

- ✅ Cleaner than multiple if-else or switch statements
- ✅ Automatic extraction - no intermediate variables needed
- ✅ Compiler enforces exhaustiveness - won't miss cases

### Wildcard Variables (Dart 3.7+)

Use multiple `_` for unused parameters (they no longer conflict):

```dart
// ✅ Correct - Multiple wildcards allowed
button.onPressed = (_, __, ___) => handleTripleClick();
items.map((_, value) => value.toString());
[1, 2, 3].where((_, index) => index < 2);

// ✅ Named wildcards for clarity when needed
items.map((_unusedKey, value) => value);

// ❌ Old Dart 3.3 pattern - would cause 'duplicate initialization'
// map((_, __, ___) => ...)  // This used to fail!
```

### Switch Expressions

More concise than switch statements when returning values:

```dart
// ❌ Traditional switch statement
String getStatus(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Order pending';
    case OrderStatus.shipped:
      return 'Order shipped';
    case OrderStatus.delivered:
      return 'Order delivered';
    case OrderStatus.cancelled:
      return 'Order cancelled';
  }
}

// ✅ Switch expression
String getStatus(OrderStatus status) => switch (status) {
  OrderStatus.pending => 'Order pending',
  OrderStatus.shipped => 'Order shipped',
  OrderStatus.delivered => 'Order delivered',
  OrderStatus.cancelled => 'Order cancelled',
};

// ✅ With complex logic
String describe(dynamic value) => switch (value) {
  String() => 'String: ${value.length} chars',
  int() when value > 100 => 'Large number',
  int() => 'Small number',
  List() => 'List with ${value.length} items',
  _ => 'Unknown type',
};
```

**Benefits:**

- ✅ Returns value directly
- ✅ Forces exhaustiveness in compiler
- ✅ Easier to refactor
- ✅ Combines well with patterns

---

## 🔐 Security

### Secure Storage

The boilerplate uses `FlutterSecureStorage` for sensitive data like tokens and credentials.

#### iOS Keychain Behavior

**Important**: iOS Keychain data persists across app reinstalls. This can cause issues where stale tokens from a previous install are used after a fresh install.

The `FreshInstallHandler` addresses this:

```dart
// In bootstrap.dart - automatically clears stale keychain data
await FreshInstallHandler.handleFreshInstall(secureStorage, sharedPrefs);
```

How it works:

1. On first launch, stores a marker in SharedPreferences
2. SharedPreferences is cleared on uninstall (unlike Keychain)
3. If marker is missing but Keychain has data → fresh install detected
4. Clears all Keychain data to prevent auth issues

#### Platform-Specific Configuration

**iOS:**

- Keychain accessibility: `first_unlock_this_device`
- Data only accessible after first device unlock

**Android:**

- Uses EncryptedSharedPreferences
- Encrypted at rest

### Network Security

- Auth tokens injected automatically via `AuthInterceptor`
- 401 responses trigger automatic token refresh
- Uses `Completer` coordination to prevent multiple simultaneous refresh calls
- Failed requests retry automatically with exponential backoff

---

## 🧪 Testing Best Practices (2026 Standard: 80%+ Coverage)

| Type                  | When to Write                     | Tools                            |
| :-------------------- | :-------------------------------- | :------------------------------- |
| **Unit Tests**        | Repositories, services, notifiers | `test`, `mocktail`               |
| **Widget Tests**      | UI components, pages              | `flutter_test`, `mocktail`       |
| **Golden Tests**      | Visual regression on key widgets  | `flutter_test` with golden files |
| **Integration Tests** | Critical user flows end-to-end    | `integration_test`               |
| **Provider Tests**    | Riverpod notifiers and state      | `riverpod_test` + `flutter_test` |

### Test Organization

```
test/
├── core/
│   ├── validators_test.dart          # Utility function tests
│   ├── widgets_test.dart             # Core widget visual tests
│   └── network_test.dart             # API client tests
├── features/
│   ├── auth/
│   │   ├── auth_repository_test.dart # Data layer
│   │   ├── auth_notifier_test.dart   # State management
│   │   └── login_page_test.dart      # UI layer
│   └── home/
│       └── home_page_test.dart
├── helpers/
│   ├── mocks.dart                    # Shared mock classes
│   ├── test_data.dart                # Fake data
│   └── pump_helpers.dart             # Test utilities
├── goldens/                          # Golden file comparisons
│   ├── app_button_primary.png
│   └── status_dot_online.png
└── integration_test/
    └── app_flow_test.dart            # End-to-end flows
```

### Unit Tests - Repository & Service Testing

**Pattern**: Arrange-Act-Assert (AAA) with mocks for external dependencies.

```dart
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late MockSecureStorage mockStorage;
    late AuthRepositoryRemote repository;

    setUp(() {
      mockApiClient = MockApiClient();
      mockStorage = MockSecureStorage();
      repository = AuthRepositoryRemote(
        apiClient: mockApiClient,
        secureStorage: mockStorage,
      );
    });

    test('loginWithEmail returns Success with user data', () async {
      // Arrange
      const email = 'user@example.com';
      const password = 'password123';
      final mockResponse = {
        'tokens': {'access': 'abc123', 'refresh': 'xyz789'},
        'user': {'id': '1', 'email': email, 'name': 'John'}
      };

      when(() => mockApiClient.post<Map>(
        ApiEndpoints.login,
        data: any(named: 'data'),
      )).thenAnswer((_) async => mockResponse);

      when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      // Act
      final result = await repository.loginWithEmail(email, password);

      // Assert
      expect(result, isA<Success>());
      expect(result.fold(onSuccess: (data) => data.id, onFailure: (_) => ''), '1');

      verify(() => mockApiClient.post<Map>(
        ApiEndpoints.login,
        data: any(named: 'data'),
      )).called(1);

      verify(() => mockStorage.write(
        key: StorageKeys.accessToken,
        value: 'abc123',
      )).called(1);
    });

    test('loginWithEmail returns Failure on network error', () async {
      // Arrange
      when(() => mockApiClient.post<Map>(
        ApiEndpoints.login,
        data: any(named: 'data'),
      )).thenThrow(Exception('Network timeout'));

      // Act
      final result = await repository.loginWithEmail('user@test.com', 'pwd');

      // Assert
      expect(result, isA<Failure>());
    });

    test('logout clears stored tokens', () async {
      // Arrange
      when(() => mockStorage.delete(key: StorageKeys.accessToken))
          .thenAnswer((_) async {});

      // Act
      await repository.logout();

      // Assert
      verify(() => mockStorage.delete(key: StorageKeys.accessToken)).called(1);
      verify(() => mockStorage.delete(key: StorageKeys.refreshToken)).called(1);
    });
  });
}
```

### Widget Tests - UI Component Testing

Test user interactions, state changes, and UI rendering:

```dart
void main() {
  group('LoginPage', () {
    late ProviderContainer providerContainer;

    setUp(() {
      providerContainer = ProviderContainer(
        overrides: [
          analyticsServiceProvider.overrideWithValue(MockAnalyticsService()),
          authProvider.overrideWithValue(MockAuthNotifier()),
        ],
      );
    });

    testWidgets('displays phone input and login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('shows error snackbar on invalid input', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      // Try to login without entering credentials
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('calls login when form submitted with valid data', (WidgetTester tester) async {
      final mockNotifier = MockAuthNotifier();
      providerContainer = ProviderContainer(
        overrides: [authProvider.overrideWithValue(mockNotifier)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      // Enter email
      await tester.enterText(find.byType(TextField), 'user@example.com');
      await tester.pumpAndSettle();

      // Enter password
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      verify(() => mockNotifier.loginWithEmail('user@example.com', 'password123')).called(1);
    });
  });
}
```

### Golden Tests - Visual Regression Testing

Catch unintended UI changes by comparing against golden files:

```dart
void main() {
  group('Golden Tests - Widgets', () {
    testWidgets('AppButton primary variant matches golden file', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 100);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                label: 'Click Me',
                onPressed: () {},
                variant: .primary,
                size: .medium,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_primary.png'),
      );

      addTearDown(() => tester.binding.resetPhysicalSize());
      addTearDown(() => tester.binding.window.clearPhysicalSizeTestValue());
    });

    testWidgets('StatusDot online matches golden file', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatusDot.online(),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(StatusDot),
        matchesGoldenFile('goldens/status_dot_online.png'),
      );
    });
  });
}
```

**To create/update golden files:**

```bash
# Generate or update golden files
flutter test --update-goldens

# Run golden tests to compare
flutter test
```

### Provider Tests - Riverpod Notifier Testing

Test state management logic:

```dart
void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
      );
    });

    test('loginWithEmail updates state to user data on success', () async {
      // Arrange
      const testUser = User(id: '1', email: 'user@test.com', name: 'John');
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.loginWithEmail(any(), any()))
          .thenAnswer((_) async => Success(testUser));

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      // Act
      await container.read(authProvider.notifier).loginWithEmail('user@test.com', 'pwd');

      // Assert
      final state = container.read(authProvider);
      expect(state.maybeWhen(
        data: (user) => user?.id == testUser.id,
        orElse: () => false,
      ), true);
    });

    test('loginWithEmail sets error state on failure', () async {
      // Arrange
      final mockRepo = MockAuthRepository();
      final testError = AuthException.invalidCredentials();
      when(() => mockRepo.loginWithEmail(any(), any()))
          .thenAnswer((_) async => Failure(testError));

      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Act
      await container.read(authProvider.notifier).loginWithEmail('user@test.com', 'pwd');

      // Assert
      final state = container.read(authProvider);
      expect(state, isA<AsyncError>());
    });
  });
}
```

### Integration Tests - End-to-End User Flows

Test critical user journeys across entire app:

```dart
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow - Integration Tests', () {
    testWidgets('Complete login flow', (IntegrationTestWidgetTester tester) async {
      // Start the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login (might already be there if not authenticated)
      expect(find.text('Email'), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'testuser@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Submit
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify navigation to home screen
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('testuser@example.com'), findsOneWidget);
    });

    testWidgets('Logout clears user data', (IntegrationTestWidgetTester tester) async {
      // Assume app starts in logged-in state
      // (handled by mock auth state or test setup)

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Find and tap logout
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Confirm logout in dialog
      await tester.tap(find.text('Yes, Logout'));
      await tester.pumpAndSettle();

      // Should return to login screen
      expect(find.text('Email'), findsOneWidget);
    });
  });
}
```

**Run integration tests:**

```bash
# On device/emulator
flutter test integration_test/

# On a specific device
flutter test -d <device_id> integration_test/

# Create a test report
flutter test --machine integration_test/ > report.json
```

### Mocking Best Practices

```dart
// In test/helpers/mocks.dart
class MockAuthRepository extends Mock implements AuthRepository {}
class MockApiClient extends Mock implements ApiClient {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

// Create shared fallback values for complex types
void setUpMockFallbacks() {
  registerFallbackValue(const User.empty());
  registerFallbackValue(const Success<void>(null) as Success);  // For Result<void>
  registerFallbackValue(AuthException.unknown());
}

// Usage
void main() {
  setUpAll(() => setUpMockFallbacks());

  group('Tests using mocks', () {
    // Your tests here
  });
}
```

### Quick Guidelines

- ✅ Test both success and failure paths
- ✅ Use descriptive test names: "loginWithEmail_validCredentials_returnsUser"
- ✅ One assertion per test (or one assertion per feature)
- ✅ Mock external dependencies (APIs, storage, services)
- ✅ Use constants for test data
- ✅ Verify mocks were called with `verify()`
- ✅ For `Future<void>` methods, return `.thenAnswer((_) async {})`
- ✅ For methods returning `Result<void>`: use `const Success(null)`
- ✅ Always dispose providers/controllers in `tearDown()`
- ✅ Test animations with `pumpAndSettle()` to wait for completion
- ❌ Never test implementation details, only behavior
- ❌ Never call API endpoints in tests
- ❌ Don't catch all exceptions silently in tests

---

---

## 🎨 Impeller Rendering Engine (2026 Standard)

**Impeller is now the default Flutter rendering engine** - eliminating traditionally problematic shader compilation jank:

### What's Changed

| Aspect                      | Pre-Impeller (Skia)           | Impeller (2026 Standard)           |
| :-------------------------- | :---------------------------- | :--------------------------------- |
| **Shader Compilation**      | Runtime (causes jank)         | Pre-compiled during build          |
| **First Animation Frame**   | Often stutters 500-1000ms     | Smooth from frame 1                |
| **Max FPS on High-Refresh** | Limited by shader compilation | Consistent 120fps on 120Hz screens |
| **Complex Effects**         | Required manual optimization  | Works efficiently as-is            |
| **Debug vs Release**        | Huge difference in smoothness | Consistent smoothness both modes   |

### Practical Impact on Development

```dart
// ✅ Safe to use ANY complex effects now
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      stops: [0.0, 1.0],
    ),
    boxShadow: [
      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10),
      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20),
    ],
    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLG),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Text('Complex effects run smoothly'),
  ),
)

// ✅ Multiple layers of animations
Stack(
  children: [
    FadeIn(child: Container(...)),
    SlideIn(child: Container(...)),
    ScaleIn(child: Container(...)),
  ],
)

// ✅ Staggered list animations without concern
ListView.builder(
  itemBuilder: (context, index) => FadeIn.staggered(
    index: index,
    child: ComplexCard(),  // Even complex widgets
  ),
)
```

### Performance Expectations

**When frame drops occur with Impeller, they're caused by logic issues, NOT rendering:**

1. **Heavy Computation** → Offload to isolate or compute upfront
2. **Excessive Rebuilds** → Use `const` widgets, optimize `watch()` dependencies
3. **Large Lists** → Use `ListView.builder` with `childCount` constraint
4. **Memory Leaks** → Ensure timers/streams are cancelled on unmount
5. **Inefficient Algorithms** → Profile with DevTools Performance view

### Debugging Impeller Issues

**Flutter DevTools Impeller Inspector:**

```bash
# Launch app with debugging
flutter run

# Open DevTools
dart devtools

# Navigate to: DevTools → Performance → (select Impeller)
# Shows:
# - Draw calls per frame
# - Shader compilation time
# - Frame rendering breakdown
```

### When to Avoid Complex Effects

Even with Impeller, avoid:

- ❌ Particle systems (1000+ particles) → Use Lottie animations instead
- ❌ Real-time physics simulations → Precompute or simplify
- ❌ WebGL-style effects → Not supported on Flutter
- ❌ Dynamic shader compilation → Not needed; use pre-built effects

### Best Practices with Impeller

1. **Profile before optimizing** - Don't guess where bottlenecks are
2. **Use const constructors** - Reduces rebuild unnecessary work
3. **Watch Riverpod dependencies carefully** - Over-watching causes rebuilds
4. **Use `RepaintBoundary`** for isolated update areas (rarely needed now)
5. **Lazy-load heavy widgets** - Still good practice even with Impeller

---

## 🎨 Figma Integration & Design Asset Management

**Path**: Link between Figma designs and Flutter implementation using MCP tools.

### Overview

This boilerplate includes integration with Figma through Model Context Protocol (MCP) tools for seamless design-to-code workflows:

| Tool                                      | Purpose                                   |
| :---------------------------------------- | :---------------------------------------- |
| `mcp_figma_context_get_figma_data`        | Fetch design data, layout, components     |
| `mcp_figma_context_download_figma_images` | Export PNG/SVG assets from specific nodes |

### Workflow: Design to Implementation

#### Step 1: Extract Figma File Data

Before exporting assets, inspect the design structure:

```
Figma File URL: figma.com/file/abc123def456/My%20Design
                          ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
File Key: abc123def456

Node URL: figma.com/file/abc123def456/...?node-id=1234:5678
                                                  ↑↑↑↑↑↑↑↑↑↑↑↑
Node IDs: 1234:5678 (fetch design metadata)
```

Use `get_figma_data` to:

- ✅ Inspect component hierarchy
- ✅ Extract design tokens (colors, spacing, typography)
- ✅ Identify which nodes to export
- ✅ Validate dimensions before implementation

**Response includes**: Layout, colors, typography, component names, asset references.

#### Step 2: Download Required Assets

Once you identify assets to export, use `download_figma_images`:

**Asset Export Pattern:**

```
- Figma Node IDs → PNG/SVG files downloaded to project
- File paths organized by feature: assets/images/feature_name/
- All exported assets added to Assets constants class
- Icons exported as SVG (scalable)
- Photos/illustrations exported as PNG @2x or @3x
```

**Organization by Feature:**

```
assets/
├── images/
│   ├── onboarding/
│   │   ├── onboarding_1.png        # Feature hero
│   │   └── onboarding_2.png
│   ├── auth/
│   │   ├── login_hero.png          # Login screen background
│   │   └── signup_illustration.png
│   └── home/
│       └── profile_placeholder.png
├── icons/
│   ├── navigation/
│   │   ├── home.svg
│   │   ├── search.svg
│   │   └── settings.svg
│   └── actions/
│       ├── add.svg
│       ├── edit.svg
│       └── delete.svg
```

#### Step 3: Add to Constants

All exported assets must be defined in `lib/core/constants/assets.dart`:

```dart
class Assets {
  // Onboarding
  static const onboarding1 = 'assets/images/onboarding/onboarding_1.png';
  static const onboarding2 = 'assets/images/onboarding/onboarding_2.png';

  // Auth
  static const loginHero = 'assets/images/auth/login_hero.png';
  static const signupIllustration = 'assets/images/auth/signup_illustration.png';

  // Home
  static const profilePlaceholder = 'assets/images/home/profile_placeholder.png';
}

class AppIcons {
  // Navigation
  static const home = 'assets/icons/navigation/home.svg';
  static const search = 'assets/icons/navigation/search.svg';
  static const settings = 'assets/icons/navigation/settings.svg';

  // Actions
  static const add = 'assets/icons/actions/add.svg';
  static const edit = 'assets/icons/actions/edit.svg';
  static const delete = 'assets/icons/actions/delete.svg';
}
```

#### Step 4: Use in Flutter Code

Always reference assets via constants:

```dart
// ✅ CORRECT - Using constants
CachedImage(
  imageUrl: Assets.loginHero,
  width: AppConstants.heroImageWidth,
  height: AppConstants.heroImageHeight,
  fit: BoxFit.cover,
)

Icon(AssetImage(AppIcons.home))  // SVG icon

// ❌ WRONG - Hardcoded paths
Image.asset('assets/images/auth/login_hero.png')
Icon(AssetImage('assets/icons/home.svg'))
```

### Anti-Patterns

| Don't ❌                         | Do ✅                                                  |
| :------------------------------- | :----------------------------------------------------- |
| Hardcode Figma URLs in code      | Extract fileKey and nodeId, save in reference file     |
| Use relative paths for export    | Use absolute paths for `localPath` parameter           |
| Export all Figma nodes at once   | Export only needed assets batch-by-batch               |
| Import asset paths directly      | Add all assets to `Assets` or `AppIcons` constants     |
| Forget icon dimensions           | Use `AppConstants.iconSizeSM/MD/LG/XL` when displaying |
| Mix .png and .svg inconsistently | .svg for icons, .png for photos/illustrations          |

### Complete Example: Onboarding Feature

**Step 1**: Extract Figma data

```
Figma File: figma.com/file/abcd1234/App%20Designs
File Key: abcd1234
Nodes: 9999:1111 (Onboarding Page), 9999:2222 (Hero Image), 9999:3333 (Icon Set)
```

**Step 2**: Download assets

```
Downloaded:
- 9999:2222 → assets/images/onboarding/hero.png @2x
- 9999:3333 → assets/icons/navigation/home.svg
```

**Step 3**: Update constants

```dart
// lib/core/constants/assets.dart
class Assets {
  static const onboardingHero = 'assets/images/onboarding/hero.png';
}

class AppIcons {
  static const home = 'assets/icons/navigation/home.svg';
}
```

**Step 4**: Implement in Flutter

```dart
class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CachedImage(imageUrl: Assets.onboardingHero),
          VerticalSpace.lg(),
          Icon(AssetImage(AppIcons.home), size: AppConstants.iconSizeXL),
        ],
      ),
    );
  }
}
```

---

## ❓ FAQ

**Q: Where do I configure API URLs?**
A: `lib/config/env_config.dart`

**Q: How do I add a new route?**
A: Add to `AppRoute` enum in `lib/app/router/app_router.dart`

**Q: How do I show a snackbar from a provider?**
A: Use `FeedbackService` or `context.showSnackBar()` from UI

**Q: I have a lint error.**
A: Run `make format`. If it persists, read the error message.

**Q: Why is `ErrorWidget` renamed to `AppErrorWidget`?**
A: To avoid collision with Flutter's built-in `ErrorWidget` class.

**Q: Why does `strongPassword()` not need `minLength(8)`?**
A: The `strongPassword()` validator already includes the 8-character minimum requirement.

**Q: How do I handle fresh install on iOS?**
A: The `FreshInstallHandler` automatically clears stale Keychain data on fresh installs.

**Q: How do I track screen views correctly?**
A: Use `useOnMount()` hook in `HookConsumerWidget` or `initState()` with `addPostFrameCallback` in `ConsumerStatefulWidget`. **Never** track in `build()`.

**Q: Why use HookConsumerWidget over ConsumerWidget?**
A: `HookConsumerWidget` combines Riverpod and Flutter Hooks, allowing you to use hooks like `useOnMount`, `useDebounce`, `useToggle` for cleaner code.

**Q: Where are the animation widgets located?**
A: Split across files in `lib/core/widgets/`: `entry_animations.dart`, `attention_animations.dart`, `staggered_list.dart`, etc. Import from `animations.dart` barrel file.

**Q: Where are the dialog helpers?**
A: `AppDialogs` in `lib/core/widgets/app_dialogs.dart`, `AppBottomSheets` in `lib/core/widgets/bottom_sheets.dart`. Import from `dialogs.dart` barrel file.

**Q: How do I avoid magic numbers?**
A: Use constants from `AppConstants`, `AppSpacing`, `ApiEndpoints`, `StorageKeys`, or `Assets`. Never hardcode numbers for spacing, durations, dimensions, etc.

**Q: What's the maximum file size allowed?**
A: Services/Logic: 200 lines, UI Widgets: 250 lines, Test files: ~300 lines. Split files if exceeded.

---

### 2026 Patterns - Riverpod, Dart, & Testing

**Q: What's `@JsonPersist()` and when do I use it?**
A: `@JsonPersist()` is Riverpod 3.0's offline-first persistence pattern. Use it for data that users access frequently offline (todos, products, profiles). It automatically shows cached data instantly while fetching fresh data in the background. See [Riverpod 3.0: Offline Persistence](#riverpod-30-offline-persistence-with-jsonpersist) section.

**Q: How do mutations work in Riverpod 3.0?**
A: Mutations are notifiers specifically for write operations (login, logout, form submission). They expose loading/error/success states automatically. Use them instead of manually triggering provider updates. See [Riverpod 3.0: Mutations API](#riverpod-30-mutations-api-for-side-effects) section.

**Q: What are extension types and why should I use them?**
A: Extension types (Dart 3.3+) let you create zero-cost type-safe wrappers around primitives. Perfect for UserId, EmailAddress, MoneyAmount, etc. Compiler prevents mixing types. See [Extension Types](#extension-types-zero-cost-type-safety) section.

**Q: Should I use dot shorthand syntax?**
A: Yes! Dart 3.10+ dot shorthand (`.primary` instead of `AppButtonVariant.primary`) is the modern pattern. Always use it when the compiler can infer the type. See [Dart 3.10+ Dot Shorthand Syntax](#dart-310-dot-shorthand-syntax) section.

**Q: How do I use pattern matching instead of if-else?**
A: Pattern matching uses `if (data case Pattern)` or `switch (value) { ... }` for cleaner destructuring. Compiler enforces all cases are handled. See [Pattern Matching & Destructuring](#pattern-matching--destructuring) section.

**Q: What's a golden test and when do I write them?**
A: Golden tests compare UI output against stored PNG/PNG files to catch visual regressions. Write them for critical widgets where visual changes would break functionality. See [Golden Tests - Visual Regression Testing](#golden-tests--visual-regression-testing) section.

**Q: What coverage target should I aim for?**
A: The 2026 standard is **80%+ code coverage** across unit, widget, and integration tests. Focus on critical paths (auth, core features) over trivial getters.

**Q: How do I write integration tests?**
A: Integration tests simulate real user flows end-to-end (login → home → purchase). Use `IntegrationTestWidgetsFlutterBinding` and real navigation. See [Integration Tests](#integration-tests--end-to-end-user-flows) section.

**Q: Where do I export Figma assets and how do I organize them?**
A: Export from Figma → `assets/images/<feature_name>/` and `assets/icons/<category>/`. Always add to `Assets` or `AppIcons` constants before using in code. See [Figma Integration & Design Asset Management](#-figma-integration--design-asset-management) section.

**Q: Why does Impeller eliminate jank but I still see frame drops?**
A: Impeller pre-compiles shaders eliminating that source of jank. Frame drops now come from logic issues: heavy computation, excessive rebuilds, memory leaks, or inefficient algorithms. Profile with DevTools Performance to identify causes. See [Impeller Rendering Engine](#-impeller-rendering-engine-2026-standard) section.

**Q: Can I use complex animations/effects without optimization?**
A: Yes! Impeller handles complex gradients, shadows, blur, and staggered animations smoothly. Don't worry about rendering performance unless you're doing particle systems or real-time physics.

**Q: How do I cancel timers properly?**
A: Store timer in `useRef<Timer?>()` in hooks, cancel before creating new one with `timerRef.value?.cancel()`, and always cancel in `useEffect` cleanup or `dispose()`.

**Q: Should all text use localization?**
A: Yes! **All user-facing text must use localization keys.** Never hardcode strings like button labels, dialog messages, or placeholders. Use `AppLocalizations.of(context).key`.

**Q: Can I use `StatefulWidget` for business logic?**
A: No. Use Riverpod Notifiers instead. `StatefulWidget` is only for managing local UI state (animations, text input focus). Never put business logic in `setState()`.

---

_Built for scalability. Maintained with ❤️._

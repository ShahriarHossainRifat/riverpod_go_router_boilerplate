import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/async_value_widget.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/buttons.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

void main() {
  group('AsyncValueWidget', () {
    testWidgets('shows loading widget when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncValueWidget<String>(
              value: const AsyncValue.loading(),
              data: Text.new,
              loading: () => const LoadingWidget(useLottie: false),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows data when loaded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AsyncValueWidget<String>(
              value: AsyncValue.data('Hello'),
              data: Text.new,
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('shows error widget when error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AsyncValueWidget<String>(
              value: AsyncValue.error('Test error', StackTrace.empty),
              data: Text.new,
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('uses custom loading widget when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncValueWidget<String>(
              value: const AsyncValue.loading(),
              data: Text.new,
              loading: () => const Text('Custom Loading'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Loading'), findsOneWidget);
    });
  });

  group('LoadingWidget', () {
    testWidgets('shows Lottie animation by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingWidget())),
      );

      expect(find.byType(LottieBuilder), findsOneWidget);
    });

    testWidgets('shows circular progress indicator when useLottie is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget(useLottie: false)),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget(message: 'Please wait...')),
        ),
      );

      expect(find.text('Please wait...'), findsOneWidget);
    });

    testWidgets('respects custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget(size: 100, useLottie: false)),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(CircularProgressIndicator),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      expect(sizedBox.width, 100);
      expect(sizedBox.height, 100);
    });
  });

  group('AppErrorWidget', () {
    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: 'Test error message')),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              message: 'Error',
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryPressed, isTrue);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: 'Error')),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('fromError factory creates widget from error object', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget.fromError(error: Exception('Test exception')),
          ),
        ),
      );

      expect(find.textContaining('Test exception'), findsOneWidget);
    });
  });

  group('EmptyWidget', () {
    testWidgets('shows message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyWidget(message: 'No items found')),
        ),
      );

      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('shows action button when action and label provided', (
      tester,
    ) async {
      var actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyWidget(
              message: 'Empty',
              action: () => actionPressed = true,
              actionLabel: 'Add Item',
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      await tester.pump();
      expect(actionPressed, isTrue);
    });
  });

  group('AppButton', () {
    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(onPressed: () => pressed = true, label: 'Press Me'),
          ),
        ),
      );

      await tester.tap(find.text('Press Me'));
      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(onPressed: null, label: 'Loading', isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              label: 'With Icon',
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppButton(onPressed: null, label: 'Disabled')),
        ),
      );

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });

  group('Spacing Widgets', () {
    testWidgets('VerticalSpace.xs creates 4px space', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(children: [Text('A'), VerticalSpace.xs(), Text('B')]),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, AppSpacing.xs);
    });

    testWidgets('HorizontalSpace.md creates 16px space', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(children: [Text('A'), HorizontalSpace.md(), Text('B')]),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, AppSpacing.md);
    });
  });
}

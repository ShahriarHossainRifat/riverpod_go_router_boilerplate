import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

/// Application logger with pretty output in debug mode.
///
/// This logger is designed to work both:
/// 1. As a static singleton (for bootstrap/pre-Riverpod usage)
/// 2. Via Riverpod provider (for normal app usage)
///
/// ## Usage in Bootstrap (before ProviderScope):
/// ```dart
/// AppLogger.instance.i('Initializing app...');
/// ```
///
/// ## Usage with Riverpod:
/// ```dart
/// final logger = ref.read(loggerProvider);
/// logger.d('Debug message');
/// logger.i('Info message');
/// logger.w('Warning message');
/// logger.e('Error message', error: exception, stackTrace: stack);
/// ```
class AppLogger {
  new _internal()
    : _logger = Logger(
        printer: PrettyPrinter(
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
        level: kDebugMode ? Level.debug : Level.warning,
      );

  /// Singleton instance for use before Riverpod is available.
  static final AppLogger instance = AppLogger._internal();

  final Logger _logger;

  /// Log debug message
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  void i(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  void w(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal message
  void f(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log with custom level
  void log(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.log(level, message, error: error, stackTrace: stackTrace);
  }
}

/// Provider for the application logger.
/// Returns the singleton instance for consistency.
@Riverpod(keepAlive: true)
AppLogger logger(Ref ref) => .instance;

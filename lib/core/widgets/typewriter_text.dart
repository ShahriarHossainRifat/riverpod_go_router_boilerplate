import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A widget that displays text with a typewriter effect.
///
/// Great for onboarding screens, loading messages, or any place where
/// you want to draw attention to text appearing character by character.
///
/// Example:
/// ```dart
/// TypewriterText(
///   text: 'Welcome to the app!',
///   style: Theme.of(context).textTheme.headlineMedium,
///   onComplete: () => print('Animation complete'),
/// )
/// ```
class TypewriterText extends StatefulWidget {
  /// Creates a [TypewriterText] widget.
  const new({
    required this.text,
    super.key,
    this.style,
    this.charDelay = AppConstants.typewriterCharDelay,
    this.cursor = '|',
    this.showCursor = true,
    this.onComplete,
    this.autoStart = true,
    this.controller,
  });

  /// The text to display with typewriter effect.
  final String text;

  /// Text style.
  final TextStyle? style;

  /// Delay between each character.
  final Duration charDelay;

  /// Cursor character to show while typing.
  final String cursor;

  /// Whether to show the cursor.
  final bool showCursor;

  /// Callback when typing completes.
  final VoidCallback? onComplete;

  /// Whether to start typing automatically.
  final bool autoStart;

  /// Optional controller for programmatic control.
  final TypewriterController? controller;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  int _charIndex = 0;
  bool _isTyping = false;
  bool _showCursor = true;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController =
        AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: this,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() => _showCursor = false);
            _cursorController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            setState(() => _showCursor = true);
            _cursorController.forward();
          }
        });

    widget.controller?._attach(this);

    if (widget.autoStart) {
      _startTyping();
    }
  }

  void _startTyping() {
    if (_isTyping) return;
    _isTyping = true;
    _charIndex = 0;
    _cursorController.forward();
    _typeNextChar();
  }

  void _typeNextChar() {
    if (!mounted) return;

    if (_charIndex < widget.text.length) {
      Future.delayed(widget.charDelay, () {
        if (mounted) {
          setState(() => _charIndex++);
          _typeNextChar();
        }
      });
    } else {
      _isTyping = false;
      _cursorController.stop();
      setState(() => _showCursor = false);
      widget.onComplete?.call();
    }
  }

  void reset() {
    setState(() {
      _charIndex = 0;
      _isTyping = false;
    });
  }

  void start() {
    reset();
    _startTyping();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.autoStart) {
      start();
    }
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _charIndex);
    final cursorChar = widget.showCursor && _isTyping && _showCursor
        ? widget.cursor
        : '';

    return Text('$displayText$cursorChar', style: widget.style);
  }
}

/// Controller for [TypewriterText].
class TypewriterController {
  _TypewriterTextState? _state;

  void _attach(_TypewriterTextState state) {
    _state = state;
  }

  /// Starts the typewriter animation.
  void start() => _state?.start();

  /// Resets the typewriter to the beginning.
  void reset() => _state?.reset();
}

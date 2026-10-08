import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A widget that smoothly expands and collapses its content.
///
/// Perfect for FAQ sections, expandable details, or collapsible content.
///
/// Example:
/// ```dart
/// ExpandableWidget(
///   header: Text('Click to expand'),
///   child: Text('Expanded content here...'),
/// )
/// ```
class ExpandableWidget extends StatefulWidget {
  /// Creates an [ExpandableWidget].
  const new({
    required this.header,
    required this.child,
    super.key,
    this.initiallyExpanded = false,
    this.duration = AppConstants.expandAnimation,
    this.curve = Curves.easeInOut,
    this.onExpansionChanged,
    this.controller,
    this.headerPadding,
    this.expandIcon,
    this.collapseIcon,
    this.iconColor,
  });

  /// Header widget that toggles expansion.
  final Widget header;

  /// Content to show when expanded.
  final Widget child;

  /// Whether to start expanded.
  final bool initiallyExpanded;

  /// Duration of the expand/collapse animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Callback when expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Optional controller for programmatic control.
  final ExpandableController? controller;

  /// Padding around the header.
  final EdgeInsetsGeometry? headerPadding;

  /// Icon to show when collapsed (null to hide).
  final IconData? expandIcon;

  /// Icon to show when expanded (null to hide).
  final IconData? collapseIcon;

  /// Color for the expand/collapse icon.
  final Color? iconColor;

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _heightFactor = _controller.drive(CurveTween(curve: widget.curve));
    _iconTurns = _controller.drive(
      Tween<double>(begin: 0, end: 0.5).chain(CurveTween(curve: widget.curve)),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    widget.controller?._attach(this);
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  void expand() {
    if (!_isExpanded) _toggle();
  }

  void collapse() {
    if (_isExpanded) _toggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasIcon = widget.expandIcon != null || widget.collapseIcon != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: widget.headerPadding ?? EdgeInsets.zero,
            child: Row(
              children: [
                Expanded(child: widget.header),
                if (hasIcon)
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      _isExpanded
                          ? (widget.collapseIcon ?? Icons.expand_less)
                          : (widget.expandIcon ?? Icons.expand_more),
                      color: widget.iconColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: child,
              );
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

/// Controller for [ExpandableWidget].
class ExpandableController {
  _ExpandableWidgetState? _state;

  void _attach(_ExpandableWidgetState state) {
    _state = state;
  }

  /// Expands the widget.
  void expand() => _state?.expand();

  /// Collapses the widget.
  void collapse() => _state?.collapse();

  /// Toggles the expansion state.
  void toggle() => _state?._toggle();

  /// Returns whether the widget is currently expanded.
  bool get isExpanded => _state?._isExpanded ?? false;
}

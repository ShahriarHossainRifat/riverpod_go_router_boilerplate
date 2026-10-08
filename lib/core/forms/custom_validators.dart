import 'package:reactive_forms/reactive_forms.dart';

/// Validator that checks if two fields match.
///
/// Commonly used for password confirmation.
///
/// ## Usage
///
/// ```dart
/// FormGroup(
///   { ... },
///   validators: [MustMatch('password', 'confirmPassword')],
/// );
/// ```
class MustMatch extends Validator<dynamic> {
  /// Creates a must match validator.
  new(this.controlName, this.matchingControlName);

  /// The name of the control to compare.
  final String controlName;

  /// The name of the control that must match.
  final String matchingControlName;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final form = control as FormGroup;
    final formControl = form.control(controlName);
    final matchingControl = form.control(matchingControlName);

    if (formControl.value != matchingControl.value) {
      matchingControl.setErrors({'mustMatch': true});
      return {'mustMatch': true};
    }

    matchingControl.removeError('mustMatch');
    return null;
  }
}

/// Async validator for checking uniqueness.
///
/// ## Usage
///
/// ```dart
/// FormControl<String>(
///   asyncValidators: [
///     UniqueValidator(
///       checkFn: (value) => api.checkUsernameAvailable(value),
///     ),
///   ],
///   asyncValidatorsDebounceTime: 500,
/// ),
/// ```
class UniqueValidator extends AsyncValidator<dynamic> {
  /// Creates a unique validator.
  new({required this.checkFn, this.errorKey = 'notUnique'});

  /// Function to check uniqueness (returns true if valid/unique).
  final Future<bool> Function(String value) checkFn;

  /// The error key to use when validation fails.
  final String errorKey;

  @override
  Future<Map<String, dynamic>?> validate(
    AbstractControl<dynamic> control,
  ) async {
    final value = control.value as String?;
    if (value == null || value.isEmpty) return null;

    final isUnique = await checkFn(value);
    return isUnique ? null : {errorKey: true};
  }
}

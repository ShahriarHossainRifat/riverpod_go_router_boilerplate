/// Form validation utilities.
///
/// Provides a collection of reusable, composable validators for form fields.
/// All validators are pure functions that return null for valid input or
/// an error message string for invalid input.
///
/// ## Basic Usage
///
/// ```dart
/// TextFormField(
///   validator: Validators.required('Email is required'),
/// )
/// ```
///
/// ## Composing Validators
///
/// Chain multiple validators together - the first error wins:
///
/// ```dart
/// TextFormField(
///   validator: Validators.compose([
///     Validators.required('Email is required'),
///     Validators.email('Invalid email format'),
///   ]),
/// )
/// ```
///
/// ## Password Confirmation Example
///
/// ```dart
/// final passwordController = TextEditingController();
///
/// TextFormField(
///   controller: passwordController,
///   validator: Validators.compose([
///     Validators.required(),
///     Validators.strongPassword(),
///   ]),
/// ),
/// TextFormField(
///   validator: Validators.compose([
///     Validators.required('Please confirm password'),
///     Validators.match(() => passwordController.text, 'Passwords do not match'),
///   ]),
/// ),
/// ```
class Validators {
  const new _();

  /// Compose multiple validators
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Required field validator
  static String? Function(String?) required([String? message]) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// Email validator
  static String? Function(String?) email([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid email';
      }
      return null;
    };
  }

  /// Minimum length validator
  static String? Function(String?) minLength(int length, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Maximum length validator
  static String? Function(String?) maxLength(int length, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > length) {
        return message ?? 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Exact length validator
  static String? Function(String?) exactLength(int length, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length != length) {
        return message ?? 'Must be exactly $length characters';
      }
      return null;
    };
  }

  /// Pattern validator
  static String? Function(String?) pattern(RegExp regex, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Numeric only validator
  static String? Function(String?) numeric([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return message ?? 'Only numbers allowed';
      }
      return null;
    };
  }

  /// Phone number validator
  static String? Function(String?) phone([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
      if (!phoneRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid phone number';
      }
      return null;
    };
  }

  /// URL validator
  ///
  /// Validates that the input is a properly formatted URL with scheme and host.
  /// Accepts both http and https URLs.
  static String? Function(String?) url([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final uri = Uri.tryParse(value);
      if (uri == null ||
          !uri.hasScheme ||
          !uri.hasAuthority ||
          uri.host.isEmpty ||
          (!uri.isScheme('http') && !uri.isScheme('https'))) {
        return message ?? 'Please enter a valid URL';
      }
      return null;
    };
  }

  /// Match validator (for password confirmation)
  static String? Function(String?) match(
    String? Function() getValue, [
    String? message,
  ]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value != getValue()) {
        return message ?? 'Values do not match';
      }
      return null;
    };
  }

  /// Password strength validator
  static String? Function(String?) strongPassword([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      final hasUpperCase = value.contains(RegExp('[A-Z]'));
      final hasLowerCase = value.contains(RegExp('[a-z]'));
      final hasDigit = value.contains(RegExp('[0-9]'));
      final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      final hasMinLength = value.length >= 8;

      if (!hasUpperCase ||
          !hasLowerCase ||
          !hasDigit ||
          !hasSpecialChar ||
          !hasMinLength) {
        return message ??
            'Password must be at least 8 characters with uppercase, lowercase, number, and special character';
      }
      return null;
    };
  }
}

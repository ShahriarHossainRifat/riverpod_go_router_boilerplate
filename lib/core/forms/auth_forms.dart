import 'package:reactive_forms/reactive_forms.dart';
import 'package:riverpod_go_router_boilerplate/core/forms/custom_validators.dart';

/// Login form with email and password fields.
///
/// ## Usage
///
/// ```dart
/// final form = loginForm();
/// ReactiveForm(formGroup: form, child: ...);
/// ```
FormGroup loginForm() {
  return FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
    'rememberMe': FormControl<bool>(value: false),
  });
}

/// Registration form with email, password, and confirmation.
FormGroup registrationForm() {
  return FormGroup(
    {
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
          Validators.pattern(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
            validationMessage: 'Requires uppercase, lowercase, and number',
          ),
        ],
      ),
      'confirmPassword': FormControl<String>(validators: [Validators.required]),
      'acceptTerms': FormControl<bool>(
        value: false,
        validators: [Validators.requiredTrue],
      ),
    },
    validators: [MustMatch('password', 'confirmPassword')],
  );
}

/// Forgot password form.
FormGroup forgotPasswordForm() {
  return FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
  });
}

/// Change password form.
FormGroup changePasswordForm() {
  return FormGroup(
    {
      'currentPassword': FormControl<String>(validators: [Validators.required]),
      'newPassword': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
          Validators.pattern(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
            validationMessage: 'Requires uppercase, lowercase, and number',
          ),
        ],
      ),
      'confirmNewPassword': FormControl<String>(
        validators: [Validators.required],
      ),
    },
    validators: [MustMatch('newPassword', 'confirmNewPassword')],
  );
}

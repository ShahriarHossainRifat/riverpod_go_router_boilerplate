import 'package:flutter/material.dart';

import 'package:riverpod_go_router_boilerplate/core/hooks/basic_hooks.dart';

/// State for managing a form with multiple fields.
class FormControllerState {
  /// Creates a [FormControllerState] instance.
  const new({
    required this.fields,
    required this.isSubmitting,
    required this.isValid,
    required this.isDirty,
    required this.getValue,
    required this.setValue,
    required this.setError,
    required this.validateAll,
    required this.reset,
    required this.submit,
  });

  /// Map of field names to their current values.
  final Map<String, String> fields;

  /// Whether form is being submitted.
  final bool isSubmitting;

  /// Whether all fields are valid.
  final bool isValid;

  /// Whether any field has been modified.
  final bool isDirty;

  /// Gets a field's value.
  final String Function(String fieldName) getValue;

  /// Sets a field's value.
  final void Function(String fieldName, String value) setValue;

  /// Sets a field's error manually.
  final void Function(String fieldName, String? error) setError;

  /// Validates all fields and returns whether form is valid.
  final bool Function() validateAll;

  /// Resets the form to initial values.
  final VoidCallback reset;

  /// Submits the form with the provided callback.
  final Future<void> Function(
    Future<void> Function(Map<String, String> values) onSubmit,
  )
  submit;
}

/// Hook for simple form state management.
///
/// For complex forms, prefer using `reactive_forms` package.
///
/// ## Usage
///
/// ```dart
/// final form = useFormController(
///   fields: {'email': '', 'password': ''},
///   validators: {
///     'email': Validators.compose([Validators.required(), Validators.email()]),
///   },
/// );
///
/// TextField(onChanged: (v) => form.setValue('email', v));
/// ```
FormControllerState useFormController({
  required Map<String, String> fields,
  Map<String, String? Function(String?)>? validators,
}) {
  final context = useContext();
  final values = useState<Map<String, String>>(Map.from(fields));
  final errors = useState<Map<String, String?>>({});
  final touched = useState<Set<String>>({});
  final isSubmitting = useState(false);

  String getValue(String fieldName) => values.value[fieldName] ?? '';

  void setValue(String fieldName, String value) {
    values.value = {...values.value, fieldName: value};
    touched.value = {...touched.value, fieldName};

    if (validators != null && validators.containsKey(fieldName)) {
      final error = validators[fieldName]!(value);
      errors.value = {...errors.value, fieldName: error};
    }
  }

  void setError(String fieldName, String? error) {
    errors.value = {...errors.value, fieldName: error};
  }

  bool validateAll() {
    if (validators == null) return true;

    final newErrors = <String, String?>{};
    var isValid = true;

    for (final entry in validators.entries) {
      final error = entry.value(values.value[entry.key]);
      newErrors[entry.key] = error;
      if (error != null) isValid = false;
    }

    errors.value = newErrors;
    touched.value = values.value.keys.toSet();
    return isValid;
  }

  void reset() {
    values.value = Map.from(fields);
    errors.value = {};
    touched.value = {};
    isSubmitting.value = false;
  }

  Future<void> submit(
    Future<void> Function(Map<String, String> values) onSubmit,
  ) async {
    if (!validateAll()) return;

    isSubmitting.value = true;
    try {
      await onSubmit(values.value);
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }

  final isValid = errors.value.values.every((e) => e == null);
  final isDirty = touched.value.isNotEmpty;

  return FormControllerState(
    fields: values.value,
    isSubmitting: isSubmitting.value,
    isValid: isValid,
    isDirty: isDirty,
    getValue: getValue,
    setValue: setValue,
    setError: setError,
    validateAll: validateAll,
    reset: reset,
    submit: submit,
  );
}

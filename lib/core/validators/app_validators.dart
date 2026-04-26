import 'package:flutter/widgets.dart';

import 'package:app_template/l10n/app_localizations.dart';

class AppValidators {
  AppValidators._();

  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static FormFieldValidator<String> required(BuildContext context) {
    final l10n = L10n.of(context);
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.validationRequired;
      }
      return null;
    };
  }

  static FormFieldValidator<String> minLength(BuildContext context, int min) {
    final l10n = L10n.of(context);
    return (value) {
      if (value != null && value.trim().length < min) {
        return l10n.validationMinLength(min);
      }
      return null;
    };
  }

  static FormFieldValidator<String> maxLength(BuildContext context, int max) {
    final l10n = L10n.of(context);
    return (value) {
      if (value != null && value.trim().length > max) {
        return l10n.validationMaxLength(max);
      }
      return null;
    };
  }

  static FormFieldValidator<String> startsWithLetter(BuildContext context) {
    final l10n = L10n.of(context);
    return (value) {
      if (value != null &&
          value.isNotEmpty &&
          !RegExp(r'^[a-zA-Z]').hasMatch(value)) {
        return l10n.validationStartsWithLetter;
      }
      return null;
    };
  }

  static FormFieldValidator<String> endsWithLetterOrNumber(
    BuildContext context,
  ) {
    final l10n = L10n.of(context);
    return (value) {
      if (value != null &&
          value.isNotEmpty &&
          !RegExp(r'[a-zA-Z0-9]$').hasMatch(value)) {
        return l10n.validationEndsWithLetterOrNumber;
      }
      return null;
    };
  }

  static FormFieldValidator<String> usernameChars(BuildContext context) {
    final l10n = L10n.of(context);
    return (value) {
      if (value != null &&
          value.isNotEmpty &&
          !RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
        return l10n.validationUsernameChars;
      }
      return null;
    };
  }
}

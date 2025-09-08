import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class AppValidators {
  static String? emailValidator(String? text , BuildContext context) {
    if (text == null || text.isEmpty) {
      return AppLocalizations.of(context)!.validate_enter_email;
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text);
    if (!emailValid) {
      return AppLocalizations.of(context)!.validate_valid_email;
    }
    return null;
  }

  static String? passwordValidator(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return AppLocalizations.of(context)!.validate_enter_password;
    }
    // Check minimum length
    if (text.length < 8) {
      return AppLocalizations.of(context)!.validate_8_characters;
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return AppLocalizations.of(context)!.validate_upper_password;
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
      return AppLocalizations.of(context)!.validate_special;
    }
    return null;
  }

  static String? confirmPasswordValidator(String? rePassword, String? password, BuildContext context) {
    if (rePassword == null || rePassword.isEmpty) {
      return AppLocalizations.of(context)!.validate_enter_password;
    }
    // Check minimum length
    if (rePassword.length < 8) {
      return AppLocalizations.of(context)!.validate_8_characters;
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(rePassword)) {
      return AppLocalizations.of(context)!.validate_upper_password;
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(rePassword)) {
       return AppLocalizations.of(context)!.validate_special;
    }
    // Check if it matches the original password
    if (password != rePassword) {
       return AppLocalizations.of(context)!.validate_not_match;
    }
    return null;
  }

  static String? phoneValidator(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return AppLocalizations.of(context)!.validate_enter_phone;
    }

    // Check if the phone number is valid
    final phoneRegex = RegExp(r'^(?:\+20\d{10}|01\d{9})$');

    if (!phoneRegex.hasMatch(text)) {
      return AppLocalizations.of(context)!.validate_valid_phone;
    }

    return null;
  }
}
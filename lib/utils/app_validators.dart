class AppValidators {
  static String? emailValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your email";
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text);
    if (!emailValid) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? passwordValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your password";
    }
    // Check minimum length
    if (text.length < 8) {
      return "Password must be at least 8 characters";
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return "Password must contain at least one uppercase letter";
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
      return "Password must contain at least one special character";
    }
    return null;
  }

  static String? confirmPasswordValidator(String? rePassword, String? password) {
    if (rePassword == null || rePassword.isEmpty) {
      return "Please enter your password";
    }
    // Check minimum length
    if (rePassword.length < 8) {
      return "Password must be at least 8 characters";
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(rePassword)) {
      return "Password must contain at least one uppercase letter";
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(rePassword)) {
      return "Password must contain at least one special character";
    }
    // Check if it matches the original password
    if (password != rePassword) {
      return "Passwords do not match";
    }
    return null;
  }

  static String? phoneValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your phone number";
    }

    // Check if the phone number is valid
    final phoneRegex = RegExp(r'^(?:\+20\d{10}|01\d{9})$');

    if (!phoneRegex.hasMatch(text)) {
      return "Please enter a valid phone number (e.g. +2011xxxxxxxx or 011xxxxxxxx)";
    }

    return null;
  }
}
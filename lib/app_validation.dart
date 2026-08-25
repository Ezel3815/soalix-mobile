
class AppValidation {
  static bool isEmail(String? value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.a-zA-Z0-9-_]+\.[a-zA-Z]+")
        .hasMatch(value!);
  }

  static String? validateEmpty(String? value) {
    if (value!.trim().isEmpty) {
      return "Filed Required";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Filed Required";
    }

    if (!isEmail(value)) {
      return "Email not valid";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Filed Required";
    }
    if (value.length < 6) {
      return "Password Length must be 6 Digit or more";
    }
    return null;
  }
}

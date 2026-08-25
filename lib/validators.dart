import 'package:get/get.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || !value.isEmail) return 'error invalid email';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'error invalid username';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'password must not be empty';
    } else if (value.length < 4) {
      return 'password should be at least 4 characters';
    }
    return null;
  }
}

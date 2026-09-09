import 'dart:ui';

class AppColor {
  // Backgrounds
  static const Color scaffoldBackgroundColor = Color(0xFFF2F4E7); // canvas
  static const Color surfaceColor = Color(0xFFFAFBF6); // mist

  // Brand green
  static const Color greenColor = Color(0xFF4F9B69); // green
  static const Color darkGreenColor = Color(0xFF174A40); // deep
  static const Color forestGreenColor = Color(0xFF2A4E42); // forest
  static const Color freshGreenColor = Color(0xFF6DBA78); // fresh
  static const Color lightGreenColor = Color(0xFFDDF1D8); // soft
  static const Color disabledColor = Color(0xFF8A968F); // quiet

  // Text
  static const Color textPrimary = Color(0xFF1D2924); // ink
  static const Color textSecondary = Color(0xFF49665D); // muted

  // Utility / status
  static const Color warningColor = Color(0xFFD69E45);
  static const Color errorColor = Color(0xFFC95C5C);
  static const Color infoColor = Color(0xFF5D8FA3);

  // Legacy aliases kept so existing screens referencing these don't break
  static const Color lightRedColor = Color(0xFFF7DCD0);
  static const Color greyColor = Color(0xFFCFCFCF);
}

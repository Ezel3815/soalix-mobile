import 'package:get/get.dart';

/// Centralized, bilingual app text. Every screen that reads from here
/// automatically follows the language switch in the drawer — no
/// per-screen work needed. Screens that still hardcode Arabic text
/// inline (most of the app, as of now) aren't affected yet; moving a
/// screen's strings in here is what makes it respond to the language
/// toggle. Built out incrementally — see section markers.
class AppStrings {
  static bool get _isEnglish => Get.locale?.languageCode == 'en';

  static String _t(String ar, String en) => _isEnglish ? en : ar;

  // ===== Home =====
  static String get welcomeBack => _t("مرحباً بعودتك", "Welcome back");
  static String get continueJourney =>
      _t("لنكمل رحلتك التعليمية", "Let's continue your learning journey");
  static String get currentPath => _t("رحلتك الحالية", "Current Path");
  static String get yourLearningPath =>
      _t("مسارك التعليمي", "Learning Path");
  static String get todaysMissions => _t("مهام اليوم", "Today's Missions");
  static String get completedCount => _t("مكتمل", "completed");
  static String get friendsActivity => _t("نشاط الأصدقاء", "Friends Activity");
  static String get noSubjectsYet =>
      _t("لا توجد مواد دراسية بعد", "No subjects yet");

  // ===== Lesson path (shared widget: Home + subject drill-down) =====
  static String get lesson => _t("الدرس", "Lesson");
  static String get completed => _t("مكتمل", "Completed");
  static String get inProgress => _t("قيد التقدم", "In Progress");
  static String get pending => _t("قيد الانتظار", "Pending");
  static String get notStarted => _t("لم يبدأ", "Not Started");

  // ===== Bottom navigation =====
  static String get navHome => _t("تعلم", "Learn");
  static String get navLibrary => _t("البطاقات", "Cards");
  static String get navProgress => _t("التقدم", "Progress");
  static String get navProfile => _t("الملف الشخصي", "Profile");

  // ===== Streak / activity verbs (used in the friends feed) =====
  static String get unlocked => _t("فتح", "unlocked");
  static String get reachedLevel => _t("وصل إلى المستوى", "reached level");
  static String get dayStreak => _t("يوم متتالي", "day streak");

  // ===== Create deck =====
  static String get createDeck => _t("إنشاء مجموعة", "Create Deck");
  static String get startNewDeck => _t("ابدأ مجموعة جديدة", "Start a new deck");
  static String get startNewDeckHint => _t(
      "نظّم بطاقاتك في مجموعة لتبدأ الدراسة",
      "Organize your flashcards into a deck to start studying");
  static String get newDeck => _t("مجموعة جديدة", "New Deck");
  static String get deckName => _t("اسم المجموعة", "Deck name");
  static String get fieldRequired => _t("هذا الحقل مطلوب.", "This field is required.");
  static String get cancel => _t("إلغاء", "Cancel");
  static String get create => _t("إنشاء", "Create");

  // ===== Language toggle (drawer) =====
  static String get language => _t("اللغة", "Language");
  static String get arabic => _t("العربية", "Arabic");
  static String get english => _t("الإنجليزية", "English");

  // ===== Profile =====
  static String get couldntLoadProfile =>
      _t("تعذّر تحميل الملف الشخصي", "Couldn't load profile");
  static String get changePhoto => _t("تغيير الصورة", "Change Photo");
  static String get streak => _t("سلسلة الأيام", "Streak");
  static String get following => _t("متابَعون", "Following");
  static String get followers => _t("متابِعون", "Followers");
  static String get editProfile => _t("تعديل الملف الشخصي", "EDIT PROFILE");
  static String get friends => _t("أصدقاء", "FRIENDS");
  static String get followingButton => _t("متابَع", "FOLLOWING");
  static String get follow => _t("متابعة", "FOLLOW");
  static String get joined => _t("انضم في", "Joined");
  static const List<String> monthsAr = [
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
  ];
  static const List<String> monthsEn = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  static List<String> get months => _isEnglish ? monthsEn : monthsAr;

  // ===== Onboarding =====
  static String get skip => _t("تخطي", "Skip");
  static String get next => _t("التالي", "Next");
}

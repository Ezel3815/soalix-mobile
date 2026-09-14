/// All app-facing Arabic text lives here, one place, so every screen
/// stays consistent and future screens just add to this file instead
/// of hardcoding strings inline. Built out screen by screen — see the
/// section markers below for what's covered so far.
class AppStrings {
  // ===== Home =====
  static const welcomeBack = "مرحباً بعودتك";
  static const continueJourney = "لنكمل رحلتك التعليمية";
  static const currentPath = "رحلتك الحالية";
  static const yourLearningPath = "مسارك التعليمي";
  static const todaysMissions = "مهام اليوم";
  static const completedCount = "مكتمل"; // e.g. "2/3 مكتمل"
  static const friendsActivity = "نشاط الأصدقاء";
  static const noSubjectsYet = "لا توجد مواد دراسية بعد";

  // ===== Lesson path (shared widget: Home + subject drill-down) =====
  static const lesson = "الدرس"; // "الدرس 3"
  static const completed = "مكتمل";
  static const inProgress = "قيد التقدم";
  static const pending = "قيد الانتظار";
  static const notStarted = "لم يبدأ";

  // ===== Bottom navigation =====
  static const navHome = "تعلم";
  static const navLibrary = "البطاقات";
  static const navProgress = "التقدم";
  static const navProfile = "الملف الشخصي";

  // ===== Streak / activity verbs (used in the friends feed) =====
  static const unlocked = "فتح"; // "فتح إنجاز: ..."
  static const reachedLevel = "وصل إلى المستوى";
  static const dayStreak = "يوم متتالي";
}

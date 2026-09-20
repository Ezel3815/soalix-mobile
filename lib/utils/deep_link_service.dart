import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/main.dart';

/// Opens a user's profile from a shared link (mozaik://u/<username>).
/// Links received before the main screen is up (cold start / not logged in)
/// are kept and opened as soon as the main screen is ready.
class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static String? _pendingUsername;
  static bool _ready = false;

  static Future<void> init() async {
    try {
      _handle(await _appLinks.getInitialLink());
      _appLinks.uriLinkStream.listen(_handle);
    } catch (_) {}
  }

  static void markReady() {
    _ready = true;
    final pending = _pendingUsername;
    _pendingUsername = null;
    if (pending != null) _open(pending);
  }

  static void markNotReady() => _ready = false;

  static void _handle(Uri? uri) {
    if (uri == null || uri.scheme != 'mozaik' || uri.host != 'u') return;
    if (uri.pathSegments.isEmpty) return;
    final username = uri.pathSegments.first;
    if (_ready) {
      _open(username);
    } else {
      _pendingUsername = username;
    }
  }

  static Future<void> _open(String username) async {
    final id = await ApiController.getUserIdByUsername(username);
    if (id != null) Get.toNamed(AppRoutes.viewProfileRoute, arguments: id);
  }
}

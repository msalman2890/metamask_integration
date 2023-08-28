import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Future<bool> isAppInstalled(String url) async {
    try {
      return await canLaunchUrlString(url);
    } catch (e) {
      return false;
    }
  }
}

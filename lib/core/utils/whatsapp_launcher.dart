import 'package:url_launcher/url_launcher.dart';

class WhatsAppLauncher {
  static String cleanNumber(String number) {
    // Remove all non-digit characters except +
    String cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Handle Pakistan numbers (+92 or 03...)
    if (cleaned.startsWith('03')) {
      cleaned = '+92${cleaned.substring(1)}';
    } else if (cleaned.startsWith('92') && !cleaned.startsWith('+')) {
      cleaned = '+$cleaned';
    } else if (!cleaned.startsWith('+')) {
      // Default to + if missing, assuming country code is provided or handled
      // For this app, we emphasize Pakistan, but keep it flexible.
    }
    
    return cleaned;
  }

  static Future<void> launchWhatsApp(String number) async {
    String cleaned = cleanNumber(number);
    // Remove + for the URL if needed, but wa.me works with it too. 
    // Usually, wa.me/923001234567 is preferred.
    String urlNumber = cleaned.replaceAll('+', '');
    
    final Uri url = Uri.parse("https://wa.me/$urlNumber");
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}

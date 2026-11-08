import 'package:mona_diner/config.dart';
import 'package:url_launcher/url_launcher.dart';

void launchTermsConditionURL() async {
  final url = Uri.parse(AppConfig.termsUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

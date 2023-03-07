import 'package:anuvad_app/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AppAnalytics {
  static final AppAnalytics _instance = AppAnalytics._internal();

  factory AppAnalytics() {
    return _instance;
  }

  AppAnalytics._internal();

  static Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }
}
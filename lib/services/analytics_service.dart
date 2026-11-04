import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> logAppLaunched() async {
    await analytics.logEvent(name: 'app_launched');
  }

  Future<void> logRequestTapped(String requestName) async {
    await analytics.logEvent(
      name: 'request_tapped',
      parameters: {'request_name': requestName},
    );
  }

  Future<void> logRequestSuccess(String requestName) async {
    await analytics.logEvent(
      name: 'request_success',
      parameters: {'request_name': requestName},
    );
  }

  Future<void> logRequestFailed(String requestName) async {
    await analytics.logEvent(
      name: 'request_failed',
      parameters: {'request_name': requestName},
    );
  }
}

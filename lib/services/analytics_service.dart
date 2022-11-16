import 'package:firebase_analytics/firebase_analytics.dart';

/// Our calls to the Firebase Analytics API.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);



//   Future<void> logLogin() async {
//     await _analytics.logLogin(loginMethod: 'email');
//   }
//   Future<void> logLoginGoogle() async {
//     await _analytics.logLogin(loginMethod: 'google');
//   }
//
//   Future<void> logSignUp() async {
//     await _analytics.logSignUp(signUpMethod: 'email');
//   }
// // Log Write errors
//   Future<void> writeError( String error) async {
//     await _analytics.logEvent(name: 'writeError', parameters: <String, dynamic>{'errorDescription': error});
//   }

}

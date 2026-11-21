import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig({
    this.mockBaseUrl = 'https://mock.codit.local',
    this.enableScenarioPanel = kDebugMode,
    this.testOtp = '123456',
  });

  final String mockBaseUrl;
  final bool enableScenarioPanel;
  final String testOtp;
}
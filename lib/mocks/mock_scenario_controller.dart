import 'package:flutter/foundation.dart';

enum MockScenario {
  none,
  offline,
  timeoutNext,
  delayNext,
  failNext,
  approvalOtherDevice,
  approvalVersionBump,
  approvalDropResponse,
  collectionDropResponse,
  collectionInsufficientBalance,
  branchDuplicateEvent,
  branchSkipSequence,
  branchDelayResponse,
  authExpireToken,
  authFailRefresh,
}

class MockScenarioController extends ChangeNotifier {
  MockScenario active = MockScenario.none;
  bool dropNextResponse = false;
  int delayMs = 0;

  void setScenario(MockScenario scenario) {
    active = scenario;
    dropNextResponse = false;
    delayMs = 0;
    notifyListeners();
  }

  bool consumeDropResponse() {
    final v = dropNextResponse;
    dropNextResponse = false;
    return v;
  }

  bool get shouldDropResponse =>
      active == MockScenario.approvalDropResponse ||
      active == MockScenario.collectionDropResponse ||
      dropNextResponse;
}
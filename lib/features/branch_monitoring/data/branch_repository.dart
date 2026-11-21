import 'dart:convert';

import 'package:codit/core/database/app_database.dart';
import 'package:codit/mocks/mock_scenario_controller.dart';
import 'package:dio/dio.dart';
class BranchDashboard {
  BranchDashboard({
    required this.branchId,
    required this.sequence,
    required this.eventId,
    required this.updatedAt,
    required this.payload,
  });

  final String branchId;
  final int sequence;
  final String eventId;
  final DateTime updatedAt;
  final Map<String, dynamic> payload;
  
  BranchDashboard copyWith({
    String? branchId,
    int? sequence,
    String? eventId,
    DateTime? updatedAt,
    Map<String, dynamic>? payload,
  }) {
    return BranchDashboard(
      branchId: branchId ?? this.branchId,
      sequence: sequence ?? this.sequence,
      eventId: eventId ?? this.eventId,
      updatedAt: updatedAt ?? this.updatedAt,
      payload: payload ?? this.payload,
    );
  }
}

class BranchRepository {
  BranchRepository(this._dio, this._db, this._scenarios, {required this.accountId});

  final Dio _dio;
  final AppDatabase _db;
  final MockScenarioController _scenarios;
  String accountId;

  final Set<String> _seenEvents = {};
  int _selectedBranchToken = 0;

  int beginBranchRequest() => ++_selectedBranchToken;

  Future<BranchDashboard?> loadDashboard({
    required String branchId,
    required int requestToken,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/dashboard',
      queryParameters: {'branch_id': branchId},
    );
    if (requestToken != _selectedBranchToken) {
      return null;
    }
    final data = res.data!;
    return _applyEvent(branchId, data, requestToken);
  }

  Future<BranchDashboard?> _applyEvent(
    String branchId,
    Map<String, dynamic> data,
    int requestToken,
  ) async {
    if (requestToken != _selectedBranchToken) return null;

    final eventId = data['event_id'] as String;
    final sequence = data['sequence'] as int;
    final scopeKey = '$accountId:$branchId';

    final cached = await (_db.select(_db.branchSnapshots)
          ..where((t) => t.scopeKey.equals(scopeKey)))
        .getSingleOrNull();

    if (_scenarios.active == MockScenario.branchSkipSequence &&
        cached != null &&
        sequence > cached.lastSequence + 1) {
      final snap = await _dio.get<Map<String, dynamic>>(
        '/dashboard/snapshot',
        queryParameters: {'branch_id': branchId},
      );
      return _replaceSnapshot(branchId, snap.data!, requestToken);
    }

    if (_seenEvents.contains(eventId) ||
        _scenarios.active == MockScenario.branchDuplicateEvent) {
      if (_seenEvents.contains(eventId)) {
        return cached == null
            ? null
            : BranchDashboard(
                branchId: branchId,
                sequence: cached.lastSequence,
                eventId: eventId,
                updatedAt: cached.updatedAt,
                payload: jsonDecode(cached.payloadJson) as Map<String, dynamic>,
              );
      }
    }

    if (cached != null && sequence <= cached.lastSequence) {
      return BranchDashboard(
        branchId: branchId,
        sequence: cached.lastSequence,
        eventId: eventId,
        updatedAt: cached.updatedAt,
        payload: jsonDecode(cached.payloadJson) as Map<String, dynamic>,
      );
    }

    _seenEvents.add(eventId);
  final updatedAt = DateTime.parse(data['updated_at'] as String);
    await _db.into(_db.branchSnapshots).insertOnConflictUpdate(
          BranchSnapshotsCompanion.insert(
            scopeKey: scopeKey,
            payloadJson: jsonEncode(data),
            lastSequence: sequence,
            updatedAt: updatedAt,
            accountId: accountId,
          ),
        );

    return BranchDashboard(
      branchId: branchId,
      sequence: sequence,
      eventId: eventId,
      updatedAt: updatedAt,
      payload: data,
    );
  }

  Future<BranchDashboard?> _replaceSnapshot(
    String branchId,
    Map<String, dynamic> data,
    int requestToken,
  ) async {
    if (requestToken != _selectedBranchToken) return null;
    _scenarios.setScenario(MockScenario.none);
    _seenEvents.clear();
    return _applyEvent(branchId, data, requestToken);
  }

  void clearForAccountSwitch() {
    _seenEvents.clear();
    _selectedBranchToken++;
  }

  Future<List<Map<String, dynamic>>> branches() async {
    final res = await _dio.get<Map<String, dynamic>>('/branches');
    return (res.data?['items'] as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
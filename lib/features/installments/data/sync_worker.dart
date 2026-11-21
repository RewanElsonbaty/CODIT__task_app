import 'dart:async';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:flutter/foundation.dart';

/// Background worker للمزامنة التلقائية للتحصيلات المعلقة
class SyncWorker {
  SyncWorker(this._repo, this._network);

  final InstallmentRepository _repo;
  final NetworkInfo _network;
  Timer? _timer;
  bool _isRunning = false;

  /// بدء المزامنة الدورية
  /// [intervalSeconds] - الفاصل الزمني بالثواني (افتراضي: 30 ثانية)
  void start({int intervalSeconds = 30}) {
    if (_isRunning) return;
    
    _isRunning = true;
    debugPrint('[SyncWorker] Starting with interval: ${intervalSeconds}s');
    
    // مزامنة فورية عند البدء
    _syncOnce();
    
    // جدولة المزامنة الدورية
    _timer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _syncOnce(),
    );
  }

  /// إيقاف المزامنة الدورية
  void stop() {
    if (!_isRunning) return;
    
    debugPrint('[SyncWorker] Stopping');
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  /// مزامنة واحدة
  Future<void> _syncOnce() async {
    // التحقق من الاتصال أولاً
    if (!await _network.isConnected) {
      debugPrint('[SyncWorker] No connection, skipping sync');
      return;
    }

    try {
      debugPrint('[SyncWorker] Starting sync...');
      await _repo.syncPending();
      debugPrint('[SyncWorker] Sync completed successfully');
    } catch (e) {
      debugPrint('[SyncWorker] Sync failed: $e');
      // لا نرمي الخطأ - فقط نسجله ونحاول مرة أخرى في الدورة القادمة
    }
  }

  /// مزامنة فورية (manual trigger)
  Future<void> syncNow() async {
    if (!await _network.isConnected) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    }
    
    await _repo.syncPending();
  }

  /// التحقق من وجود عمليات معلقة
  Future<int> getPendingCount() async {
    final pending = await _repo.pendingCollections();
    return pending.length;
  }

  bool get isRunning => _isRunning;
}

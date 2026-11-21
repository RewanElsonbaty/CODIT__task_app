import 'dart:async';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/features/branch_monitoring/data/branch_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchMonitoringState {
  BranchMonitoringState({
    this.loading = false,
    this.dashboard,
    this.branchId = 'BR-A',
    this.offline = false,
    this.error,
    this.branches = const [],
    this.streaming = false,
    this.lastUpdate,
  });

  final bool loading;
  final BranchDashboard? dashboard;
  final String branchId;
  final bool offline;
  final String? error;
  final List<Map<String, dynamic>> branches;
  final bool streaming;
  final DateTime? lastUpdate;

  BranchMonitoringState copyWith({
    bool? loading,
    BranchDashboard? dashboard,
    String? branchId,
    bool? offline,
    String? error,
    List<Map<String, dynamic>>? branches,
    bool? streaming,
    DateTime? lastUpdate,
  }) =>
      BranchMonitoringState(
        loading: loading ?? this.loading,
        dashboard: dashboard ?? this.dashboard,
        branchId: branchId ?? this.branchId,
        offline: offline ?? this.offline,
        error: error,
        branches: branches ?? this.branches,
        streaming: streaming ?? this.streaming,
        lastUpdate: lastUpdate ?? this.lastUpdate,
      );
}

class BranchMonitoringCubit extends Cubit<BranchMonitoringState> {
  BranchMonitoringCubit(this._repo, this._network) : super(BranchMonitoringState());

  final BranchRepository _repo;
  final NetworkInfo _network;
  Timer? _pollingTimer;
  int _currentRequestId = 0;
  StreamSubscription<void>? _appLifecycleSubscription;

  Future<void> init() async {
    try {
      final branches = await _repo.branches();
      emit(state.copyWith(branches: branches));
      await selectBranch(state.branchId);
    } catch (e) {
      debugPrint('[BranchMonitoring] Init error: $e');
      emit(state.copyWith(error: 'فشل تحميل قائمة الفروع'));
    }
  }

  Future<void> selectBranch(String branchId) async {
    stopStreaming();
    
    final token = _repo.beginBranchRequest();
    emit(state.copyWith(
      loading: true,
      branchId: branchId,
      error: null,
    ));
    
    final connected = await _network.isConnected;
    if (!connected) {
      emit(state.copyWith(
        loading: false,
        offline: true,
        error: 'لا يوجد اتصال بالإنترنت',
      ));
      return;
    }
    
    try {
      final dash = await _repo.loadDashboard(
        branchId: branchId,
        requestToken: token,
      );
      
      if (dash == null) {
        debugPrint('[BranchMonitoring] Request cancelled (token mismatch)');
        return;
      }
      
      // ✅ Race condition fix: تأكد أن الـ branchId لم يتغير أثناء الانتظار
      if (state.branchId != branchId) {
        debugPrint('[BranchMonitoring] Branch changed during load, ignoring old result');
        return;
      }
      
      emit(state.copyWith(
        loading: false,
        dashboard: dash,
        offline: false,
        lastUpdate: DateTime.now(),
        error: null,
      ));
      
      startStreaming();
    } catch (e) {
      debugPrint('[BranchMonitoring] Load error: $e');
      emit(state.copyWith(
        loading: false,
        error: 'فشل تحميل بيانات الفرع',
      ));
    }
  }

  void startStreaming({int intervalSeconds = 5}) {
    if (_pollingTimer != null && _pollingTimer!.isActive) return;
    
    debugPrint('[BranchMonitoring] Starting streaming with ${intervalSeconds}s interval');
    emit(state.copyWith(streaming: true));
    
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _pollUpdate(),
    );
  }

  void stopStreaming() {
    if (_pollingTimer == null) return;
    
    debugPrint('[BranchMonitoring] Stopping streaming');
    _pollingTimer?.cancel();
    _pollingTimer = null;
    
    if (!isClosed) {
      emit(state.copyWith(streaming: false));
    }
  }

  Future<void> _pollUpdate() async {
    if (!await _network.isConnected) {
      emit(state.copyWith(offline: true));
      stopStreaming();
      return;
    }

    final requestId = ++_currentRequestId;
    final token = _repo.beginBranchRequest();
    
    try {
      final dash = await _repo.loadDashboard(
        branchId: state.branchId,
        requestToken: token,
      );
      
      if (requestId != _currentRequestId) {
        debugPrint('[BranchMonitoring] Request $requestId cancelled');
        return;
      }
      
      if (dash == null) return;
      
      if (state.dashboard == null || dash.sequence > state.dashboard!.sequence) {
        debugPrint('[BranchMonitoring] New data: seq=${dash.sequence}');
        emit(state.copyWith(
          dashboard: dash,
          offline: false,
          lastUpdate: DateTime.now(),
          error: null,
        ));
      }
    } catch (e) {
      debugPrint('[BranchMonitoring] Poll error: $e');
      // لا نوقف الـ streaming - نحاول في المرة القادمة
    }
  }

  Future<void> refresh() async {
    if (state.loading) return;
    await selectBranch(state.branchId);
  }

  void onAppResumed() {
    debugPrint('[BranchMonitoring] App resumed, refreshing...');
    if (!state.streaming) {
      refresh();
    }
  }

  void onAccountSwitched() {
    debugPrint('[BranchMonitoring] Account switched, clearing data...');
    stopStreaming();
    _repo.clearForAccountSwitch();
    emit(BranchMonitoringState(branches: state.branches));
  }

  @override
  Future<void> close() {
    stopStreaming();
    _appLifecycleSubscription?.cancel();
    return super.close();
  }
}
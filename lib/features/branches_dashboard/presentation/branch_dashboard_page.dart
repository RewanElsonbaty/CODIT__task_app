import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../domain/models/branch_selection.dart';
import 'branch_dashboard_cubit.dart';
import 'widgets/branch_selector.dart';
import 'widgets/sales_summary_card.dart';
import 'widgets/cash_summary_card.dart';
import 'widgets/gold_prices_card.dart';
import 'widgets/recent_operations_card.dart';

/// Branch dashboard page for monitoring business performance
class BranchDashboardPage extends StatelessWidget {
  const BranchDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BranchDashboardCubit>()..initialize(),
      child: const _BranchDashboardView(),
    );
  }
}

class _BranchDashboardView extends StatelessWidget {
  const _BranchDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFB8941E),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.dashboard, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'لوحة تحكم المحل',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Refresh button
          IconButton(
            onPressed: () =>
                context.read<BranchDashboardCubit>().refresh(),
            icon: Icon(Icons.refresh, color: Color(0xFFD4AF37)),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: BlocBuilder<BranchDashboardCubit, BranchDashboardState>(
        builder: (context, state) {
          if (state is BranchDashboardLoading) {
            return _buildLoadingState();
          } else if (state is BranchDashboardLoaded) {
            return _buildLoadedState(context, state.summary, false);
          } else if (state is BranchDashboardOffline) {
            return _buildLoadedState(context, state.summary, true, state.lastUpdate);
          } else if (state is BranchDashboardError) {
            return _buildErrorState(context, state.message);
          } else if (state is BranchDashboardEmpty) {
            return _buildEmptyState();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    summary,
    bool isOffline, [
    DateTime? lastUpdate,
  ]) {
    return RefreshIndicator(
      onRefresh: () => context.read<BranchDashboardCubit>().refresh(),
      color: Color(0xFFD4AF37),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Offline indicator
            if (isOffline) ...[
              _buildOfflineIndicator(lastUpdate!),
              SizedBox(height: 16),
            ],

            // Branch selector
            // TODO: Get available branches from repository
            BranchSelector(
              currentSelection: BranchSelection.all(),
              availableBranches: [], // TODO: Load from repository
              onBranchChanged: (selection) {
                context.read<BranchDashboardCubit>().changeBranch(selection);
              },
            ),
            SizedBox(height: 16),

            // Sales summary
            SalesSummaryCard(sales: summary.sales),
            SizedBox(height: 16),

            // Cash and gold prices in row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CashSummaryCard(cash: summary.cash),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GoldPricesCard(prices: summary.goldPrices),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Recent operations
            RecentOperationsCard(operations: summary.recentOperations),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineIndicator(DateTime lastUpdate) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFFC107).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFFFC107)),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: Color(0xFFFFC107), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وضع عدم الاتصال',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'عرض آخر بيانات محفوظة - ${_formatDateTime(lastUpdate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFFF5252),
            ),
            SizedBox(height: 16),
            Text(
              'تعذر تحميل البيانات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<BranchDashboardCubit>().refresh(),
              icon: Icon(Icons.refresh),
              label: Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.white30,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد بيانات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لم يتم العثور على بيانات للعرض',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else {
      return 'منذ ${diff.inDays} يوم';
    }
  }
}

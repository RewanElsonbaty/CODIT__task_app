import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../domain/models/branch_summary.dart';

/// Recent operations card showing latest operations
class RecentOperationsCard extends StatelessWidget {
  final List<RecentOperation> operations;

  const RecentOperationsCard({
    super.key,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFFFD700), // goldenNeon
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFA500).withOpacity(0.3), // goldenGlow
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF2196F3).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.history,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'آخر العمليات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Operations list
          if (operations.isEmpty)
            _buildEmptyState()
          else
            ...operations.map((op) => _buildOperationItem(op)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.white30,
            ),
            SizedBox(height: 8),
            Text(
              'لا توجد عمليات حديثة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationItem(RecentOperation operation) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getOperationColor(operation.type).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getOperationColor(operation.type).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getOperationIcon(operation.type),
              color: _getOperationColor(operation.type),
              size: 20,
            ),
          ),
          SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operation.type.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  operation.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _formatTimestamp(operation.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            _formatCurrency(operation.amountPiastres),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getOperationColor(operation.type),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getOperationIcon(OperationType type) {
    switch (type) {
      case OperationType.sale:
        return Icons.shopping_cart;
      case OperationType.installmentCollection:
        return Icons.payment;
      case OperationType.approvalRequest:
        return Icons.approval;
      case OperationType.return_:
        return Icons.undo;
    }
  }

  Color _getOperationColor(OperationType type) {
    switch (type) {
      case OperationType.sale:
        return Color(0xFF4CAF50);
      case OperationType.installmentCollection:
        return Color(0xFF2196F3);
      case OperationType.approvalRequest:
        return Color(0xFFFFC107);
      case OperationType.return_:
        return Color(0xFFFF5252);
    }
  }

  String _formatCurrency(int piastres) {
    final egp = piastres / 100;
    return '${egp.toStringAsFixed(2)} ج.م';
  }

  String _formatTimestamp(DateTime timestamp) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return timeago.format(timestamp, locale: 'ar');
  }
}

import 'package:codit/features/installments/presentation/installments_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/balance_breakdown_card.dart';
import 'package:codit/features/installments/presentation/widgets/collection_form.dart';
import 'package:codit/features/installments/presentation/widgets/debt_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDebtsBody extends StatelessWidget {
  const CustomerDebtsBody({
    super.key,
    required this.customerId,
    required this.data,
    required this.amountController,
  });

  final String customerId;
  final Map<String, dynamic> data;
  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    final debts = data['debts'] as List<dynamic>;
    final serverOutstanding = data['server_outstanding_piastres'] as int? ?? 0;
    final localPending = data['local_pending_piastres'] as int? ?? 0;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // البطاقة الجديدة المحسّنة
          BalanceBreakdownCard(
            serverOutstandingPiastres: serverOutstanding,
            localPendingPiastres: localPending,
            lastSyncTime: DateTime.now(),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                for (final debt in debts)
                  DebtListTile(debt: debt as Map<String, dynamic>),
              ],
            ),
          ),
          CollectionForm(
            amountController: amountController,
            onSubmit: () {
              final piastres = int.tryParse(amountController.text) ?? 0;
              context.read<InstallmentsCubit>().collect(
                    customerId: customerId,
                    customerName: data['customer_name'] as String,
                    piastres: piastres,
                    method: 'cash',
                  );
            },
          ),
        ],
      ),
    );
  }
}
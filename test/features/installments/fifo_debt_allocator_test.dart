import 'package:codit/features/installments/domain/fifo_debt_allocator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FIFO allocates oldest debt first', () {
    final debts = [
      DebtSlice(debtId: 'D1', collectedPiastres: 0, remainingPiastres: 100000, status: 'open'),
      DebtSlice(debtId: 'D2', collectedPiastres: 0, remainingPiastres: 50000, status: 'open'),
    ];
    final updated = FifoDebtAllocator().allocate(debts: debts, paymentPiastres: 120000);
    expect(updated.firstWhere((d) => d.debtId == 'D1').remainingPiastres, 0);
    expect(updated.firstWhere((d) => d.debtId == 'D2').remainingPiastres, 30000);
  });
}
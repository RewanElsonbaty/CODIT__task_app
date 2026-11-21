class DebtSlice {
  DebtSlice({
    required this.debtId,
    this.collectedPiastres = 0,
    required this.remainingPiastres,
    required this.status,
  });

  final String debtId;
  int collectedPiastres;
  int remainingPiastres;
  String status;
}

class FifoDebtAllocator {
  List<DebtSlice> allocate({
    required List<DebtSlice> debts,
    required int paymentPiastres,
  }) {
    final sorted = [...debts]..sort((a, b) => a.debtId.compareTo(b.debtId));
    var remaining = paymentPiastres;
    for (final debt in sorted) {
      if (remaining <= 0) break;
      if (debt.remainingPiastres <= 0) continue;
      final applied =
          remaining < debt.remainingPiastres ? remaining : debt.remainingPiastres;
      debt.collectedPiastres += applied;
      debt.remainingPiastres -= applied;
      remaining -= applied;
      debt.status = debt.remainingPiastres == 0 ? 'paid' : 'partial';
    }
    return sorted;
  }
}
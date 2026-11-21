import 'package:flutter/material.dart';
import '../../domain/models/branch_selection.dart';

/// Branch selector dropdown
class BranchSelector extends StatelessWidget {
  final BranchSelection currentSelection;
  final List<BranchInfo> availableBranches;
  final ValueChanged<BranchSelection> onBranchChanged;

  const BranchSelector({
    super.key,
    required this.currentSelection,
    required this.availableBranches,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD4AF37),
            Color(0xFFB8941E),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD4AF37).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BranchSelection>(
          value: currentSelection,
          dropdownColor: Color(0xFF2A2A2A),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          items: _buildItems(),
          onChanged: (value) {
            if (value != null) {
              onBranchChanged(value);
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<BranchSelection>> _buildItems() {
    final items = <DropdownMenuItem<BranchSelection>>[];

    // All branches option
    items.add(
      DropdownMenuItem(
        value: BranchSelection.all(),
        child: Row(
          children: [
            Icon(Icons.store, color: Color(0xFFD4AF37), size: 20),
            SizedBox(width: 8),
            Text('كل الفروع'),
          ],
        ),
      ),
    );

    // Individual branches
    for (final branch in availableBranches) {
      if (!branch.isActive) continue;

      items.add(
        DropdownMenuItem(
          value: BranchSelection.specific(
            branchId: branch.id,
            branchName: branch.name,
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFD4AF37), size: 20),
              SizedBox(width: 8),
              Text(branch.name),
            ],
          ),
        ),
      );
    }

    return items;
  }
}

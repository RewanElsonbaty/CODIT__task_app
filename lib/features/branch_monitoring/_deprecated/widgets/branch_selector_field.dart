import 'package:flutter/material.dart';

class BranchSelectorField extends StatelessWidget {
  const BranchSelectorField({
    super.key,
    required this.branchId,
    required this.branches,
    required this.onChanged,
  });

  final String branchId;
  final List<Map<String, dynamic>> branches;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: branchId,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 28),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          items: [
            for (final b in branches)
              DropdownMenuItem(
                value: b['id'] as String,
                child: Row(
                  children: [
                    Icon(
                      b['id'] == 'all' ? Icons.store : Icons.storefront,
                      size: 20,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Text(b['name'] as String),
                  ],
                ),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
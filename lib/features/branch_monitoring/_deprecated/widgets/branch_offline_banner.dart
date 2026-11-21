import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BranchOfflineBanner extends StatelessWidget {
  const BranchOfflineBanner({super.key, this.lastUpdate});

  final DateTime? lastUpdate;

  @override
  Widget build(BuildContext context) {
    String updateText = 'لا يوجد اتصال بالإنترنت';
    
    if (lastUpdate != null) {
      final cairoTime = lastUpdate!.add(const Duration(hours: 2));
      final formatter = DateFormat('h:mm a - d/M/yyyy', 'ar');
      updateText = 'آخر تحديث: ${formatter.format(cairoTime)}';
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.orange[100],
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: Colors.orange[900],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وضع غير متصل',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.orange[900],
                  ),
                ),
                Text(
                  updateText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
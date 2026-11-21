import 'package:codit/features/home/presentation/widgets/home_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeMenuList extends StatelessWidget {
  const HomeMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    // تم إخفاء Developer Options من الـ UI
    // لكن Logic موجود ويمكن الوصول له من الكود
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HomeMenuTile(
          title: 'طلبات الموافقة',
          icon: Icons.fact_check,
          onTap: () => context.push('/approvals'),
        ),
        HomeMenuTile(
          title: 'تحصيل الأقساط',
          icon: Icons.payments,
          onTap: () => context.push('/installments'),
        ),
        HomeMenuTile(
          title: 'بيع الذهب',
          icon: Icons.diamond,
          onTap: () => context.push('/gold'),
        ),
        HomeMenuTile(
          title: 'مراقبة الفروع',
          icon: Icons.store,
          onTap: () => context.push('/branches'),
        ),
        // Developer options مخفية من UI لكن موجودة في الكود
        // if (showDev) HomeMenuTile(...) // Scenarios
        // if (showDev) HomeMenuTile(...) // Theme Testing
      ],
    );
  }
}
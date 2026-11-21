import 'package:codit/core/di/injection.dart';
import 'package:codit/mocks/mock_scenario_controller.dart';
import 'package:flutter/material.dart';

/// Widget للاختبار السريع لسيناريوهات branch monitoring
class BranchTestActions extends StatelessWidget {
  const BranchTestActions({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = getIt<MockScenarioController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'سيناريوهات الاختبار',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.network_check, color: Colors.orange),
          title: const Text('تفعيل تأخير الاستجابة'),
          subtitle: const Text('BR-A بطيء (2ث) / BR-B سريع (0.5ث)'),
          trailing: Switch(
            value: scenarios.active == MockScenario.branchDelayResponse,
            onChanged: (value) {
              if (value) {
                scenarios.setScenario(MockScenario.branchDelayResponse);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تفعيل تأخير الاستجابة - جرب التبديل السريع بين الفروع'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                scenarios.setScenario(MockScenario.none);
              }
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.copy, color: Colors.blue),
          title: const Text('محاكاة event مكرر'),
          subtitle: const Text('نفس التحديث يصل مرتين'),
          trailing: Switch(
            value: scenarios.active == MockScenario.branchDuplicateEvent,
            onChanged: (value) {
              if (value) {
                scenarios.setScenario(MockScenario.branchDuplicateEvent);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تفعيل التحديثات المكررة'),
                  ),
                );
              } else {
                scenarios.setScenario(MockScenario.none);
              }
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.clear_all, color: Colors.red),
          title: const Text('محاكاة تخطي sequence'),
          subtitle: const Text('يطلب snapshot كامل عند اكتشاف فجوة'),
          trailing: Switch(
            value: scenarios.active == MockScenario.branchSkipSequence,
            onChanged: (value) {
              if (value) {
                scenarios.setScenario(MockScenario.branchSkipSequence);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تفعيل تخطي sequence'),
                  ),
                );
              } else {
                scenarios.setScenario(MockScenario.none);
              }
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.wifi_off, color: Colors.grey),
          title: const Text('محاكاة قطع الاتصال'),
          subtitle: const Text('وضع offline'),
          trailing: Switch(
            value: scenarios.active == MockScenario.offline,
            onChanged: (value) {
              if (value) {
                scenarios.setScenario(MockScenario.offline);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تفعيل وضع offline'),
                  ),
                );
              } else {
                scenarios.setScenario(MockScenario.none);
              }
            },
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              scenarios.setScenario(MockScenario.none);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إيقاف جميع السيناريوهات')),
              );
            },
            icon: const Icon(Icons.clear),
            label: const Text('إيقاف جميع السيناريوهات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[100],
              foregroundColor: Colors.red[900],
            ),
          ),
        ),
      ],
    );
  }
}

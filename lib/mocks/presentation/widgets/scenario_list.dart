import 'package:codit/core/di/injection.dart';
import 'package:codit/mocks/mock_scenario_controller.dart';
import 'package:flutter/material.dart';

class ScenarioList extends StatelessWidget {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = getIt<MockScenarioController>();
    return ListView(
      children: [
        for (final s in MockScenario.values)
          ListTile(
            title: Text(s.name),
            selected: scenarios.active == s,
            onTap: () {
              scenarios.setScenario(s);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تفعيل: ${s.name}')),
              );
            },
          ),
      ],
    );
  }
}
import 'package:codit/mocks/presentation/widgets/scenario_list.dart';
import 'package:flutter/material.dart';

class ScenarioPanelPage extends StatelessWidget {
  const ScenarioPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محاكاة السيناريوهات')),
      body: const ScenarioList(),
    );
  }
}
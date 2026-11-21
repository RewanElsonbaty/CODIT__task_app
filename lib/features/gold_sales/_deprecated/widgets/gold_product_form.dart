import 'package:codit/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class GoldProductForm extends StatelessWidget {
  const GoldProductForm({
    super.key,
    required this.codeController,
    required this.onCalculate,
  });

  final TextEditingController codeController;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: codeController,
          decoration: const InputDecoration(labelText: 'كود المنتج'),
        ),
        AppButton(label: 'إضافة / حساب', onPressed: onCalculate),
      ],
    );
  }
}
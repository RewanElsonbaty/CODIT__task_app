import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decimal/decimal.dart';
import '../../domain/gold_sale_models.dart';
import '../gold_sale_cubit.dart';

/// Dialog for adding a gold item with all required fields
class AddGoldItemDialog extends StatefulWidget {
  final GoldProduct product;

  const AddGoldItemDialog({
    super.key,
    required this.product,
  });

  @override
  State<AddGoldItemDialog> createState() => _AddGoldItemDialogState();
}

class _AddGoldItemDialogState extends State<AddGoldItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _goldPriceController;
  late TextEditingController _workmanshipController;
  late TextEditingController _fixedWorkmanshipController;
  late TextEditingController _discountController;

  bool _useFixedWorkmanship = false;

  @override
  void initState() {
    super.initState();
    _goldPriceController = TextEditingController();
    _workmanshipController = TextEditingController(text: '0');
    _fixedWorkmanshipController = TextEditingController(text: '0');
    _discountController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _goldPriceController.dispose();
    _workmanshipController.dispose();
    _fixedWorkmanshipController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                
                // Product info (read-only)
                _buildInfoCard(
                  'معلومات القطعة',
                  [
                    _buildInfoRow('الكود:', product.code),
                    _buildInfoRow('الباركود:', product.barcode ?? 'غير متوفر'),
                    _buildInfoRow('الوزن القائم:', '${(product.grossMg / 1000).toStringAsFixed(3)} جرام'),
                    _buildInfoRow('وزن الفصوص:', '${(product.stoneMg / 1000).toStringAsFixed(3)} جرام'),
                    _buildInfoRow('الوزن الصافي:', '${(product.netMg / 1000).toStringAsFixed(3)} جرام'),
                    _buildInfoRow('العيار:', '${product.karat} قيراط'),
                    _buildInfoRow('الفئة:', product.category),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _goldPriceController,
                  label: 'سعر الجرام (جنيه)',
                  icon: Icons.attach_money,
                  validator: _validatePositiveDecimal,
                ),
                const SizedBox(height: 16),
                _buildWorkmanshipTypeSelector(),
                const SizedBox(height: 16),
                if (!_useFixedWorkmanship)
                  _buildTextField(
                    controller: _workmanshipController,
                    label: 'المصنعية للجرام (جنيه)',
                    icon: Icons.construction,
                    validator: _validateNonNegativeDecimal,
                  )
                else
                  _buildTextField(
                    controller: _fixedWorkmanshipController,
                    label: 'المصنعية الثابتة (جنيه)',
                    icon: Icons.construction,
                    validator: _validateNonNegativeDecimal,
                  ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _discountController,
                  label: 'الخصم (%)',
                  icon: Icons.percent,
                  validator: _validateDiscountPercent,
                ),
                const SizedBox(height: 24),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.add_shopping_cart,
            color: Color(0xFFD4AF37),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'إضافة قطعة ذهب',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Color(0xFFD4AF37)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildWorkmanshipTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نوع المصنعية',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildRadioOption(
                  label: 'للجرام',
                  value: false,
                  groupValue: _useFixedWorkmanship,
                  onChanged: (value) => setState(() => _useFixedWorkmanship = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRadioOption(
                  label: 'ثابتة',
                  value: true,
                  groupValue: _useFixedWorkmanship,
                  onChanged: (value) => setState(() => _useFixedWorkmanship = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String label,
    required bool value,
    required bool groupValue,
    required void Function(bool?) onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4AF37) : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.white60,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD4AF37) : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'إضافة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String? _validatePositiveDecimal(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'يجب إدخال رقم أكبر من صفر';
    }
    return null;
  }

  String? _validateNonNegativeDecimal(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return 'يجب إدخال رقم أكبر من أو يساوي صفر';
    }
    return null;
  }

  String? _validateDiscountPercent(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    final number = double.tryParse(value);
    if (number == null || number < 0 || number > 100) {
      return 'يجب إدخال نسبة بين 0 و 100';
    }
    return null;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = widget.product;
    final goldPriceEgp = double.parse(_goldPriceController.text);
    final discountPercent = double.parse(_discountController.text);
    
    final cubit = context.read<GoldSaleCubit>();
    
    cubit.addLineItem(
      productCode: product.code,
      grossMg: product.grossMg,
      stoneMg: product.stoneMg,
      karat: product.karat,
      pricePerGramPiastres: (goldPriceEgp * 100).round(),
      workmanshipPerGramPiastres: _useFixedWorkmanship
          ? 0
          : (double.parse(_workmanshipController.text) * 100).round(),
      fixedWorkmanshipPiastres: _useFixedWorkmanship
          ? (double.parse(_fixedWorkmanshipController.text) * 100).round()
          : 0,
      workmanshipPerGram: !_useFixedWorkmanship,
      discountPercent: Decimal.parse(discountPercent.toString()),
    );

    Navigator.of(context).pop();
  }
}

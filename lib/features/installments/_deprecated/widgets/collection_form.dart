import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CollectionForm extends StatefulWidget {
  const CollectionForm({
    super.key,
    required this.amountController,
    required this.onSubmit,
    this.maxAmountPiastres,
    this.isOffline = false,
  });

  final TextEditingController amountController;
  final VoidCallback onSubmit;
  final int? maxAmountPiastres;
  final bool isOffline;

  @override
  State<CollectionForm> createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  String? _errorText;
  String _selectedMethod = 'cash';

  @override
  void initState() {
    super.initState();
    widget.amountController.addListener(_validateAmount);
  }

  @override
  void dispose() {
    widget.amountController.removeListener(_validateAmount);
    super.dispose();
  }

  void _validateAmount() {
    setState(() {
      final text = widget.amountController.text;
      if (text.isEmpty) {
        _errorText = null;
        return;
      }

      final piastres = int.tryParse(text);
      if (piastres == null) {
        _errorText = 'يرجى إدخال رقم صحيح';
        return;
      }

      if (piastres <= 0) {
        _errorText = 'المبلغ يجب أن يكون أكبر من صفر';
        return;
      }

      if (widget.maxAmountPiastres != null && piastres > widget.maxAmountPiastres!) {
        final egp = widget.maxAmountPiastres! / 100;
        _errorText = 'المبلغ يتجاوز المتاح (${egp.toStringAsFixed(2)} ج)';
        return;
      }

      _errorText = null;
    });
  }

  bool get _isValid {
    final text = widget.amountController.text;
    if (text.isEmpty) return false;
    final piastres = int.tryParse(text);
    if (piastres == null || piastres <= 0) return false;
    if (widget.maxAmountPiastres != null && piastres > widget.maxAmountPiastres!) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان
            Row(
              children: [
                Icon(Icons.payment, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'تسجيل تحصيل',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (widget.isOffline)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'بدون نت',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // حقل المبلغ
            TextField(
              controller: widget.amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'مبلغ التحصيل (قرش)',
                hintText: 'أدخل المبلغ بالقرش',
                prefixIcon: const Icon(Icons.monetization_on),
                suffixIcon: widget.amountController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          widget.amountController.clear();
                        },
                      )
                    : null,
                errorText: _errorText,
                helperText: widget.maxAmountPiastres != null
                    ? 'الحد الأقصى: ${(widget.maxAmountPiastres! / 100).toStringAsFixed(2)} ج'
                    : null,
                helperStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 12),

            // طريقة الدفع
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طريقة الدفع',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildPaymentMethodChip('cash', 'نقدي', Icons.money),
                      _buildPaymentMethodChip('card', 'بطاقة', Icons.credit_card),
                      _buildPaymentMethodChip('transfer', 'تحويل', Icons.account_balance),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ملاحظة عند العمل بدون نت
            if (widget.isOffline) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'سيتم حفظ التحصيل محلياً ومزامنته عند توفر الإنترنت',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // زر التحصيل
            FilledButton(
              onPressed: _isValid ? widget.onSubmit : null,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('تحصيل الآن'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChip(String value, String label, IconData icon) {
    final isSelected = _selectedMethod == value;
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : theme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedMethod = value;
        });
      },
      selectedColor: theme.primaryColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.primaryColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? theme.primaryColor : Colors.grey.shade300,
        ),
      ),
    );
  }
}
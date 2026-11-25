import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import '../domain/installment_request_models.dart';
import '../data/mock_installment_requests_api.dart';

/// ØµÙØ­Ø© Ø¥Ù†Ø´Ø§Ø¡ Ø·Ù„Ø¨ ØªÙ‚Ø³ÙŠØ· Ø¬Ø¯ÙŠØ¯
/// 
/// ÙŠØ³ØªØ®Ø¯Ù…Ù‡Ø§ Ø§Ù„Ù…Ø¯ÙŠØ± Ù„Ø¥Ø±Ø³Ø§Ù„ Ø·Ù„Ø¨ ØªÙ‚Ø³ÙŠØ· Ù„Ù„Ù…Ø§Ù„Ùƒ
class CreateInstallmentRequestPage extends StatefulWidget {
  const CreateInstallmentRequestPage({super.key});

  @override
  State<CreateInstallmentRequestPage> createState() =>
      _CreateInstallmentRequestPageState();
}

class _CreateInstallmentRequestPageState
    extends State<CreateInstallmentRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _api = MockInstallmentRequestsApi();

  // Controllers
  final _customerNameController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _invoiceIdController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _installmentAmountController = TextEditingController();
  final _numberOfInstallmentsController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _firstPaymentDate;
  String _paymentInterval = 'monthly';
  bool _isLoading = false;

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerIdController.dispose();
    _customerPhoneController.dispose();
    _nationalIdController.dispose();
    _invoiceIdController.dispose();
    _totalAmountController.dispose();
    _downPaymentController.dispose();
    _installmentAmountController.dispose();
    _numberOfInstallmentsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectFirstPaymentDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.goldenNeon,
              onPrimary: Colors.black,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _firstPaymentDate = picked;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_firstPaymentDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ÙŠØ±Ø¬Ù‰ ØªØ­Ø¯ÙŠØ¯ Ù…ÙˆØ¹Ø¯ Ø£ÙˆÙ„ Ø¯ÙØ¹Ø©'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final totalAmount = double.parse(_totalAmountController.text);
      final downPayment = double.parse(_downPaymentController.text);
      final installmentAmount = double.parse(_installmentAmountController.text);
      final numberOfInstallments =
          int.parse(_numberOfInstallmentsController.text);

      // Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† ØµØ­Ø© Ø§Ù„Ù…Ø¨Ø§Ù„Øº
      if (downPayment >= totalAmount) {
        throw Exception('Ø§Ù„Ø¯ÙØ¹Ø© Ø§Ù„Ø£ÙˆÙ„Ù‰ ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† Ø£Ù‚Ù„ Ù…Ù† Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ');
      }

      final remainingAmount = totalAmount - downPayment;
      final calculatedTotal = installmentAmount * numberOfInstallments;

      if ((calculatedTotal - remainingAmount).abs() > 0.01) {
        throw Exception(
          'Ù…Ø¬Ù…ÙˆØ¹ Ø§Ù„Ø£Ù‚Ø³Ø§Ø· (${calculatedTotal.toStringAsFixed(2)}) '
          'Ù„Ø§ ÙŠØ³Ø§ÙˆÙŠ Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ù…ØªØ¨Ù‚ÙŠ (${remainingAmount.toStringAsFixed(2)})',
        );
      }

      final request = CreateInstallmentRequest(
        customerName: _customerNameController.text.trim(),
        customerId: _customerIdController.text.trim(),
        customerPhone: _customerPhoneController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        invoiceId: _invoiceIdController.text.trim(),
        totalAmountPiastres: (totalAmount * 100).toInt(),
        downPaymentPiastres: (downPayment * 100).toInt(),
        installmentAmountPiastres: (installmentAmount * 100).toInt(),
        numberOfInstallments: numberOfInstallments,
        firstPaymentDate: _firstPaymentDate!,
        paymentInterval: _paymentInterval,
        branchId: 'branch_001', // TODO: Get from current user
        branchName: 'ÙØ±Ø¹ Ø§Ù„Ù…Ø¹Ø§Ø¯ÙŠ', // TODO: Get from current user
        requestedBy: 'MGR-001', // TODO: Get from current user
        requestedByName: 'Ù…Ø­Ù…Ø¯ Ø£Ø­Ù…Ø¯ - Ù…Ø¯ÙŠØ± Ø§Ù„ÙØ±Ø¹', // TODO: Get from current user
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      final createdRequest = await _api.createInstallmentRequest(request);

      if (mounted) {
        Navigator.of(context).pop(createdRequest);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨ Ø¨Ù†Ø¬Ø§Ø­\nØ±Ù‚Ù… Ø§Ù„Ø·Ù„Ø¨: ${createdRequest.requestNumber}',
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.successDark,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      ExceptionHandler.logException(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ø®Ø·Ø£ ÙÙŠ Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨: ${e.toString()}'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Ø·Ù„Ø¨ ØªÙ‚Ø³ÙŠØ· Ø¬Ø¯ÙŠØ¯'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
          children: [
            // Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹Ù…ÙŠÙ„
            _buildSectionHeader('Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹Ù…ÙŠÙ„'),
            _buildTextField(
              controller: _customerNameController,
              label: 'Ø§Ø³Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _customerIdController,
              label: 'Ø±Ù‚Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„',
              icon: Icons.badge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø±Ù‚Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _customerPhoneController,
              label: 'Ø±Ù‚Ù… Ø§Ù„Ù‡Ø§ØªÙ',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø±Ù‚Ù… Ø§Ù„Ù‡Ø§ØªÙ';
                }
                if (value.length != 11) {
                  return 'Ø±Ù‚Ù… Ø§Ù„Ù‡Ø§ØªÙ ÙŠØ¬Ø¨ Ø£Ù† ÙŠÙƒÙˆÙ† 11 Ø±Ù‚Ù…Ù‹Ø§';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nationalIdController,
              label: 'Ø§Ù„Ø±Ù‚Ù… Ø§Ù„Ù‚ÙˆÙ…ÙŠ',
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ø±Ù‚Ù… Ø§Ù„Ù‚ÙˆÙ…ÙŠ';
                }
                if (value.length != 14) {
                  return 'Ø§Ù„Ø±Ù‚Ù… Ø§Ù„Ù‚ÙˆÙ…ÙŠ ÙŠØ¬Ø¨ Ø£Ù† ÙŠÙƒÙˆÙ† 14 Ø±Ù‚Ù…Ù‹Ø§';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙØ§ØªÙˆØ±Ø©
            _buildSectionHeader('Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙØ§ØªÙˆØ±Ø©'),
            _buildTextField(
              controller: _invoiceIdController,
              label: 'Ø±Ù‚Ù… Ø§Ù„ÙØ§ØªÙˆØ±Ø©',
              icon: Icons.receipt_long,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø±Ù‚Ù… Ø§Ù„ÙØ§ØªÙˆØ±Ø©';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _totalAmountController,
              label: 'Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ',
              icon: Icons.attach_money,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              suffix: 'Ø¬Ù†ÙŠÙ‡',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Ø§Ù„Ù…Ø¨Ù„Øº ØºÙŠØ± ØµØ­ÙŠØ­';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _downPaymentController,
              label: 'Ø§Ù„Ø¯ÙØ¹Ø© Ø§Ù„Ø£ÙˆÙ„Ù‰',
              icon: Icons.payments,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              suffix: 'Ø¬Ù†ÙŠÙ‡',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ø¯ÙØ¹Ø© Ø§Ù„Ø£ÙˆÙ„Ù‰';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount < 0) {
                  return 'Ø§Ù„Ù…Ø¨Ù„Øº ØºÙŠØ± ØµØ­ÙŠØ­';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ØªÙ‚Ø³ÙŠØ·
            _buildSectionHeader('ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙ‚Ø³ÙŠØ·'),
            _buildTextField(
              controller: _installmentAmountController,
              label: 'Ù‚ÙŠÙ…Ø© Ø§Ù„Ù‚Ø³Ø·',
              icon: Icons.money,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              suffix: 'Ø¬Ù†ÙŠÙ‡',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ù‚ÙŠÙ…Ø© Ø§Ù„Ù‚Ø³Ø·';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Ø§Ù„Ù…Ø¨Ù„Øº ØºÙŠØ± ØµØ­ÙŠØ­';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _numberOfInstallmentsController,
              label: 'Ø¹Ø¯Ø¯ Ø§Ù„Ø£Ù‚Ø³Ø§Ø·',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø¹Ø¯Ø¯ Ø§Ù„Ø£Ù‚Ø³Ø§Ø·';
                }
                final count = int.tryParse(value);
                if (count == null || count <= 0) {
                  return 'Ø§Ù„Ø¹Ø¯Ø¯ ØºÙŠØ± ØµØ­ÙŠØ­';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Ù…ÙˆØ¹Ø¯ Ø£ÙˆÙ„ Ø¯ÙØ¹Ø©
            GestureDetector(
              onTap: _selectFirstPaymentDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _firstPaymentDate == null
                        ? AppColors.border
                        : AppColors.goldenNeon,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _firstPaymentDate == null
                          ? AppColors.textSecondary
                          : AppColors.goldenNeon,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ù…ÙˆØ¹Ø¯ Ø£ÙˆÙ„ Ø¯ÙØ¹Ø©',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _firstPaymentDate == null
                                ? 'Ø§Ø¶ØºØ· Ù„ØªØ­Ø¯ÙŠØ¯ Ø§Ù„ØªØ§Ø±ÙŠØ®'
                                : '${_firstPaymentDate!.day}/${_firstPaymentDate!.month}/${_firstPaymentDate!.year}',
                            style: TextStyle(
                              color: _firstPaymentDate == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: _firstPaymentDate == null
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ÙØªØ±Ø© Ø§Ù„Ø³Ø¯Ø§Ø¯
            _buildPaymentIntervalSelector(),

            const SizedBox(height: 24),

            // Ù…Ù„Ø§Ø­Ø¸Ø§Øª
            _buildSectionHeader('Ù…Ù„Ø§Ø­Ø¸Ø§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)'),
            _buildTextField(
              controller: _notesController,
              label: 'Ù…Ù„Ø§Ø­Ø¸Ø§Øª Ø­ÙˆÙ„ Ø§Ù„Ø¹Ù…ÙŠÙ„ Ø£Ùˆ Ø§Ù„Ø·Ù„Ø¨',
              icon: Icons.note,
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Ø²Ø± Ø§Ù„Ø¥Ø±Ø³Ø§Ù„
            ElevatedButton(
              onPressed: _isLoading ? null : _submitRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenNeon,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ù…Ø§Ù„Ùƒ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.goldenNeon,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? suffix,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPaymentIntervalSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              const Text(
                'ÙØªØ±Ø© Ø§Ù„Ø³Ø¯Ø§Ø¯',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildIntervalChip('Ø´Ù‡Ø±ÙŠ', 'monthly'),
              const SizedBox(width: 8),
              _buildIntervalChip('Ø£Ø³Ø¨ÙˆØ¹ÙŠ', 'weekly'),
              const SizedBox(width: 8),
              _buildIntervalChip('ÙŠÙˆÙ…ÙŠ', 'daily'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalChip(String label, String value) {
    final isSelected = _paymentInterval == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _paymentInterval = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.goldenNeon.withOpacity(0.3),
                      AppColors.goldenNeon.withOpacity(0.1),
                    ],
                  )
                : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.goldenNeon : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.goldenNeon : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

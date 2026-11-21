import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/mock_approvals_api.dart';

/// Dialog لإنشاء طلب موافقة جديد
class CreateApprovalDialog extends StatefulWidget {
  final String requesterId;
  final String requesterName;

  const CreateApprovalDialog({
    super.key,
    required this.requesterId,
    required this.requesterName,
  });

  @override
  State<CreateApprovalDialog> createState() => _CreateApprovalDialogState();
}

class _CreateApprovalDialogState extends State<CreateApprovalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _api = MockApprovalsApi();

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Form values
  String _selectedType = 'discount';
  String _selectedPriority = 'medium';
  final Map<String, dynamic> _metadata = {};

  // Type-specific controllers
  final _discountPercentageController = TextEditingController();
  final _invoiceIdController = TextEditingController();
  final _productIdController = TextEditingController();
  final _newPriceController = TextEditingController();
  final _reasonController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _discountPercentageController.dispose();
    _invoiceIdController.dispose();
    _productIdController.dispose();
    _newPriceController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _createRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Build metadata based on type
      _buildMetadata();

      // Create request
      final result = await _api.createApprovalRequest(
        type: _selectedType,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        metadata: _metadata,
        requesterId: widget.requesterId,
        requesterName: widget.requesterName,
        priority: _selectedPriority,
        approvers: _getApprovers(),
      );

      if (result['success'] == true && mounted) {
        Navigator.of(context).pop(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء طلب الموافقة بنجاح'),
            backgroundColor: AppColors.successDark,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل إنشاء الطلب: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _buildMetadata() {
    _metadata.clear();

    switch (_selectedType) {
      case 'discount':
        _metadata['invoice_id'] = _invoiceIdController.text.trim();
        _metadata['discount_percentage'] =
            double.tryParse(_discountPercentageController.text) ?? 0.0;
        break;

      case 'price_override':
        _metadata['product_id'] = _productIdController.text.trim();
        _metadata['new_price'] =
            double.tryParse(_newPriceController.text) ?? 0.0;
        break;

      case 'return':
        _metadata['invoice_id'] = _invoiceIdController.text.trim();
        _metadata['reason'] = _reasonController.text.trim();
        break;
    }
  }

  List<Map<String, String>> _getApprovers() {
    // Simple logic: discount < 10% needs manager, >= 10% needs admin
    if (_selectedType == 'discount') {
      final percentage =
          double.tryParse(_discountPercentageController.text) ?? 0.0;
      if (percentage >= 10) {
        return [
          {'user_id': 'user_001', 'role': 'admin'},
        ];
      } else {
        return [
          {'user_id': 'user_002', 'role': 'branch_manager'},
        ];
      }
    }

    // Default: needs manager approval
    return [
      {'user_id': 'user_002', 'role': 'branch_manager'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.goldenNeon, width: 2),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'طلب موافقة جديد',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Type Selector
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  style: const TextStyle(color: AppColors.textPrimary),
                  dropdownColor: AppColors.card,
                  decoration: InputDecoration(
                    labelText: 'نوع الطلب',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.category, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'discount',
                      child: Text('خصم'),
                    ),
                    DropdownMenuItem(
                      value: 'price_override',
                      child: Text('تعديل سعر'),
                    ),
                    DropdownMenuItem(
                      value: 'return',
                      child: Text('إرجاع'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                      _updateTitle();
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Priority Selector
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  style: const TextStyle(color: AppColors.textPrimary),
                  dropdownColor: AppColors.card,
                  decoration: InputDecoration(
                    labelText: 'الأولوية',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.priority_high, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'low',
                      child: Text('منخفضة'),
                    ),
                    DropdownMenuItem(
                      value: 'medium',
                      child: Text('متوسطة'),
                    ),
                    DropdownMenuItem(
                      value: 'high',
                      child: Text('عالية'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPriority = value);
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Title
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.title, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال العنوان';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'الوصف',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.description, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الوصف';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Type-specific fields
                _buildTypeSpecificFields(),

                const SizedBox(height: 24),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _createRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.black,
                                ),
                              )
                            : const Text(
                                'إنشاء الطلب',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSpecificFields() {
    switch (_selectedType) {
      case 'discount':
        return Column(
          children: [
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            const Text(
              'تفاصيل الخصم',
              style: TextStyle(
                color: AppColors.goldenNeon,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _invoiceIdController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'رقم الفاتورة',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.receipt, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الفاتورة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountPercentageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'نسبة الخصم (%)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.percent, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال نسبة الخصم';
                }
                final percentage = double.tryParse(value);
                if (percentage == null || percentage <= 0 || percentage > 100) {
                  return 'النسبة يجب أن تكون بين 0 و 100';
                }
                return null;
              },
            ),
          ],
        );

      case 'price_override':
        return Column(
          children: [
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            const Text(
              'تفاصيل تعديل السعر',
              style: TextStyle(
                color: AppColors.goldenNeon,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productIdController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'رقم المنتج',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.inventory, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم المنتج';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'السعر الجديد (ج.م)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.price_change, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال السعر الجديد';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'السعر يجب أن يكون أكبر من 0';
                }
                return null;
              },
            ),
          ],
        );

      case 'return':
        return Column(
          children: [
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            const Text(
              'تفاصيل الإرجاع',
              style: TextStyle(
                color: AppColors.goldenNeon,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _invoiceIdController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'رقم الفاتورة',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.receipt, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الفاتورة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'سبب الإرجاع',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.note, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال سبب الإرجاع';
                }
                return null;
              },
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _updateTitle() {
    switch (_selectedType) {
      case 'discount':
        _titleController.text = 'طلب خصم على فاتورة';
        break;
      case 'price_override':
        _titleController.text = 'طلب تعديل سعر منتج';
        break;
      case 'return':
        _titleController.text = 'طلب إرجاع منتج';
        break;
    }
  }
}

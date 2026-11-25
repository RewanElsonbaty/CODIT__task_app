import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import 'package:codit/features/gold_sales/domain/gold_models.dart';

/// صفحة تفاصيل المنتج مع حساب المصنعية والخصم
class ProductDetailsPage extends StatefulWidget {
  final GoldProduct product;
  final Function(GoldProduct product, int quantity, double finalPrice)? onAddToCart;

  const ProductDetailsPage({
    super.key,
    required this.product,
    this.onAddToCart,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // Controllers
  final _goldPriceController = TextEditingController(text: '3500');
  final _weightController = TextEditingController();
  final _karatInputController = TextEditingController();
  final _discountCodeController = TextEditingController();
  final _customDiscountController = TextEditingController();

  // State variables
  Karat? _selectedKarat;
  String? _selectedSize;
  String _selectedType = 'gold'; // gold, silver, lazurde
  
  // Discount
  DiscountType _discountType = DiscountType.none;
  double _discountValue = 0.0;
  
  // Calculations
  double _makingCharge = 0.0;
  double _totalBeforeDiscount = 0.0;
  double _discountAmount = 0.0;
  double _totalAfterDiscount = 0.0;
  
  // Available sizes (من mock)
  final List<String> _availableSizes = [
    '14', '16', '18', '20', '22', // خواتم
    '45 سم', '50 سم', '55 سم', '60 سم', // سلاسل
    'Small', 'Medium', 'Large', 'XL', // عام
  ];

  // Discount presets
  final List<double> _discountPresets = [5, 10, 15, 20, 25, 30];

  @override
  void initState() {
    super.initState();
    _selectedKarat = widget.product.karat;
    _karatInputController.text = widget.product.karat.value.toString();
    _weightController.text = widget.product.netWeightGrams.toStringAsFixed(2);
    
    // Initial calculation
    _calculateMakingCharge();
  }

  @override
  void dispose() {
    _goldPriceController.dispose();
    _weightController.dispose();
    _karatInputController.dispose();
    _discountCodeController.dispose();
    _customDiscountController.dispose();
    super.dispose();
  }

  /// حساب المصنعية
  void _calculateMakingCharge() {
    try {
      final goldPrice = double.tryParse(_goldPriceController.text) ?? 0;
      final weight = double.tryParse(_weightController.text) ?? 0;
      final karat = int.tryParse(_karatInputController.text) ?? 21;
      
      if (goldPrice <= 0 || weight <= 0 || karat <= 0) {
        setState(() {
          _makingCharge = 0;
          _totalBeforeDiscount = 0;
          _applyDiscount();
        });
        return;
      }

      // المعادلة: (سعر الذهب * الوزن * العيار) / 21
      final makingCharge = (goldPrice * weight * karat) / 21;
      
      setState(() {
        _makingCharge = makingCharge;
        _totalBeforeDiscount = makingCharge;
        _applyDiscount();
      });
    } catch (e) {
      ExceptionHandler.logException(e);
      setState(() {
        _makingCharge = 0;
        _totalBeforeDiscount = 0;
        _totalAfterDiscount = 0;
      });
    }
  }

  /// تطبيق الخصم
  void _applyDiscount() {
    try {
      double discountAmount = 0;

      switch (_discountType) {
        case DiscountType.none:
          discountAmount = 0;
          break;
        
        case DiscountType.percentage:
          discountAmount = _totalBeforeDiscount * (_discountValue / 100);
          break;
        
        case DiscountType.fixed:
          discountAmount = _discountValue;
          break;
        
        case DiscountType.code:
          // تطبيق كود الخصم (من mock)
          final discount = _getDiscountFromCode(_discountCodeController.text);
          if (discount != null) {
            if (discount['type'] == 'percentage') {
              discountAmount = _totalBeforeDiscount * (discount['value'] / 100);
            } else {
              discountAmount = discount['value'];
            }
          }
          break;
      }

      setState(() {
        _discountAmount = discountAmount;
        _totalAfterDiscount = (_totalBeforeDiscount - discountAmount).clamp(0, double.infinity);
      });
    } catch (e) {
      ExceptionHandler.logException(e);
      setState(() {
        _discountAmount = 0;
        _totalAfterDiscount = _totalBeforeDiscount;
      });
    }
  }

  /// الحصول على الخصم من الكود (mock)
  Map<String, dynamic>? _getDiscountFromCode(String code) {
    // Mock discount codes
    final Map<String, Map<String, dynamic>> discountCodes = {
      'GOLD10': {'type': 'percentage', 'value': 10.0},
      'GOLD20': {'type': 'percentage', 'value': 20.0},
      'SAVE100': {'type': 'fixed', 'value': 100.0},
      'SAVE200': {'type': 'fixed', 'value': 200.0},
      'VIP': {'type': 'percentage', 'value': 25.0},
    };

    return discountCodes[code.toUpperCase()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card,
      title: const Text('تفاصيل القطعة'),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: _addToCart,
          tooltip: 'إضافة للسلة',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ResponsiveContainer(
          padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: ResponsiveUtils.spacing(context)),
              
              // Product info
              _buildProductInfo(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Type selection
              _buildTypeSelector(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Karat selection
              _buildKaratSelector(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Size selection (if applicable)
              if (_hasSizes())
                ...[
                  _buildSizeSelector(context),
                  SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
                ],
              
              // Weight input
              _buildWeightInput(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Making charge formula
              _buildMakingChargeFormula(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Discount section
              _buildDiscountSection(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Price summary
              _buildPriceSummary(context),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenNeon.withOpacity(0.1),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 2),
        border: Border.all(
          color: AppColors.goldenNeon.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                decoration: BoxDecoration(
                  color: AppColors.goldenNeon.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
                ),
                child: Icon(
                  Icons.diamond,
                  color: AppColors.goldenNeon,
                  size: ResponsiveUtils.iconSize(context) * 1.5,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, factor: 1.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.textSizeLarge(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
                    Text(
                      'كود: ${widget.product.code}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.textSizeSmall(context),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 1.5)),
          const Divider(color: AppColors.border),
          SizedBox(height: ResponsiveUtils.spacing(context)),
          _buildInfoRow('الفئة', widget.product.category),
          _buildInfoRow('الوزن القائم', '${widget.product.grossWeightGrams.toStringAsFixed(2)} جم'),
          _buildInfoRow('وزن الفصوص', '${widget.product.stonesWeightGrams.toStringAsFixed(2)} جم'),
          _buildInfoRow('الوزن الصافي', '${widget.product.netWeightGrams.toStringAsFixed(2)} جم'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.spacing(context, factor: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveUtils.textSizeMedium(context),
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveUtils.textSizeMedium(context),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'النوع',
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context)),
        ResponsiveLayout(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _buildTypeButton('gold', 'ذهب', '🟡')),
            SizedBox(
              width: ResponsiveUtils.spacing(context),
              height: ResponsiveUtils.spacing(context),
            ),
            Expanded(child: _buildTypeButton('silver', 'فضة', '⚪')),
            SizedBox(
              width: ResponsiveUtils.spacing(context),
              height: ResponsiveUtils.spacing(context),
            ),
            Expanded(child: _buildTypeButton('lazurde', 'لازوردي', '💎')),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(String type, String label, String icon) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          if (type == 'silver') {
            _selectedKarat = null;
            _karatInputController.clear();
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.spacing(context, factor: 1.5),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldenNeon.withOpacity(0.2) : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
          border: Border.all(
            color: isSelected ? AppColors.goldenNeon : AppColors.border.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: ResponsiveUtils.textSizeLarge(context) * 1.5),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUtils.textSizeSmall(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.goldenNeon : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKaratSelector(BuildContext context) {
    if (_selectedType == 'silver') {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العيار',
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context)),
        ResponsiveLayout(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _buildKaratButton(Karat.k18),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context),
              height: ResponsiveUtils.spacing(context),
            ),
            Expanded(
              child: _buildKaratButton(Karat.k21),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context),
              height: ResponsiveUtils.spacing(context),
            ),
            Expanded(
              child: _buildKaratButton(Karat.k24),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKaratButton(Karat karat) {
    final isSelected = _selectedKarat == karat;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKarat = karat;
          _karatInputController.text = karat.value.toString();
          _calculateMakingCharge();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.spacing(context, factor: 1.5),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldenNeon.withOpacity(0.2) : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
          border: Border.all(
            color: isSelected ? AppColors.goldenNeon : AppColors.border.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            karat.displayName,
            style: TextStyle(
              fontSize: ResponsiveUtils.textSizeMedium(context),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.goldenNeon : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  bool _hasSizes() {
    // Rings and bracelets usually have sizes
    final category = widget.product.category.toLowerCase();
    return category.contains('خاتم') || 
           category.contains('أسو') || 
           category.contains('سلسل') ||
           category.contains('ring') ||
           category.contains('bracelet') ||
           category.contains('chain');
  }

  Widget _buildSizeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المقاس',
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context)),
        DropdownButtonFormField<String>(
          value: _selectedSize,
          decoration: InputDecoration(
            hintText: 'اختر المقاس',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.straighten, color: AppColors.goldenNeon),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: AppColors.card,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.textSizeMedium(context),
          ),
          items: _availableSizes.map((size) {
            return DropdownMenuItem(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSize = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeightInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الوزن (جرام)',
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context)),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.textSizeMedium(context),
          ),
          decoration: InputDecoration(
            hintText: 'أدخل الوزن',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.balance, color: AppColors.goldenNeon),
            suffixText: 'جم',
            suffixStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
              borderSide: BorderSide.none,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          onChanged: (value) {
            _calculateMakingCharge();
          },
        ),
      ],
    );
  }

  Widget _buildMakingChargeFormula(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 2),
        border: Border.all(
          color: AppColors.goldenNeon.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: AppColors.goldenNeon,
                size: ResponsiveUtils.iconSize(context),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context)),
              Text(
                'معادلة المصنعية',
                style: TextStyle(
                  fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 1.5)),
          
          // Formula inputs
          ResponsiveLayout(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Input 1: Gold Price
              Expanded(
                child: _buildFormulaInput(
                  controller: _goldPriceController,
                  label: 'سعر الذهب',
                  hint: '3500',
                  enabled: true,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context),
                height: ResponsiveUtils.spacing(context),
              ),
              
              // Input 2: Fixed 21 (tooltip)
              Expanded(
                child: Tooltip(
                  message: 'ثابت العيار (21)',
                  child: _buildFormulaInput(
                    controller: TextEditingController(text: '21'),
                    label: 'ثابت',
                    hint: '21',
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context),
                height: ResponsiveUtils.spacing(context),
              ),
              
              // Input 3: Karat (dropdown or input)
              Expanded(
                child: _buildFormulaInput(
                  controller: _karatInputController,
                  label: 'العيار',
                  hint: '21',
                  enabled: true,
                  hasDropdown: true,
                ),
              ),
            ],
          ),
          
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 1.5)),
          
          // Formula display
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            decoration: BoxDecoration(
              color: AppColors.goldenNeon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
            ),
            child: Column(
              children: [
                Text(
                  'المعادلة:',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.textSizeSmall(context),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
                Text(
                  '(سعر الذهب × الوزن × العيار) ÷ 21',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.textSizeMedium(context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldenNeon,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool enabled,
    bool hasDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeSmall(context),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
        hasDropdown
            ? DropdownButtonFormField<int>(
                value: int.tryParse(controller.text),
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: enabled ? AppColors.background : AppColors.border.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(context),
                    vertical: ResponsiveUtils.spacing(context),
                  ),
                ),
                dropdownColor: AppColors.card,
                items: [18, 21, 24].map((karat) {
                  return DropdownMenuItem(
                    value: karat,
                    child: Text(
                      karat.toString(),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: enabled
                    ? (value) {
                        if (value != null) {
                          controller.text = value.toString();
                          _calculateMakingCharge();
                        }
                      }
                    : null,
              )
            : TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: ResponsiveUtils.textSizeMedium(context),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: enabled ? AppColors.background : AppColors.border.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(context, factor: 0.5),
                    vertical: ResponsiveUtils.spacing(context),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: enabled ? (value) => _calculateMakingCharge() : null,
              ),
      ],
    );
  }

  Widget _buildDiscountSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 2),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer,
                color: AppColors.warning,
                size: ResponsiveUtils.iconSize(context),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context)),
              Text(
                'الخصم',
                style: TextStyle(
                  fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 1.5)),
          
          // Discount type selector
          Wrap(
            spacing: ResponsiveUtils.spacing(context),
            runSpacing: ResponsiveUtils.spacing(context),
            children: [
              _buildDiscountTypeChip(DiscountType.none, 'بدون'),
              _buildDiscountTypeChip(DiscountType.percentage, 'نسبة %'),
              _buildDiscountTypeChip(DiscountType.fixed, 'مبلغ ثابت'),
              _buildDiscountTypeChip(DiscountType.code, 'كود خصم'),
            ],
          ),
          
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 1.5)),
          
          // Discount input based on type
          if (_discountType == DiscountType.percentage)
            _buildPercentageDiscountInput(context),
          
          if (_discountType == DiscountType.fixed)
            _buildFixedDiscountInput(context),
          
          if (_discountType == DiscountType.code)
            _buildDiscountCodeInput(context),
        ],
      ),
    );
  }

  Widget _buildDiscountTypeChip(DiscountType type, String label) {
    final isSelected = _discountType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _discountType = type;
          _discountValue = 0;
          _discountCodeController.clear();
          _customDiscountController.clear();
          _applyDiscount();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, factor: 1.5),
          vertical: ResponsiveUtils.spacing(context),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warning.withOpacity(0.2) : AppColors.background,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 1.5),
          border: Border.all(
            color: isSelected ? AppColors.warning : AppColors.border.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeSmall(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.warning : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPercentageDiscountInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نسبة الخصم',
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeSmall(context),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
        
        // Preset buttons
        Wrap(
          spacing: ResponsiveUtils.spacing(context, factor: 0.5),
          runSpacing: ResponsiveUtils.spacing(context, factor: 0.5),
          children: _discountPresets.map((preset) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _discountValue = preset;
                  _customDiscountController.text = preset.toString();
                  _applyDiscount();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(context),
                  vertical: ResponsiveUtils.spacing(context, factor: 0.5),
                ),
                decoration: BoxDecoration(
                  color: _discountValue == preset
                      ? AppColors.warning.withOpacity(0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
                  border: Border.all(
                    color: _discountValue == preset
                        ? AppColors.warning
                        : AppColors.border.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '$preset%',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.textSizeSmall(context),
                    color: _discountValue == preset
                        ? AppColors.warning
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        SizedBox(height: ResponsiveUtils.spacing(context)),
        
        // Custom input
        TextField(
          controller: _customDiscountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'أو أدخل نسبة مخصصة',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            suffixText: '%',
            suffixStyle: const TextStyle(color: AppColors.warning),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
              borderSide: BorderSide.none,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          onChanged: (value) {
            final discount = double.tryParse(value) ?? 0;
            setState(() {
              _discountValue = discount.clamp(0, 100);
              _applyDiscount();
            });
          },
        ),
      ],
    );
  }

  Widget _buildFixedDiscountInput(BuildContext context) {
    return TextField(
      controller: _customDiscountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'مبلغ الخصم',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintText: 'أدخل مبلغ الخصم',
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        suffixText: 'جنيه',
        suffixStyle: const TextStyle(color: AppColors.warning),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
          borderSide: BorderSide.none,
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: (value) {
        final discount = double.tryParse(value) ?? 0;
        setState(() {
          _discountValue = discount;
          _applyDiscount();
        });
      },
    );
  }

  Widget _buildDiscountCodeInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _discountCodeController,
          style: const TextStyle(color: AppColors.textPrimary),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'كود الخصم',
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            hintText: 'مثال: GOLD10',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.card_giftcard, color: AppColors.warning),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _applyDiscount();
            });
          },
        ),
        SizedBox(height: ResponsiveUtils.spacing(context)),
        
        // Available codes hint
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أكواد متاحة:',
                style: TextStyle(
                  fontSize: ResponsiveUtils.textSizeSmall(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
              Text(
                'GOLD10 (10%), GOLD20 (20%), SAVE100 (100 جنيه), VIP (25%)',
                style: TextStyle(
                  fontSize: ResponsiveUtils.textSizeSmall(context),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 2),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: AppColors.success,
                size: ResponsiveUtils.iconSize(context),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context)),
              Text(
                'ملخص السعر',
                style: TextStyle(
                  fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 1.5)),
          
          // Before discount
          _buildPriceRow(
            'المصنعية',
            _makingCharge,
            isTotal: false,
          ),
          
          if (_discountAmount > 0) ...[
            SizedBox(height: ResponsiveUtils.spacing(context)),
            _buildPriceRow(
              'الخصم',
              -_discountAmount,
              color: AppColors.error,
              isTotal: false,
            ),
            SizedBox(height: ResponsiveUtils.spacing(context)),
            const Divider(color: AppColors.border),
          ],
          
          SizedBox(height: ResponsiveUtils.spacing(context)),
          
          // Final total
          _buildPriceRow(
            'الإجمالي',
            _totalAfterDiscount,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {Color? color, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal 
                ? ResponsiveUtils.textSizeMedium(context) * 1.2
                : ResponsiveUtils.textSizeMedium(context),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} جنيه',
          style: TextStyle(
            fontSize: isTotal 
                ? ResponsiveUtils.textSizeLarge(context) * 1.2
                : ResponsiveUtils.textSizeMedium(context),
            fontWeight: FontWeight.bold,
            color: color ?? (isTotal ? AppColors.success : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإجمالي',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.textSizeSmall(context),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${_totalAfterDiscount.toStringAsFixed(2)} جنيه',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.textSizeLarge(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, factor: 2)),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _canAddToCart() ? _addToCart : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('إضافة للسلة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.spacing(context, factor: 1.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canAddToCart() {
    return _totalAfterDiscount > 0 &&
           (_selectedType != 'silver' ? _selectedKarat != null : true) &&
           double.tryParse(_weightController.text) != null &&
           double.parse(_weightController.text) > 0;
  }

  void _addToCart() {
    if (!_canAddToCart()) {
      return;
    }

    try {
      if (widget.onAddToCart != null) {
        widget.onAddToCart!(widget.product, 1, _totalAfterDiscount);
      }
      
      if (mounted) {
        // Return the quantity data to the calling dialog
        Navigator.of(context).pop({
          'quantity': 1, // Currently always 1, can be extended later
          'price': _totalAfterDiscount,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'تمت إضافة ${widget.product.name} بنجاح',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.successDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ExceptionHandler.logException(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الإضافة: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    }
  }
}

/// أنواع الخصم
enum DiscountType {
  none,
  percentage,
  fixed,
  code,
}

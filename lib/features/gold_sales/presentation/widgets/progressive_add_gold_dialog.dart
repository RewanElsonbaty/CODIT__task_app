import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/features/gold_sales/domain/gold_models.dart';
import 'package:codit/features/gold_sales/domain/product_categories.dart';
import 'package:codit/features/gold_sales/presentation/pages/product_details_page.dart';

/// Dialog متعدد المراحل لإضافة قطعة ذهب
/// 
/// المراحل:
/// 1. اختيار الفئة (خاتم، سلسلة، إلخ) - بالبحث
/// 2. اختيار النوع (ذهب، فضة، لازوردي)
/// 3. فلترة حسب العيار والوزن
/// 4. اختيار القطعة النهائية
class ProgressiveAddGoldDialog extends StatefulWidget {
  final List<GoldProduct> availableProducts;
  final Function(GoldProduct product, int quantity) onAddItem;

  const ProgressiveAddGoldDialog({
    super.key,
    required this.availableProducts,
    required this.onAddItem,
  });

  @override
  State<ProgressiveAddGoldDialog> createState() => _ProgressiveAddGoldDialogState();
}

class _ProgressiveAddGoldDialogState extends State<ProgressiveAddGoldDialog> {
  // Controllers
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  // Current step (0-3)
  int _currentStep = 0;

  // Selections
  ProductCategory? _selectedCategory;
  ProductType? _selectedType;
  Karat? _selectedKarat;
  RangeValues _weightRange = const RangeValues(0, 100); // بالجرام
  GoldProduct? _selectedProduct;
  int _quantity = 1;

  // Filtered lists
  List<ProductCategory> _filteredCategories = ProductCategories.all;
  List<GoldProduct> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _calculateWeightRange();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _calculateWeightRange() {
    if (widget.availableProducts.isEmpty) return;
    
    final weights = widget.availableProducts
        .map((p) => p.netWeightGrams)
        .toList()
      ..sort();
    
    setState(() {
      _weightRange = RangeValues(
        weights.first.floorToDouble(),
        weights.last.ceilToDouble(),
      );
    });
  }

  void _onSearchChanged() {
    if (_currentStep == 0) {
      setState(() {
        _filteredCategories = ProductCategories.search(_searchController.text);
      });
    }
  }

  void _selectCategory(ProductCategory category) {
    setState(() {
      _selectedCategory = category;
      _currentStep = 1;
      _searchController.clear();
    });
  }

  void _selectType(ProductType type) {
    setState(() {
      _selectedType = type;
      _currentStep = 2;
      if (!type.hasKarat) {
        _selectedKarat = null;
      }
    });
  }

  void _applyFilters() {
    if (_selectedCategory == null) return;

    setState(() {
      _filteredProducts = widget.availableProducts.where((product) {
        // فلتر الحالة - فقط المنتجات المتاحة
        if (!product.status.canSell) {
          return false;
        }

        // فلتر الفئة (category) - تطابق ذكي
        if (!_matchesCategory(product.category, _selectedCategory!)) {
          return false;
        }

        // فلتر النوع (type) - ذهب/فضة/لازوردي
        if (_selectedType != null && !_matchesType(product, _selectedType!)) {
          return false;
        }

        // فلتر العيار
        if (_selectedKarat != null && product.karat != _selectedKarat) {
          return false;
        }

        // فلتر الوزن
        final weight = product.netWeightGrams;
        if (weight < _weightRange.start || weight > _weightRange.end) {
          return false;
        }

        return true;
      }).toList();

      _currentStep = 3;
    });
  }

  /// تحقق من تطابق الفئة
  bool _matchesCategory(String productCategory, ProductCategory selectedCategory) {
    final productCat = productCategory.toLowerCase().trim();
    final selectedId = selectedCategory.id.toLowerCase();
    final selectedNameAr = selectedCategory.nameAr.toLowerCase();
    
    // تطابق مباشر
    if (productCat == selectedNameAr || productCat.contains(selectedNameAr)) {
      return true;
    }
    
    // تطابق ID (مثل: rings → خواتم)
    final Map<String, List<String>> categoryMapping = {
      'rings': ['خواتم', 'خاتم', 'دبل', 'دبلة'],
      'necklaces': ['سلاسل', 'سلسلة', 'عقد'],
      'bracelets': ['أساور', 'أسورة', 'سوار'],
      'earrings': ['أقراط', 'قرط', 'حلق'],
      'wedding_bands': ['دبل', 'دبلة'],
      'sets': ['طقم', 'أطقم'],
      'brooches': ['توك', 'توكة', 'دبوس'],
      'anklets': ['غوايش', 'غويشة', 'خلخال'],
    };
    
    if (categoryMapping.containsKey(selectedId)) {
      return categoryMapping[selectedId]!.any((term) => productCat.contains(term));
    }
    
    return false;
  }

  /// تحقق من تطابق النوع (ذهب/فضة/لازوردي)
  bool _matchesType(GoldProduct product, ProductType selectedType) {
    // حالياً نفترض أن كل المنتجات ذهب
    // في المستقبل يمكن إضافة حقل type في GoldProduct
    
    // إذا كان النوع فضة أو لازوردي، نتحقق من الاسم
    if (selectedType.id == 'silver') {
      return product.name.toLowerCase().contains('فضة') ||
             product.name.toLowerCase().contains('silver');
    }
    
    if (selectedType.id == 'lazurde') {
      return product.name.toLowerCase().contains('لازورد') ||
             product.name.toLowerCase().contains('lazurde');
    }
    
    // افتراضي: ذهب
    return true;
  }

  void _selectProduct(GoldProduct product) async {
    // Navigate to ProductDetailsPage
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );

    // If user added the product from details page, close the dialog and pass the data
    if (result != null && mounted) {
      final quantity = result['quantity'] as int? ?? 1;
      widget.onAddItem(product, quantity);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _confirmAddition() {
    if (_selectedProduct == null || _quantity <= 0) {
      return;
    }

    try {
      widget.onAddItem(_selectedProduct!, _quantity);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'تم إضافة ${_selectedProduct!.name} (x$_quantity) بنجاح',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.successDark,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'خطأ في إضافة القطعة: $e',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
        
        // إعادة تعيين الاختيارات حسب المرحلة
        switch (_currentStep) {
          case 0:
            _selectedCategory = null;
            _selectedType = null;
            _selectedKarat = null;
            _selectedProduct = null;
            break;
          case 1:
            _selectedType = null;
            _selectedKarat = null;
            _selectedProduct = null;
            break;
          case 2:
            _selectedKarat = null;
            _selectedProduct = null;
            _filteredProducts.clear();
            break;
          case 3:
            _selectedProduct = null;
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.goldenNeon, width: 2),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.valueWhen(
            context: context,
            mobile: double.infinity,
            tablet: 700,
            desktop: 900,
          ),
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with progress
            _buildHeader(context),
            
            // Progress indicator
            _buildProgressIndicator(context),
            
            // Content based on step
            Expanded(
              child: _buildStepContent(context, isMobile),
            ),
            
            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final stepTitles = [
      'اختر الفئة',
      'اختر النوع',
      'حدد المواصفات',
      'اختر القطعة',
    ];

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenNeon.withOpacity(0.2),
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back),
              color: AppColors.goldenNeon,
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.goldenNeon.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_shopping_cart,
              color: AppColors.goldenNeon,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إضافة قطعة ذهب',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.textSizeLarge(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stepTitles[_currentStep],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.textSizeSmall(context),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
        vertical: ResponsiveUtils.spacing(context),
      ),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(context) / 2,
              ),
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? AppColors.goldenNeon
                    : AppColors.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, bool isMobile) {
    switch (_currentStep) {
      case 0:
        return _buildCategorySelection(context, isMobile);
      case 1:
        return _buildTypeSelection(context, isMobile);
      case 2:
        return _buildFilterSelection(context, isMobile);
      case 3:
        return _buildProductSelection(context, isMobile);
      default:
        return const SizedBox();
    }
  }

  // ========== المرحلة 1: اختيار الفئة ==========
  Widget _buildCategorySelection(BuildContext context, bool isMobile) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'ابحث... (مثال: r أو ر للخواتم، c أو س للسلاسل)',
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: AppColors.goldenNeon),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.goldenNeon, width: 2),
              ),
            ),
          ),
        ),

        // Categories grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 3,
              childAspectRatio: isMobile ? 1.0 : 1.1,
              crossAxisSpacing: ResponsiveUtils.spacing(context),
              mainAxisSpacing: ResponsiveUtils.spacing(context),
            ),
            itemCount: _filteredCategories.length,
            itemBuilder: (context, index) {
              final category = _filteredCategories[index];
              return _buildCategoryCard(category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(ProductCategory category) {
    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 40),
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  category.nameAr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  category.nameEn,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== المرحلة 2: اختيار النوع ==========
  Widget _buildTypeSelection(BuildContext context, bool isMobile) {
    if (_selectedCategory == null) return const SizedBox();

    return Column(
      children: [
        // Selected category info
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
          child: Row(
            children: [
              Text(
                _selectedCategory!.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCategory!.nameAr,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'اختر نوع ${_selectedCategory!.nameAr}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(color: AppColors.border),

        // Types list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
            itemCount: _selectedCategory!.types.length,
            itemBuilder: (context, index) {
              final type = _selectedCategory!.types[index];
              return _buildTypeCard(type);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(ProductType type) {
    return GestureDetector(
      onTap: () => _selectType(type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              type.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.nameAr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    type.nameEn,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ========== المرحلة 3: فلترة حسب العيار والوزن ==========
  Widget _buildFilterSelection(BuildContext context, bool isMobile) {
    if (_selectedCategory == null || _selectedType == null) return const SizedBox();

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected info
          _buildSelectedInfo(),

          const SizedBox(height: 24),
          const Divider(color: AppColors.border),
          const SizedBox(height: 24),

          // Karat filter (if applicable)
          if (_selectedType!.hasKarat) ...[
            const Text(
              'العيار',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildKaratChip(null, 'الكل'),
                ...Karat.values.map((karat) => _buildKaratChip(karat, karat.displayName)),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Weight range filter
          const Text(
            'نطاق الوزن (جرام)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'من ${_weightRange.start.toStringAsFixed(1)} جم إلى ${_weightRange.end.toStringAsFixed(1)} جم',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          RangeSlider(
            values: _weightRange,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: AppColors.goldenNeon,
            inactiveColor: AppColors.border.withOpacity(0.3),
            onChanged: (values) {
              setState(() {
                _weightRange = values;
              });
            },
          ),

          const SizedBox(height: 32),

          // Apply filters button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenNeon,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'عرض النتائج',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenNeon.withOpacity(0.1),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            _selectedCategory!.icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Text(
            _selectedType!.icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedCategory!.nameAr} ${_selectedType!.nameAr}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_selectedCategory!.nameEn} ${_selectedType!.nameEn}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaratChip(Karat? karat, String label) {
    final isSelected = _selectedKarat == karat;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKarat = karat;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldenNeon.withOpacity(0.2) : AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.goldenNeon : AppColors.border.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.goldenNeon : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ========== المرحلة 4: اختيار القطعة ==========
  Widget _buildProductSelection(BuildContext context, bool isMobile) {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد قطع متاحة بهذه المواصفات',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('تعديل الفلتر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Results count
        Padding(
          padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
          child: Row(
            children: [
              Text(
                'النتائج: ${_filteredProducts.length} قطعة',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _goBack,
                icon: const Icon(Icons.tune, color: AppColors.goldenNeon),
                label: const Text(
                  'تعديل',
                  style: TextStyle(color: AppColors.goldenNeon),
                ),
              ),
            ],
          ),
        ),

        // Products grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              childAspectRatio: isMobile ? 2 : 1.5,
              crossAxisSpacing: ResponsiveUtils.spacing(context),
              mainAxisSpacing: ResponsiveUtils.spacing(context),
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              final isSelected = _selectedProduct?.code == product.code;
              return _buildProductCard(product, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(GoldProduct product, bool isSelected) {
    final netWeightG = product.netWeightGrams;

    return GestureDetector(
      onTap: () => _selectProduct(product),
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.goldenNeon.withOpacity(0.3),
                    AppColors.goldenNeon.withOpacity(0.1),
                  ],
                )
              : null,
          color: isSelected ? null : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.goldenNeon : AppColors.border.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.goldenGlow.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Name and code
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.goldenNeon,
                          size: 20,
                        ),
                      if (isSelected) const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'كود: ${product.code}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Details
              Column(
                children: [
                  _buildInfoRow(Icons.balance, 'الوزن', '${netWeightG.toStringAsFixed(2)} جم'),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.diamond, 'العيار', product.karat.displayName),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.category, 'الفئة', product.category),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
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
      ),
      child: Row(
        children: [
          // Quantity selector (only on step 3 with selected product)
          if (_currentStep == 3 && _selectedProduct != null) ...[
            Expanded(
              child: Row(
                children: [
                  const Text(
                    'الكمية: ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                          _quantityController.text = _quantity.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.goldenNeon,
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        final qty = int.tryParse(value) ?? 1;
                        setState(() {
                          _quantity = qty.clamp(1, 999);
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity++;
                        _quantityController.text = _quantity.toString();
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.goldenNeon,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Confirm button
          if (_currentStep == 3 && _selectedProduct != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _confirmAddition,
                icon: const Icon(Icons.check),
                label: const Text('تأكيد الإضافة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          // Cancel button
          if (_currentStep != 3 || _selectedProduct == null)
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

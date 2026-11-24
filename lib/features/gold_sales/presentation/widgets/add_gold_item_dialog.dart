import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/features/gold_sales/domain/gold_models.dart';

/// Dialog لإضافة قطعة ذهب مع خيارات متعددة
class AddGoldItemDialog extends StatefulWidget {
  /// قائمة القطع المتاحة
  final List<GoldProduct> availableProducts;
  
  /// Callback عند إضافة قطعة
  final Function(GoldProduct product, int quantity) onAddItem;

  const AddGoldItemDialog({
    super.key,
    required this.availableProducts,
    required this.onAddItem,
  });

  @override
  State<AddGoldItemDialog> createState() => _AddGoldItemDialogState();
}

class _AddGoldItemDialogState extends State<AddGoldItemDialog> {
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  
  List<GoldProduct> _filteredProducts = [];
  GoldProduct? _selectedProduct;
  int _quantity = 1;
  
  // فلاتر
  Karat? _selectedKarat;
  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.availableProducts;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredProducts = widget.availableProducts.where((product) {
        // فلتر البحث
        final matchesSearch = query.isEmpty ||
            product.name.toLowerCase().contains(query) ||
            product.code.toLowerCase().contains(query) ||
            product.barcode.toLowerCase().contains(query);
        
        // فلتر العيار
        final matchesKarat = _selectedKarat == null || 
            product.karat == _selectedKarat;
        
        // فلتر الفئة
        final matchesCategory = _selectedCategory == null ||
            product.category == _selectedCategory;
        
        return matchesSearch && matchesKarat && matchesCategory;
      }).toList();
    });
  }

  void _addSelectedProduct() {
    if (_selectedProduct != null && _quantity > 0) {
      widget.onAddItem(_selectedProduct!, _quantity);
      
      // إعادة تعيين الاختيار
      setState(() {
        _selectedProduct = null;
        _quantity = 1;
        _quantityController.text = '1';
      });
      
      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم إضافة ${_selectedProduct!.name} (x$_quantity)',
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
            // Header
            _buildHeader(context),
            
            // Filters Section
            _buildFilters(context, isMobile),
            
            // Search Bar
            _buildSearchBar(context),
            
            // Products Grid/List
            Expanded(
              child: _buildProductsList(context, isMobile),
            ),
            
            // Selected Product Summary
            if (_selectedProduct != null)
              _buildSelectedSummary(context, isMobile),
            
            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'اختر القطعة وحدد الكمية',
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

  Widget _buildFilters(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
        vertical: ResponsiveUtils.spacing(context),
      ),
      child: ResponsiveLayout(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // فلتر العيار
          Expanded(
            child: _buildKaratFilter(),
          ),
          SizedBox(
            width: isMobile ? 0 : ResponsiveUtils.spacing(context),
            height: isMobile ? ResponsiveUtils.spacing(context) : 0,
          ),
          // فلتر الفئة
          Expanded(
            child: _buildCategoryFilter(),
          ),
        ],
      ),
    );
  }

  Widget _buildKaratFilter() {
    return DropdownButtonFormField<Karat?>(
      value: _selectedKarat,
      decoration: InputDecoration(
        labelText: 'العيار',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.filter_alt, color: AppColors.goldenNeon),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: AppColors.card,
      style: const TextStyle(color: AppColors.textPrimary),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('الكل'),
        ),
        ...Karat.values.map((karat) => DropdownMenuItem(
              value: karat,
              child: Text(karat.displayName),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedKarat = value;
          _filterProducts();
        });
      },
    );
  }

  Widget _buildCategoryFilter() {
    final categories = widget.availableProducts
        .map((p) => p.category)
        .toSet()
        .toList();
    
    return DropdownButtonFormField<String?>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'الفئة',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.category, color: AppColors.goldenNeon),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: AppColors.card,
      style: const TextStyle(color: AppColors.textPrimary),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('الكل'),
        ),
        ...categories.map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
          _filterProducts();
        });
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
        vertical: ResponsiveUtils.spacing(context),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'ابحث بالاسم، الكود أو الباركود...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
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
    );
  }

  Widget _buildProductsList(BuildContext context, bool isMobile) {
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
              'لا توجد قطع متاحة',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.valueWhen(
          context: context,
          mobile: 1,
          tablet: 2,
          desktop: 3,
        ),
        childAspectRatio: isMobile ? 1.8 : 1.5,
        crossAxisSpacing: ResponsiveUtils.spacing(context),
        mainAxisSpacing: ResponsiveUtils.spacing(context),
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        final isSelected = _selectedProduct?.code == product.code;
        
        return _buildProductCard(product, isSelected);
      },
    );
  }

  Widget _buildProductCard(GoldProduct product, bool isSelected) {
    final netWeightG = (product.grossWeightMg - product.stonesWeightMg) / 1000;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedProduct = null;
          } else {
            _selectedProduct = product;
          }
        });
      },
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
        child: Stack(
          children: [
            // محتوى البطاقة
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الاسم والكود
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'كود: ${product.code}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  
                  // التفاصيل
                  Column(
                    children: [
                      _buildInfoRow(
                        Icons.balance,
                        'الوزن الصافي',
                        '${netWeightG.toStringAsFixed(2)} جم',
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.diamond,
                        'العيار',
                        product.karat.displayName,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.category,
                        'الفئة',
                        product.category,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // علامة الاختيار
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.goldenNeon,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.goldenNeon),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSummary(BuildContext context, bool isMobile) {
    if (_selectedProduct == null) return const SizedBox.shrink();
    
    final netWeightG = (_selectedProduct!.grossWeightMg - 
        _selectedProduct!.stonesWeightMg) / 1000;
    
    return Container(
      margin: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 1.5)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.successDark.withOpacity(0.2),
            AppColors.successDark.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.successLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.successLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'القطعة المختارة',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          ResponsiveLayout(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // معلومات القطعة
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedProduct!.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedProduct!.karat.displayName} • ${netWeightG.toStringAsFixed(2)} جم',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(
                width: isMobile ? 0 : ResponsiveUtils.spacing(context),
                height: isMobile ? ResponsiveUtils.spacing(context) : 0,
              ),
              
              // اختيار الكمية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الكمية',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر تقليل
                        IconButton(
                          onPressed: _quantity > 1
                              ? () {
                                  setState(() {
                                    _quantity--;
                                    _quantityController.text = _quantity.toString();
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove),
                          color: AppColors.goldenNeon,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.card,
                            disabledBackgroundColor: AppColors.card.withOpacity(0.5),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        
                        // حقل الكمية
                        Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            controller: _quantityController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.card,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                            ),
                            onChanged: (value) {
                              final qty = int.tryParse(value) ?? 1;
                              setState(() {
                                _quantity = qty > 0 ? qty : 1;
                              });
                            },
                          ),
                        ),
                        
                        // زر زيادة
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity++;
                              _quantityController.text = _quantity.toString();
                            });
                          },
                          icon: const Icon(Icons.add),
                          color: AppColors.goldenNeon,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.card,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          // زر إضافة ومتابعة
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _selectedProduct != null ? _addSelectedProduct : null,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('إضافة ومتابعة الشراء'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenNeon,
                foregroundColor: Colors.black,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.textSecondary,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.spacing(context, factor: 1.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // زر إضافة وإنهاء
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _selectedProduct != null
                  ? () {
                      _addSelectedProduct();
                      Navigator.of(context).pop();
                    }
                  : null,
              icon: const Icon(Icons.done),
              label: const Text('إضافة وإنهاء'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.textSecondary,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.spacing(context, factor: 1.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

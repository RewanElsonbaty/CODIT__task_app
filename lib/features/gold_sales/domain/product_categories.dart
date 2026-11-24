/// نظام تصنيف المنتجات مع دعم البحث بالعربي والإنجليزي
class ProductCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<String> searchTermsAr;  // مصطلحات البحث بالعربي
  final List<String> searchTermsEn;  // مصطلحات البحث بالإنجليزي
  final String icon;
  final List<ProductType> types;

  const ProductCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.searchTermsAr,
    required this.searchTermsEn,
    required this.icon,
    required this.types,
  });

  /// تحقق من تطابق البحث (عربي أو إنجليزي)
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    
    // بحث في الأسماء
    if (nameAr.toLowerCase().contains(lowerQuery) ||
        nameEn.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // بحث في المصطلحات العربية
    if (searchTermsAr.any((term) => term.toLowerCase().contains(lowerQuery))) {
      return true;
    }
    
    // بحث في المصطلحات الإنجليزية
    if (searchTermsEn.any((term) => term.toLowerCase().contains(lowerQuery))) {
      return true;
    }
    
    return false;
  }
}

/// نوع المنتج (ذهب، فضة، لازوردي، إلخ)
class ProductType {
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final bool hasKarat;  // هل يحتاج عيار (ذهب نعم، فضة لا)

  const ProductType({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    this.hasKarat = true,
  });
}

/// قائمة الفئات المتاحة
class ProductCategories {
  static const List<ProductCategory> all = [
    // خواتم / Rings
    ProductCategory(
      id: 'rings',
      nameAr: 'خواتم',
      nameEn: 'Rings',
      searchTermsAr: ['خاتم', 'خواتم', 'خ'],
      searchTermsEn: ['ring', 'rings', 'r'],
      icon: '💍',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
        ProductType(id: 'lazurde', nameAr: 'لازوردي', nameEn: 'Lazurde', icon: '💎', hasKarat: true),
      ],
    ),

    // سلاسل / Chains/Necklaces
    ProductCategory(
      id: 'necklaces',
      nameAr: 'سلاسل',
      nameEn: 'Chains',
      searchTermsAr: ['سلسلة', 'سلاسل', 'عقد', 'س'],
      searchTermsEn: ['chain', 'chains', 'necklace', 'necklaces', 'c', 'n'],
      icon: '📿',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
        ProductType(id: 'lazurde', nameAr: 'لازوردي', nameEn: 'Lazurde', icon: '💎', hasKarat: true),
      ],
    ),

    // أساور / Bracelets
    ProductCategory(
      id: 'bracelets',
      nameAr: 'أساور',
      nameEn: 'Bracelets',
      searchTermsAr: ['سوار', 'أساور', 'اساور', 'ا'],
      searchTermsEn: ['bracelet', 'bracelets', 'bangle', 'bangles', 'b'],
      icon: '🔗',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
        ProductType(id: 'lazurde', nameAr: 'لازوردي', nameEn: 'Lazurde', icon: '💎', hasKarat: true),
      ],
    ),

    // أقراط / Earrings
    ProductCategory(
      id: 'earrings',
      nameAr: 'أقراط',
      nameEn: 'Earrings',
      searchTermsAr: ['قرط', 'أقراط', 'حلق', 'ق'],
      searchTermsEn: ['earring', 'earrings', 'e'],
      icon: '👂',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
        ProductType(id: 'lazurde', nameAr: 'لازوردي', nameEn: 'Lazurde', icon: '💎', hasKarat: true),
      ],
    ),

    // دبل / Wedding Bands
    ProductCategory(
      id: 'wedding_bands',
      nameAr: 'دبل',
      nameEn: 'Wedding Bands',
      searchTermsAr: ['دبلة', 'دبل', 'د'],
      searchTermsEn: ['wedding', 'band', 'bands', 'w'],
      icon: '💑',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
      ],
    ),

    // طقم / Sets
    ProductCategory(
      id: 'sets',
      nameAr: 'طقم',
      nameEn: 'Sets',
      searchTermsAr: ['طقم', 'أطقم', 'ط'],
      searchTermsEn: ['set', 'sets', 's'],
      icon: '📦',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
        ProductType(id: 'lazurde', nameAr: 'لازوردي', nameEn: 'Lazurde', icon: '💎', hasKarat: true),
      ],
    ),

    // توك / Brooches
    ProductCategory(
      id: 'brooches',
      nameAr: 'توك',
      nameEn: 'Brooches',
      searchTermsAr: ['توكة', 'توك', 'دبوس', 'ت'],
      searchTermsEn: ['brooch', 'brooches', 'pin', 'pins'],
      icon: '📌',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
      ],
    ),

    // غوايش / Anklets
    ProductCategory(
      id: 'anklets',
      nameAr: 'غوايش',
      nameEn: 'Anklets',
      searchTermsAr: ['غويشة', 'غوايش', 'خلخال', 'غ'],
      searchTermsEn: ['anklet', 'anklets', 'a'],
      icon: '🦶',
      types: [
        ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡', hasKarat: true),
        ProductType(id: 'silver', nameAr: 'فضة', nameEn: 'Silver', icon: '⚪', hasKarat: false),
      ],
    ),
  ];

  /// البحث في الفئات
  static List<ProductCategory> search(String query) {
    if (query.isEmpty) return all;
    
    // إزالة المسافات الزائدة
    final cleanQuery = query.trim();
    
    // البحث بأول حرف أو بالنص الكامل
    return all.where((cat) {
      // إذا كان البحث حرف واحد فقط، ابحث في أول حرف فقط
      if (cleanQuery.length == 1) {
        final firstChar = cleanQuery.toLowerCase();
        return cat.searchTermsAr.any((term) => term.toLowerCase().startsWith(firstChar)) ||
               cat.searchTermsEn.any((term) => term.toLowerCase().startsWith(firstChar)) ||
               cat.nameAr.toLowerCase().startsWith(firstChar) ||
               cat.nameEn.toLowerCase().startsWith(firstChar);
      }
      
      // إذا كان أكثر من حرف، ابحث في النص الكامل
      return cat.matchesSearch(cleanQuery);
    }).toList();
  }
}

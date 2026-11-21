import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/theme/app_text_styles.dart';

/// Widget لاختبار خطوط Cairo وعرض جميع الأوزان
class FontTestWidget extends StatelessWidget {
  const FontTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('اختبار خط Cairo'),
        backgroundColor: AppColors.card,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'خط Cairo - جميع الأوزان',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختبار شامل لجميع أوزان الخط العربي',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // العناوين
            _buildSection(
              title: 'العناوين (Headings)',
              items: [
                _FontSample('Heading 1', 'عنوان رئيسي كبير', AppTextStyles.heading1),
                _FontSample('Heading 2', 'عنوان رئيسي', AppTextStyles.heading2),
                _FontSample('Heading 3', 'عنوان فرعي', AppTextStyles.heading3),
                _FontSample('Heading 4', 'عنوان صغير', AppTextStyles.heading4),
                _FontSample('Heading 5', 'عنوان أصغر', AppTextStyles.heading5),
                _FontSample('Heading 6', 'عنوان صغير جداً', AppTextStyles.heading6),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // النصوص الأساسية
            _buildSection(
              title: 'النصوص الأساسية (Body Text)',
              items: [
                _FontSample(
                  'Body Large',
                  'هذا نص أساسي كبير يستخدم في الفقرات الرئيسية والمحتوى المهم في التطبيق',
                  AppTextStyles.bodyLarge,
                ),
                _FontSample(
                  'Body Medium',
                  'هذا نص أساسي متوسط يستخدم في معظم محتوى التطبيق والنصوص العادية',
                  AppTextStyles.bodyMedium,
                ),
                _FontSample(
                  'Body Small',
                  'هذا نص أساسي صغير للتفاصيل الثانوية والملاحظات',
                  AppTextStyles.bodySmall,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // المبالغ المالية
            _buildSection(
              title: 'المبالغ المالية (Currency)',
              items: [
                _FontSample('Large', '18,157.10 ج.م', AppTextStyles.currencyLarge),
                _FontSample('Medium', '5,420.50 ج.م', AppTextStyles.currencyMedium),
                _FontSample('Small', '125.00 ج.م', AppTextStyles.currencySmall),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // الحالات
            _buildSection(
              title: 'الحالات (States)',
              items: [
                _FontSample('Success', 'تمت الموافقة بنجاح', AppTextStyles.success),
                _FontSample('Error', 'حدث خطأ في العملية', AppTextStyles.error),
                _FontSample('Warning', 'يحتاج إلى انتباه', AppTextStyles.warning),
                _FontSample('Info', 'معلومة جديدة', AppTextStyles.info),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // التسميات
            _buildSection(
              title: 'التسميات (Labels)',
              items: [
                _FontSample('Label Large', 'تسمية كبيرة', AppTextStyles.labelLarge),
                _FontSample('Label Medium', 'تسمية متوسطة', AppTextStyles.labelMedium),
                _FontSample('Label Small', 'تسمية صغيرة', AppTextStyles.labelSmall),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // الأزرار
            _buildSection(
              title: 'نصوص الأزرار (Buttons)',
              items: [
                _FontSample('Button', 'نص الزر الأساسي', AppTextStyles.button),
                _FontSample('Button Small', 'نص الزر الصغير', AppTextStyles.buttonSmall),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // اختبار الأرقام
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختبار الأرقام العربية والإنجليزية',
                    style: AppTextStyles.heading5.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أرقام عربية: ٠ ١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩',
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أرقام إنجليزية: 0 1 2 3 4 5 6 7 8 9',
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مبلغ مالي: 123,456.78 ج.م',
                    style: AppTextStyles.currencyMedium,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // اختبار RTL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختبار RTL والنصوص المختلطة',
                    style: AppTextStyles.heading5.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'هذا نص عربي مع English text مختلط مع أرقام 123 وعلامات ترقيم!',
                    style: AppTextStyles.bodyLarge,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'التاريخ: ١٥ نوفمبر ٢٠٢٦ - الوقت: ٣:٤٥ م',
                    style: AppTextStyles.bodyMedium,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required List<_FontSample> items,
  }) {
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
          Text(
            title,
            style: AppTextStyles.heading5.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          ...items.map((sample) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sample.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sample.text,
                  style: sample.style,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _FontSample {
  const _FontSample(this.label, this.text, this.style);
  
  final String label;
  final String text;
  final TextStyle style;
}

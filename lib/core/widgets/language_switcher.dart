import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../localization/locale_cubit.dart';
import '../theme/app_colors.dart';

/// Widget لتبديل اللغة بين العربية والإنجليزية
class LanguageSwitcher extends StatelessWidget {
  final bool showText;
  
  const LanguageSwitcher({
    super.key,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        final localeCubit = context.read<LocaleCubit>();
        
        if (showText) {
          return ListTile(
            leading: Icon(
              Icons.language,
              color: AppColors.gold,
            ),
            title: Text(
              isArabic ? 'اللغة' : 'Language',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              isArabic ? 'العربية' : 'English',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            trailing: Switch(
              value: !isArabic,
              activeColor: AppColors.gold,
              onChanged: (_) => localeCubit.toggleLocale(),
            ),
            onTap: () => localeCubit.toggleLocale(),
          );
        } else {
          // Icon Button فقط
          return IconButton(
            icon: Icon(
              Icons.language,
              color: AppColors.gold,
            ),
            onPressed: () => localeCubit.toggleLocale(),
            tooltip: isArabic ? 'Switch to English' : 'التبديل للعربية',
          );
        }
      },
    );
  }
}

/// Chip بسيط لتبديل اللغة
class LanguageChip extends StatelessWidget {
  const LanguageChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        final localeCubit = context.read<LocaleCubit>();
        
        return InkWell(
          onTap: () => localeCubit.toggleLocale(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.gold,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  color: AppColors.gold,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  isArabic ? 'EN' : 'ع',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

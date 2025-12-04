import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theming/colors.dart';

class LanguageSwitcherButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback? onLanguageChanged;

  const LanguageSwitcherButton({
    super.key,
    this.isDark = false,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSwitcherButton> createState() => _LanguageSwitcherButtonState();
}

class _LanguageSwitcherButtonState extends State<LanguageSwitcherButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLanguageDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language_rounded,
                size: 20,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'العربية' : 'English',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = context.locale;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.language_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'language'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Language options
              _buildLanguageOption(
                dialogContext,
                context,
                'English',
                '🇬🇧',
                const Locale('en'),
                currentLocale.languageCode == 'en',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                dialogContext,
                context,
                'العربية',
                '🇸🇦',
                const Locale('ar'),
                currentLocale.languageCode == 'ar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext dialogContext,
    BuildContext parentContext,
    String language,
    String flag,
    Locale locale,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () async {
        await parentContext.setLocale(locale);
        if (dialogContext.mounted) {
          Navigator.pop(dialogContext);
        }
        // Trigger parent rebuild
        if (mounted) {
          setState(() {});
          widget.onLanguageChanged?.call();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


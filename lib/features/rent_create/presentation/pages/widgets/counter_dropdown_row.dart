import 'package:flutter/material.dart';

import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/text_styles.dart';

class CounterDropdownRow extends StatelessWidget {
  const CounterDropdownRow({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.onLeftChanged,
    required this.rightLabel,
    required this.rightValue,
    required this.onRightChanged,
    this.minValue = 0,
    this.maxValue = 20,
  });

  final String leftLabel;
  final int leftValue;
  final ValueChanged<int> onLeftChanged;
  final String rightLabel;
  final int rightValue;
  final ValueChanged<int> onRightChanged;
  final int minValue;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CounterDropdown(
            label: leftLabel,
            value: leftValue,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: onLeftChanged,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
        Expanded(
          child: _CounterDropdown(
            label: rightLabel,
            value: rightValue,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: onRightChanged,
          ),
        ),
      ],
    );
  }
}

class _CounterDropdown extends StatelessWidget {
  const _CounterDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.minValue,
    required this.maxValue,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  List<int> get _options =>
      List<int>.generate(maxValue - minValue + 1, (index) => minValue + index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, mobile: 10, tablet: 12, desktop: 14)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20), vertical: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16)),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isDense: true,
              isExpanded: true,
              value: value,
              icon: Icon(
                Icons.expand_more,
                color: AppColors.primary,
                size: ResponsiveUtils.fontSize(context, mobile: 18, tablet: 20, desktop: 22),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
                color: AppColors.textPrimary,
              ),
              items: _options
                  .map(
                    (option) => DropdownMenuItem<int>(
                      value: option,
                      child: Text(option.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (selected) {
                if (selected != null) {
                  onChanged(selected);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

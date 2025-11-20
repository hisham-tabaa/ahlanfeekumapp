import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../../domain/entities/rent_create_entities.dart';

class ProgressStepIndicator extends StatelessWidget {
  const ProgressStepIndicator({super.key, required this.steps});

  final List<PropertyCreationStepStatus> steps;

  int get _activeIndex {
    final active = steps.indexWhere((s) => s.isActive);
    if (active != -1) return active;
    final lastCompleted = steps.lastIndexWhere((s) => s.isCompleted);
    return (lastCompleted + 1).clamp(0, steps.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    final int activeIndex = _activeIndex;
    const double baseCircle = 28; // logical px before scaling
    final double circleDiameter = ResponsiveUtils.size(context, mobile: baseCircle, tablet: baseCircle + 4, desktop: baseCircle + 8);
    final double trackHeight = ResponsiveUtils.size(context, mobile: 3, tablet: 4, desktop: 5);
    final int count = steps.length;

    return SizedBox(
      height: ResponsiveUtils.size(context, mobile: 96, tablet: 110, desktop: 124),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final leftPad = circleDiameter / 2;
            final rightPad = circleDiameter / 2;
            final usableWidth = totalWidth - leftPad - rightPad;

            final bool hasMultipleSteps = count > 1;

            // Ensure the fill never drops below a visual 20% while
            // still aligning the leading edge with the active step center.
            const double minProgressFraction = 0.2;
            final double normalizedIndex = hasMultipleSteps
                ? activeIndex / (count - 1)
                : 1.0;
            final double effectiveFraction = hasMultipleSteps
                ? (normalizedIndex < minProgressFraction
                      ? minProgressFraction
                      : normalizedIndex)
                : 1.0;

            final double circleCenterX = hasMultipleSteps
                ? leftPad + usableWidth * effectiveFraction
                : leftPad + usableWidth / 2;

            final double segmentWidth = hasMultipleSteps
                ? usableWidth / (count - 1)
                : usableWidth;
            final double fillLeft = leftPad;
            final double fillWidth = hasMultipleSteps
                ? (circleCenterX - fillLeft) + circleDiameter / 2
                : usableWidth + circleDiameter;

            final PropertyCreationStepStatus activeStep = steps[activeIndex];

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Title above the indicator (centered over active step)
                Positioned(
                  top: 0,
                  left:
                      circleCenterX - segmentWidth.clamp(ResponsiveUtils.size(context, mobile: 60, tablet: 70, desktop: 80), totalWidth) / 2,
                  child: SizedBox(
                    width: segmentWidth.clamp(ResponsiveUtils.size(context, mobile: 80, tablet: 90, desktop: 100), totalWidth),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        activeStep.step.title,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontSize: ResponsiveUtils.fontSize(context, mobile: 12, tablet: 14, desktop: 16),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),

                // Base track
                Positioned(
                  top: ResponsiveUtils.spacing(context, mobile: 36, tablet: 42, desktop: 48),
                  left: leftPad,
                  right: rightPad,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(trackHeight),
                    ),
                  ),
                ),

                // Filled progress up to active center
                Positioned(
                  top: ResponsiveUtils.spacing(context, mobile: 36, tablet: 42, desktop: 48),
                  left: fillLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: fillWidth.clamp(
                      circleDiameter * minProgressFraction,
                      usableWidth + circleDiameter,
                    ),
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(trackHeight),
                    ),
                  ),
                ),

                // Active circle (number or check)
                Positioned(
                  top: ResponsiveUtils.spacing(context, mobile: 36, tablet: 42, desktop: 48) - circleDiameter / 2,
                  left: circleCenterX - circleDiameter / 2,
                  child: _ActiveStepCircle(
                    isCompleted: activeStep.isCompleted,
                    diameter: circleDiameter,
                    number: activeStep.step.stepNumber,
                    isActive: activeStep.isActive,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActiveStepCircle extends StatelessWidget {
  const _ActiveStepCircle({
    required this.isCompleted,
    required this.diameter,
    required this.number,
    required this.isActive,
  });

  final bool isCompleted;
  final bool isActive;
  final double diameter;
  final int number;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isCompleted
        ? AppColors.success
        : isActive
        ? AppColors.success
        : AppColors.divider;

    final Color backgroundColor = isCompleted
        ? AppColors.success
        : Colors.white;

    final Color textColor = isCompleted
        ? Colors.white
        : isActive
        ? AppColors.success
        : AppColors.textSecondary;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: ResponsiveUtils.size(context, mobile: 2, tablet: 2.5, desktop: 3)),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.15),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: ResponsiveUtils.fontSize(context, mobile: 18, tablet: 20, desktop: 22))
            : Text(
                '$number',
                style: AppTextStyles.bodySmall.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
                ),
              ),
      ),
    );
  }
}

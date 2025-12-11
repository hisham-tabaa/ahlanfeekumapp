import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';

class PriceStep extends StatefulWidget {
  const PriceStep({super.key});

  @override
  State<PriceStep> createState() => _PriceStepState();
}

class _PriceStepState extends State<PriceStep> {
  final _priceController = TextEditingController();
  Locale? _previousLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.locale;
    if (_previousLocale != null && _previousLocale != currentLocale) {
      setState(() {
        _previousLocale = currentLocale;
      });
    } else {
      _previousLocale = currentLocale;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        // Update controller when form data changes
        if (_priceController.text !=
            (state.formData.pricePerNight?.toString() ?? '')) {
          _priceController.text =
              state.formData.pricePerNight?.toString() ?? '';
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 40,
                  tablet: 45,
                  desktop: 32,
                ),
              ), // Reduced for desktop
              _buildSimplePriceInput(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 120,
                  tablet: 140,
                  desktop: 120,
                ),
              ), // Reduced for desktop
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'price'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    mobile: 24,
                    tablet: 26,
                    desktop: 28,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        Text(
          'price_per_night'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimplePriceInput(BuildContext context, RentCreateState state) {
    final isRTL = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: ResponsiveUtils.size(
            context,
            mobile: 70,
            tablet: 80,
            desktop: 90,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            border: Border.all(
              color: _priceController.text.isNotEmpty
                  ? AppColors.primary
                  : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.15),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Currency symbol container
              Container(
                width: ResponsiveUtils.size(
                  context,
                  mobile: 70,
                  tablet: 80,
                  desktop: 90,
                ),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: isRTL
                      ? BorderRadius.only(
                          topRight: Radius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                          ),
                          bottomRight: Radius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                          ),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                          ),
                          bottomLeft: Radius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                          ),
                        ),
                ),
                child: Center(
                  child: Text(
                    '\$',
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 32,
                        tablet: 36,
                        desktop: 40,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  textDirection: ui.TextDirection.ltr, // Force LTR for numeric input
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 36,
                      tablet: 42,
                      desktop: 48,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: AppTextStyles.h1.copyWith(
                      color: Colors.grey[300],
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 36,
                        tablet: 42,
                        desktop: 48,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<RentCreateBloc>().add(
                        UpdatePriceEvent(null),
                      );
                    } else {
                      final price = int.tryParse(value);
                      if (price != null) {
                        context.read<RentCreateBloc>().add(
                          UpdatePriceEvent(price),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 18,
                  tablet: 20,
                  desktop: 22,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 10,
                  desktop: 12,
                ),
              ),
              Expanded(
                child: Text(
                  'price_info_message'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

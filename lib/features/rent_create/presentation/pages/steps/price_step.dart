import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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
        Text(
          'Price',
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
          'Price - Per Night',
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
    return Container(
      height: ResponsiveUtils.size(
        context,
        mobile: 80,
        tablet: 90,
        desktop: 100,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
        border: Border.all(
          color: _priceController.text.isNotEmpty
              ? AppColors.primary
              : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.size(
              context,
              mobile: 60,
              tablet: 65,
              desktop: 70,
            ),
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                bottomLeft: Radius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
              ),
            ),
            child: Center(
              child: Text(
                '\$',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    mobile: 24,
                    tablet: 26,
                    desktop: 28,
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
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 28,
                  tablet: 30,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintStyle: AppTextStyles.h2.copyWith(
                  color: Colors.grey[400],
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    mobile: 28,
                    tablet: 30,
                    desktop: 32,
                  ),
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 17,
                    desktop: 18,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    mobile: 20,
                    tablet: 21,
                    desktop: 22,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  // Clear the price when field is empty
                  context.read<RentCreateBloc>().add(UpdatePriceEvent(null));
                } else {
                  // Only update if the value is a valid complete number
                  final price = int.tryParse(value);
                  if (price != null) {
                    context.read<RentCreateBloc>().add(UpdatePriceEvent(price));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

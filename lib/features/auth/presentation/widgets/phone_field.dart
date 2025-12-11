import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/registration_cubit.dart';

class PhoneField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const PhoneField({
    super.key,
    this.labelText = 'Phone Number',
    this.hintText = 'Enter phone number',
    this.readOnly = false,
    this.onChanged,
    this.controller,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        // Update controller if needed
        if (widget.controller == null &&
            _controller.text != state.phoneNumber) {
          _controller.text = state.phoneNumber;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
            ],
            Container(
              decoration: BoxDecoration(
                color: widget.readOnly ? Colors.grey[100] : Colors.grey[50],
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(context, mobile: 10, tablet: 12, desktop: 14),
                ),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  // Country Code Picker
                  CountryCodePicker(
                    onChanged: widget.readOnly
                        ? null
                        : (country) {
                            context.read<RegistrationCubit>().setCountryCode(
                              country.dialCode!,
                            );
                          },
                    initialSelection: state.countryCode,
                    favorite: const ['+963', '+1', '+44', '+33', '+49'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    dialogTextStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    searchStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12), 
                      vertical: 0,
                    ),
                    flagWidth: ResponsiveUtils.size(context, mobile: 20, tablet: 22, desktop: 24),
                    enabled: !widget.readOnly,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black54,
                    boxDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),

                  // Divider
                  Container(
                    height: ResponsiveUtils.size(context, mobile: 30, tablet: 34, desktop: 38),
                    width: 1,
                    color: Colors.grey.shade300,
                  ),

                  // Phone Number Input
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                      ),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        readOnly: widget.readOnly,
                        textDirection: TextDirection.ltr, // Force LTR for phone numbers
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: widget.readOnly
                              ? Colors.grey.shade600
                              : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey.shade500,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
                          ),
                        ),
                        onChanged: widget.readOnly
                            ? null
                            : (value) {
                                context.read<RegistrationCubit>().setPhone(
                                  value,
                                );
                                widget.onChanged?.call(value);
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

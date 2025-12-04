import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../data/models/payment_method_model.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethodModel> paymentMethods;
  final int selectedMethodId;
  final ValueChanged<int> onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    required this.selectedMethodId,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'select_payment_method'.tr(),
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, mobile: 18, tablet: 20, desktop: 22),
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24)),
        ...paymentMethods.map((method) => _buildPaymentMethodCard(
          context,
          method,
          method.id == selectedMethodId,
        )),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethodModel method,
    bool isSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
      ),
      child: InkWell(
        onTap: () => onMethodSelected(method.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : isDark
                    ? Colors.grey[850]
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Radio button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24)),
              
              // Icon
              Icon(
                _getPaymentMethodIcon(method.id),
                size: 32,
                color: isSelected ? AppColors.primary : Colors.grey[600],
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24)),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPaymentMethodName(method),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (method.description != null) ...[
                      SizedBox(height: 4),
                      Text(
                        _getPaymentMethodDescription(method),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Checkmark for selected
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(int methodId) {
    switch (methodId) {
      case 1:
        return Icons.credit_card;
      case 2:
        return Icons.payments_outlined;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodName(PaymentMethodModel method) {
    if (method.id == 1) {
      return 'credit_debit_card'.tr();
    } else if (method.id == 2) {
      return 'cash_on_arrival'.tr();
    }
    return method.name;
  }

  String _getPaymentMethodDescription(PaymentMethodModel method) {
    if (method.id == 1) {
      return 'pay_securely_with_stripe'.tr();
    } else if (method.id == 2) {
      return 'pay_when_you_checkin'.tr();
    }
    return method.description ?? '';
  }
}

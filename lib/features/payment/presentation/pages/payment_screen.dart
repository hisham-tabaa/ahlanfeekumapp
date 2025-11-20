import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentScreen extends StatefulWidget {
  final int amount;
  final String email;
  final String? name;
  final String? description;
  final Map<String, String>? metadata;
  final String? userId;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.email,
    this.name,
    this.description,
    this.metadata,
    this.userId,
    this.onSuccess,
    this.onFailure,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardController = CardFormEditController();
  late final CardFormStyle _cardFormStyle = CardFormStyle(
    backgroundColor: Colors.white,
    textColor: const Color(0xFF1F2937),
    fontSize: 16,
    placeholderColor: const Color(0xFF9CA3AF),
    textErrorColor: const Color(0xFFEF4444),
    borderColor: AppColors.primary,
    borderWidth: 2,
    borderRadius: 14,
  );
  bool _cardFormHasFocus = false;
  CardFieldInputDetails? _cardDetails;
  String? _cardValidationError;

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Widget _buildFieldGuideChip(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
        vertical: ResponsiveUtils.spacing(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 12,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            color: AppColors.primary,
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                hint,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _processPayment(BuildContext blocContext) {
    if (!(_cardDetails?.complete ?? false)) {
      setState(() {
        _cardValidationError =
            'Please fill card number, expiry, CVC, and country.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete all card fields before paying.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    blocContext.read<PaymentBloc>().add(
      ProcessPaymentEvent(
        amount: widget.amount,
        email: widget.email,
        name: widget.name,
        description: widget.description,
        metadata: widget.metadata,
        userId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment successful!'),
                  backgroundColor: Colors.green,
                ),
              );
              widget.onSuccess?.call();
              Navigator.pop(context, true);
            } else if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment failed: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
              widget.onFailure?.call();
            }
          },
          builder: (context, state) {
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
                  Text(
                    'Payment Details',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                  ),
                  Wrap(
                    spacing: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                    runSpacing: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                    children: [
                      _buildFieldGuideChip(
                        context,
                        label: 'Card number',
                        hint: '16 digits',
                        icon: Icons.credit_card,
                      ),
                      _buildFieldGuideChip(
                        context,
                        label: 'MM / YY',
                        hint: 'Expiry date',
                        icon: Icons.calendar_today_outlined,
                      ),
                      _buildFieldGuideChip(
                        context,
                        label: 'CVC',
                        hint: 'Security code',
                        icon: Icons.lock_outline,
                      ),
                      _buildFieldGuideChip(
                        context,
                        label: 'Country',
                        hint: 'Billing location',
                        icon: Icons.public,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${(widget.amount / 100).toStringAsFixed(2)}',
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                  Text(
                    'Card Information',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
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
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FB),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 4,
                        tablet: 6,
                        desktop: 8,
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.radius(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                        ),
                        border: Border.all(
                          color: _cardFormHasFocus
                              ? AppColors.primary
                              : const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_cardFormHasFocus
                                ? AppColors.primary.withOpacity(0.08)
                                : Colors.black.withOpacity(0.04)),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CardFormField(
                        controller: _cardController,
                        enablePostalCode: true,
                        countryCode: 'SA',
                        onCardChanged: (details) {
                          setState(() {
                            final isComplete = details?.complete ?? false;
                            _cardDetails = details;
                            if (isComplete) {
                              _cardValidationError = null;
                            }
                          });
                        },
                        onFocus: (focusName) {
                          setState(() {
                            _cardFormHasFocus = focusName != null;
                          });
                        },
                        style: _cardFormStyle,
                      ),
                    ),
                  ),
                  if (_cardValidationError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _cardValidationError!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 32,
                      tablet: 36,
                      desktop: 40,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is PaymentLoading
                          ? null
                          : () => _processPayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 12,
                              tablet: 14,
                              desktop: 16,
                            ),
                          ),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: state is PaymentLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Pay Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: ResponsiveUtils.fontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(
                          width: ResponsiveUtils.spacing(
                            context,
                            mobile: 8,
                            tablet: 10,
                            desktop: 12,
                          ),
                        ),
                        Text(
                          'Secured by Stripe',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

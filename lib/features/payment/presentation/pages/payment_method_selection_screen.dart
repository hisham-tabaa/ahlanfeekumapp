import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../data/models/payment_method_model.dart';

class PaymentMethodSelectionScreen extends StatefulWidget {
  final double totalAmount;
  final String currency;
  final int nights;
  final String propertyTitle;

  const PaymentMethodSelectionScreen({
    super.key,
    required this.totalAmount,
    this.currency = 'USD',
    required this.nights,
    required this.propertyTitle,
  });

  @override
  State<PaymentMethodSelectionScreen> createState() =>
      _PaymentMethodSelectionScreenState();
}

class _PaymentMethodSelectionScreenState
    extends State<PaymentMethodSelectionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMethodId = 1; // Default to Card
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<PaymentMethodModel> _paymentMethods = const [
    PaymentMethodModel(
      id: 1,
      name: 'Card',
      description: 'Pay securely with credit/debit card via Stripe',
      icon: 'credit_card',
      isActive: true,
    ),
    PaymentMethodModel(
      id: 2,
      name: 'Cash',
      description: 'Pay cash when you arrive at the property',
      icon: 'cash',
      isActive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 600;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: isDark
                ? const Color(0xFF0A0A0A)
                : const Color(0xFFF8F9FA),
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'select_payment_method'.tr(),
                style: AppTextStyles.h3.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTabletOrDesktop ? screenWidth * 0.15 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Premium Booking Summary Card
                    _buildBookingSummaryCard(isDark),

                    const SizedBox(height: 36),

                    // Section Title
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'how_would_you_like_to_pay'.tr(),
                          style: AppTextStyles.h4.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Payment Method Cards with staggered animation
                    ...List.generate(_paymentMethods.length, (index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + (index * 150)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildPaymentMethodCard(
                                context,
                                _paymentMethods[index],
                                isDark,
                              ),
                            ),
                          );
                        },
                      );
                    }),

                    const SizedBox(height: 40),

                    // Continue Button with gradient
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.85),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        text: _selectedMethodId == 1
                            ? 'continue_to_payment'.tr()
                            : 'confirm_booking'.tr(),
                        onPressed: () {
                          Navigator.pop(context, _selectedMethodId);
                        },
                        backgroundColor: Colors.transparent,
                        height: 60,
                        borderRadius: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Security notice
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.verified_user,
                              size: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'your_payment_secure'.tr(),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummaryCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
            const Color(0xFFA855F7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property info row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.propertyTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.nights_stay_rounded,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.nights} ${'night'.tr()}${widget.nights > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Divider line
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),

          const SizedBox(height: 20),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'total'.tr().toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Including taxes & fees',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currency,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.totalAmount.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethodModel method,
    bool isDark,
  ) {
    final isSelected = method.id == _selectedMethodId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethodId = method.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.08))
                : (isDark ? const Color(0xFF1A1A1A) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                          width: 2,
                        ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
              const SizedBox(width: 18),

              // Icon container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: method.id == 1
                              ? [
                                  const Color(0xFF3B82F6),
                                  const Color(0xFF1D4ED8),
                                ]
                              : [
                                  const Color(0xFF10B981),
                                  const Color(0xFF059669),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark ? Colors.grey[850] : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                (method.id == 1
                                        ? const Color(0xFF3B82F6)
                                        : const Color(0xFF10B981))
                                    .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  method.id == 1
                      ? Icons.credit_card_rounded
                      : Icons.payments_rounded,
                  size: 28,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
              const SizedBox(width: 18),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.id == 1
                          ? 'credit_debit_card'.tr()
                          : 'cash_on_arrival'.tr(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      method.id == 1
                          ? 'pay_securely_with_stripe'.tr()
                          : 'pay_when_you_checkin'.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                    if (method.id == 1) ...[
                      const SizedBox(height: 12),
                      // Card brand icons (wrap to avoid overflow on small screens)
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildCardBrandChip('VISA', const Color(0xFF1A1F71)),
                          _buildCardBrandChip('MC', const Color(0xFFEB001B)),
                          _buildCardBrandChip('AMEX', const Color(0xFF006FCF)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow indicator
              if (isSelected)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBrandChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

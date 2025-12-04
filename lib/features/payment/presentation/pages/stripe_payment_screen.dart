import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class StripePaymentScreen extends StatefulWidget {
  final int amount;
  final String currency;
  final String email;
  final String? name;
  final VoidCallback onPaymentComplete;

  const StripePaymentScreen({
    super.key,
    required this.amount,
    this.currency = 'usd',
    required this.email,
    this.name,
    required this.onPaymentComplete,
  });

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen>
    with SingleTickerProviderStateMixin {
  final _controller = CardFormEditController();
  final _cardHolderController = TextEditingController();
  bool _isProcessing = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _cardHolderController.text = widget.name ?? '';
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ), // Reduced from 800ms to 200ms for faster performance
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut, // Changed to simpler curve for better performance
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cardHolderController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String _formatAmount() {
    final displayAmount = widget.amount / 100;
    final currencySymbol = widget.currency.toUpperCase() == 'USD'
        ? '\$'
        : widget.currency.toUpperCase();
    return '$currencySymbol${displayAmount.toStringAsFixed(2)}';
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
          // Premium App Bar
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'payment'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
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

                    // Premium Amount Display Card
                    _buildAmountCard(isDark),

                    const SizedBox(height: 36),

                    // Card Information Section
                    _buildSectionHeader(
                      'card_information'.tr(),
                      Icons.credit_card_rounded,
                      isDark,
                    ),

                    const SizedBox(height: 20),

                    // Premium Card Input Container
                    _buildCardInputContainer(isDark),

                    const SizedBox(height: 28),

                    // Cardholder Name Section
                    _buildSectionHeader(
                      'card_holder_name'.tr(),
                      Icons.person_rounded,
                      isDark,
                    ),

                    const SizedBox(height: 16),

                    _buildCardholderInput(isDark),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 24),
                      _buildErrorMessage(),
                    ],

                    const SizedBox(height: 40),

                    // Pay Button
                    _buildPayButton(isDark),

                    const SizedBox(height: 24),

                    // Security badges
                    _buildSecurityBadges(isDark),

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

  Widget _buildAmountCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row with card chip and wireless icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chip
              Container(
                width: 45,
                height: 34,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[600]!, Colors.amber[700]!],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 2,
                    color: Colors.amber[900],
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
              ),
              // Wireless icon
              Icon(
                Icons.contactless_rounded,
                color: Colors.white.withValues(alpha: 0.6),
                size: 28,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Amount
          Text(
            'total'.tr().toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFE2E8F0)],
            ).createShader(bounds),
            child: Text(
              _formatAmount(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bottom row with Stripe logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'secured_by_stripe'.tr(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: AppTextStyles.h4.copyWith(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCardInputContainer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CardFormField(
          controller: _controller,
          countryCode: 'US',
          style: CardFormStyle(
            backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            textColor: isDark ? Colors.white : Colors.black87,
            placeholderColor: isDark ? Colors.grey[600] : Colors.grey[400],
            borderColor: Colors.transparent,
            borderRadius: 12,
            fontSize: 16,
            cursorColor: AppColors.primary,
            textErrorColor: Colors.red[400],
          ),
        ),
      ),
    );
  }

  Widget _buildCardholderInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _cardHolderController,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'full_name_on_card'.tr(),
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[600] : Colors.grey[400],
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.badge_outlined,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.red[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(bool isDark) {
    return GestureDetector(
      onTap: _isProcessing ? null : _handlePayment,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: _isProcessing
              ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[500]!])
              : const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isProcessing
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Center(
          child: _isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'pay_now'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatAmount(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSecurityBadges(bool isDark) {
    return Column(
      children: [
        // Main security notice
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                size: 18,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'your_payment_secure'.tr(),
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Card brand badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBrandBadge('VISA', const Color(0xFF1A1F71), isDark),
            const SizedBox(width: 12),
            _buildBrandBadge('Mastercard', const Color(0xFFEB001B), isDark),
            const SizedBox(width: 12),
            _buildBrandBadge('AMEX', const Color(0xFF006FCF), isDark),
            const SizedBox(width: 12),
            _buildBrandBadge('Discover', const Color(0xFFFF6000), isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandBadge(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.grey[400] : color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Validate card details
      final details = _controller.details;
      if (details.complete != true) {
        setState(() {
          _errorMessage = 'complete_card_details'.tr();
          _isProcessing = false;
        });
        return;
      }

      // Validate cardholder name
      if (_cardHolderController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'enter_cardholder_name'.tr();
          _isProcessing = false;
        });
        return;
      }

      // Process payment through parent callback
      widget.onPaymentComplete();

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isProcessing = false;
      });
    }
  }
}

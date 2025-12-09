import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';

class CardPaymentScreen extends StatefulWidget {
  final int amount;
  final String currency;
  final String email;
  final String? name;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailure;

  const CardPaymentScreen({
    super.key,
    required this.amount,
    this.currency = 'usd',
    required this.email,
    this.name,
    this.onPaymentSuccess,
    this.onPaymentFailure,
  });

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _cardHolderController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CardFormEditController _cardController = CardFormEditController();

  bool _isProcessing = false;
  String? _errorMessage;
  String _selectedCountry = 'Sweden';
  final bool _cardSelected = true;

  final List<String> _countries = [
    'Sweden',
    'United States',
    'United Kingdom',
    'Germany',
    'France',
    'Saudi Arabia',
    'UAE',
    'Egypt',
    'Jordan',
    'Lebanon',
    'Syria',
    'Iraq',
    'Kuwait',
    'Qatar',
    'Bahrain',
    'Oman',
  ];

  @override
  void initState() {
    super.initState();
    _cardHolderController.text = widget.name ?? '';
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _addressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  String _formatAmount() {
    final displayAmount = widget.amount / 100;
    return displayAmount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          'payment'.tr(),
          style: AppTextStyles.h2.copyWith(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 22,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Selection Header
                _buildCardSelectionHeader(isDark),

                const SizedBox(height: 24),

                // Card Information Section
                _buildSectionTitle('card_information'.tr(), isDark),
                const SizedBox(height: 12),
                _buildCardInformationSection(isDark),

                const SizedBox(height: 24),

                // Cardholder Name Section
                _buildSectionTitle('card_holder_name'.tr(), isDark),
                const SizedBox(height: 12),
                _buildCardholderNameField(isDark),

                const SizedBox(height: 24),

                // Billing Address Section
                _buildSectionTitle('billing_address'.tr(), isDark),
                const SizedBox(height: 12),
                _buildBillingAddressSection(isDark),

                // Error message
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Pay Button
                CustomButton(
                  text: '${'pay_now'.tr()} \$${_formatAmount()}',
                  onPressed: _isProcessing ? null : _handlePayment,
                  isLoading: _isProcessing,
                  backgroundColor: AppColors.primary,
                  height: 56,
                  borderRadius: 8,
                ),

                const SizedBox(height: 16),

                // Security notice
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Secured by Stripe',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSelectionHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _cardSelected
              ? AppColors.primary
              : isDark
              ? Colors.grey[700]!
              : Colors.grey[300]!,
          width: _cardSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Radio button
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _cardSelected ? AppColors.primary : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: _cardSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.credit_card,
            size: 20,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            'Card',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.grey[400] : Colors.grey[700],
      ),
    );
  }

  Widget _buildCardInformationSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          // Stripe Card Form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CardFormField(
              controller: _cardController,
              countryCode: 'US',
              style: CardFormStyle(
                backgroundColor: isDark ? Colors.grey[850] : Colors.white,
                textColor: isDark ? Colors.white : Colors.black87,
                placeholderColor: isDark ? Colors.grey[500] : Colors.grey[400],
                borderColor: Colors.transparent,
                borderRadius: 8,
                fontSize: 16,
              ),
            ),
          ),
          // Card brand icons row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCardBrandIcon('assets/icons/visa.png', 'Visa'),
                const SizedBox(width: 8),
                _buildCardBrandIcon('assets/icons/mastercard.png', 'MC'),
                const SizedBox(width: 8),
                _buildCardBrandIcon('assets/icons/amex.png', 'Amex'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandIcon(String assetPath, String fallbackText) {
    return Container(
      width: 36,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Text(
          fallbackText,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildCardholderNameField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: TextFormField(
        controller: _cardHolderController,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Full name on card',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter cardholder name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBillingAddressSection(bool isDark) {
    return Column(
      children: [
        // Country dropdown
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedCountry,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
            dropdownColor: isDark ? Colors.grey[850] : Colors.white,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            items: _countries.map((country) {
              return DropdownMenuItem(value: country, child: Text(country));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCountry = value!;
              });
            },
          ),
        ),

        // Address field
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            border: Border(
              left: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
              right: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
              bottom: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: TextFormField(
            controller: _addressController,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'address'.tr(),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Enter address manually link
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Enter address manually',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Validate card details
      final details = _cardController.details;
      if (details.complete != true) {
        setState(() {
          _errorMessage = 'Please enter complete card details';
          _isProcessing = false;
        });
        return;
      }

      // Validate cardholder name
      if (_cardHolderController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Please enter cardholder name';
          _isProcessing = false;
        });
        return;
      }

      // Create payment method
      await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: widget.email,
              name: _cardHolderController.text.trim(),
              address: Address(
                country: _selectedCountry,
                line1: _addressController.text.trim(),
                city: null,
                postalCode: null,
                state: null,
                line2: null,
              ),
            ),
          ),
        ),
      );

      // Success - call callback and return
      widget.onPaymentSuccess?.call();
      if (mounted) {
        Navigator.pop(context, true);
      }
    } on StripeException catch (e) {
      setState(() {
        _errorMessage = e.error.localizedMessage ?? 'Payment failed';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isProcessing = false;
      });
    }
  }
}

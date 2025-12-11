import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  bool _stripeInitialized = false;
  String? _initializationError;
  bool _isBusinessPurchase = false;

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
    _initializeStripe();
  }

  Future<void> _initializeStripe() async {
    try {
      // Verify Stripe is initialized
      if (Stripe.publishableKey.isEmpty) {
        setState(() {
          _initializationError =
              'Stripe is not initialized. Please check your configuration.';
          _stripeInitialized = false;
        });
        return;
      }

      // For web, ensure Stripe.js is loaded
      if (kIsWeb) {
        // Give Stripe.js time to load if needed
        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() {
        _stripeInitialized = true;
        _initializationError = null;
      });
    } catch (e) {
      setState(() {
        _initializationError = 'Failed to initialize Stripe: $e';
        _stripeInitialized = false;
      });
    }
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

                const SizedBox(height: 20),

                // Card Information Section
                _buildSectionTitle('card_information'.tr(), isDark),
                const SizedBox(height: 12),
                if (_initializationError != null)
                  _buildErrorSection(_initializationError!, isDark)
                else if (_stripeInitialized)
                  _buildCardInformationSection(isDark)
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                const SizedBox(height: 24),

                // Cardholder Name Section
                _buildSectionTitle('card_holder_name'.tr(), isDark),
                const SizedBox(height: 12),
                _buildCardholderNameField(isDark),

                const SizedBox(height: 20),

                // Billing Address Section
                _buildSectionTitle('billing_address'.tr(), isDark),
                const SizedBox(height: 12),
                _buildBillingAddressSection(isDark),

                const SizedBox(height: 24),

                // Business Purchase Checkbox
                _buildBusinessPurchaseCheckbox(isDark),

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            size: 22,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 10),
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
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildCardInformationSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Stripe Card Form with icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Credit card icon
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.credit_card_outlined,
                    size: 22,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                // Card form field
                Expanded(
                  child: SizedBox(
                    height: kIsWeb ? 56 : 50,
                    child: CardFormField(
                      controller: _cardController,
                      countryCode: 'US',
                      style: CardFormStyle(
                        backgroundColor: Colors.transparent,
                        textColor: isDark ? Colors.white : Colors.black87,
                        placeholderColor: isDark
                            ? Colors.grey[500]
                            : Colors.grey[400],
                        borderColor: Colors.transparent,
                        borderRadius: 0,
                        fontSize: 16,
                        cursorColor: AppColors.primary,
                        textErrorColor: Colors.red[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: isDark ? Colors.grey[700] : Colors.grey[200],
          ),
          // Card brand icons row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCardBrandIcon('Visa', const Color(0xFF1A1F71)),
                const SizedBox(width: 8),
                _buildCardBrandIcon('MC', const Color(0xFFEB001B)),
                const SizedBox(width: 8),
                _buildCardBrandIcon('AMEX', const Color(0xFF006FCF)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandIcon(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCardholderNameField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: _cardHolderController,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Full name on card',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[400],
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.person_outline,
            size: 20,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedCountry,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w400,
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

        // Divider
        Container(
          height: 1,
          color: isDark ? Colors.grey[700] : Colors.grey[200],
        ),

        // Address field
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            border: Border(
              left: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
              right: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
              bottom: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: TextFormField(
            controller: _addressController,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'address'.tr(),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessPurchaseCheckbox(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        value: _isBusinessPurchase,
        onChanged: (value) {
          setState(() {
            _isBusinessPurchase = value ?? false;
          });
        },
        title: Text(
          "I'm purchasing as a business",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        activeColor: AppColors.primary,
        checkColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    );
  }

  Widget _buildErrorSection(String error, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Initialization Error',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error,
                  style: TextStyle(color: Colors.red[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
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

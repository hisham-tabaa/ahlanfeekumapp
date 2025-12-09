import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/payment_summary_bloc.dart';
import '../bloc/payment_summary_event.dart';
import '../bloc/payment_summary_state.dart';

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  int selectedYear = DateTime.now().year;
  Locale? _previousLocale;

  @override
  void initState() {
    super.initState();
    _loadPaymentSummary();
  }

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

  void _loadPaymentSummary() {
    final startDate = '$selectedYear-01-01';
    final endDate = '$selectedYear-12-31';

    context.read<PaymentSummaryBloc>().add(
      LoadPaymentSummaryEvent(startDate: startDate, endDate: endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('my_performance'.tr()),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 18,
            tablet: 20,
            desktop: 22,
          ),
        ),
      ),
      body: BlocBuilder<PaymentSummaryBloc, PaymentSummaryState>(
        builder: (context, state) {
          if (state is PaymentSummaryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentSummaryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadPaymentSummary,
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PaymentSummaryLoaded) {
            final summary = state.paymentSummary;

            return RefreshIndicator(
              onRefresh: () async {
                final startDate = '$selectedYear-01-01';
                final endDate = '$selectedYear-12-31';

                context.read<PaymentSummaryBloc>().add(
                  RefreshPaymentSummaryEvent(
                    startDate: startDate,
                    endDate: endDate,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "My Profits" Title
                    Text(
                      'my_profits'.tr(),
                      style: AppTextStyles.h3.copyWith(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 20,
                          tablet: 22,
                          desktop: 24,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),

                    // Total Payout Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.attach_money,
                              size: 32,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'total_payout'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${summary.totalPayment.toStringAsFixed(2)} ${summary.currency.toUpperCase()}',
                            style: AppTextStyles.h1.copyWith(
                              color: const Color(0xFF4CAF50),
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 28,
                                tablet: 32,
                                desktop: 36,
                              ),
                              fontWeight: FontWeight.bold,
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

                    // Payment Chart Header with Year Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'payment_chart'.tr(),
                          style: AppTextStyles.h3.copyWith(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              mobile: 18,
                              tablet: 20,
                              desktop: 22,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: selectedYear,
                              icon: const Icon(Icons.arrow_drop_down, size: 20),
                              isDense: true,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownColor: Colors.white,
                              items: List.generate(5, (index) {
                                final year = DateTime.now().year - index;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }),
                              onChanged: (year) {
                                if (year != null) {
                                  setState(() {
                                    selectedYear = year;
                                  });
                                  _loadPaymentSummary();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),

                    // Monthly Breakdown Chart
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: summary.monthlyPayments.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text(
                                  'no_payments_found_for_year'.tr(),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          : _buildChart(summary.monthlyPayments),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildChart(Map<String, double> monthlyPayments) {
    final maxAmount = monthlyPayments.values.isNotEmpty
        ? monthlyPayments.values.reduce((a, b) => a > b ? a : b)
        : 0.0;

    final peakEntry = monthlyPayments.entries.firstWhere(
      (e) => e.value == maxAmount,
      orElse: () => monthlyPayments.entries.first,
    );

    // Determine Y-axis max and labels
    final yMax = _getYAxisMax(maxAmount);
    final yLabels = _getYAxisLabels(yMax);

    return Column(
      children: [
        // Chart Area
        SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y-Axis Labels
              SizedBox(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: yLabels.reversed.map((label) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        label,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              // Bars
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: monthlyPayments.entries.map((entry) {
                    final month = entry.key;
                    final amount = entry.value;
                    final heightPercentage = yMax > 0 ? (amount / yMax) : 0.0;
                    final isPeak = amount == maxAmount;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 180 * heightPercentage,
                              decoration: BoxDecoration(
                                color: isPeak
                                    ? const Color(0xFFED1C24)
                                    : const Color(0xFFFFB3B6),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              month.toUpperCase(),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Peak Value Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFFED1C24),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'peak_value'
                  .tr()
                  .replaceAll('{0}', peakEntry.key.toUpperCase())
                  .replaceAll('{1}', '\$${peakEntry.value.toStringAsFixed(2)}'),
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _getYAxisMax(double maxValue) {
    if (maxValue <= 100) return 100;
    if (maxValue <= 500) return 500;
    if (maxValue <= 1000) return 1000;
    if (maxValue <= 5000) return 5000;
    if (maxValue <= 10000) return 10000;
    return ((maxValue / 10000).ceil() * 10000).toDouble();
  }

  List<String> _getYAxisLabels(double yMax) {
    if (yMax <= 100) {
      return ['0\$', '20\$', '40\$', '60\$', '80\$', '100\$'];
    } else if (yMax <= 500) {
      return ['0\$', '100\$', '200\$', '300\$', '400\$', '500\$'];
    } else if (yMax <= 1000) {
      return ['0\$', '200\$', '400\$', '600\$', '800\$', '1k\$'];
    } else if (yMax <= 5000) {
      return ['0\$', '1k\$', '2k\$', '3k\$', '4k\$', '5k\$'];
    } else if (yMax <= 10000) {
      return ['0\$', '2k\$', '4k\$', '6k\$', '8k\$', '10k\$'];
    } else {
      final step = yMax / 5;
      return List.generate(6, (i) {
        final value = step * i;
        if (value >= 1000) {
          return '${(value / 1000).toStringAsFixed(0)}k\$';
        }
        return '${value.toStringAsFixed(0)}\$';
      });
    }
  }
}

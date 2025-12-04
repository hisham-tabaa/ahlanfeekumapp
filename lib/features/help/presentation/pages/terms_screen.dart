import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/help_bloc.dart';
import '../bloc/help_state.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy'.tr()),
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
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<HelpBloc, HelpState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;

          return ResponsiveLayout(
            maxWidth: 800,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(
                    context,
                    title: 'Terms Of Conditions',
                    icon: Icons.description_outlined,
                    iconColor: Colors.blue,
                    iconBackgroundColor: Colors.blue.withValues(alpha: 0.15),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                  ),
                  _buildContentCard(
                    context,
                    title: settings?.termsTitle ?? 'Terms Of Conditions',
                    annotation: settings?.termsAnnotation ?? '',
                    description: settings?.termsDescription ?? '',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.size(
              context,
              mobile: 50,
              tablet: 56,
              desktop: 62,
            ),
            height: ResponsiveUtils.size(
              context,
              mobile: 50,
              tablet: 56,
              desktop: 62,
            ),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 28,
                tablet: 32,
                desktop: 36,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context, {
    required String title,
    required String annotation,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
            ),
          ),
          if (annotation.isNotEmpty) ...[
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
            ),
            Text(
              annotation,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
              ),
            ),
          ],
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 18,
            ),
          ),
          Html(
            data: description,
            style: {
              "body": Style(
                fontSize: FontSize(
                  ResponsiveUtils.fontSize(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 16,
                  ),
                ),
                lineHeight: const LineHeight(1.6),
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "p": Style(
                fontSize: FontSize(
                  ResponsiveUtils.fontSize(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 16,
                  ),
                ),
                lineHeight: const LineHeight(1.6),
                margin: Margins.only(bottom: 10),
              ),
              "strong": Style(fontWeight: FontWeight.w600),
            },
          ),
        ],
      ),
    );
  }
}

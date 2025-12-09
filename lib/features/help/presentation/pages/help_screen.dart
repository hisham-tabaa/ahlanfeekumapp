import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/help_bloc.dart';
import '../bloc/help_event.dart';
import '../bloc/help_state.dart';
import 'who_are_we_screen.dart';
import 'report_problem_screen.dart';
import 'terms_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HelpBloc>().add(const LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('help'.tr()),
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
      body: BlocConsumer<HelpBloc, HelpState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ResponsiveLayout(
            maxWidth: 700,
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
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildHelpCard(
                          context: context,
                          icon: Icons.help_outline,
                          iconColor: Colors.cyan,
                          iconBackgroundColor: Colors.cyan.withValues(
                            alpha: 0.15,
                          ),
                          subtitle: 'About Us',
                          title: 'Who Are We ?',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<HelpBloc>(),
                                  child: const WhoAreWeScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
                      Expanded(
                        child: _buildHelpCard(
                          context: context,
                          icon: Icons.headset_mic_outlined,
                          iconColor: Colors.orange,
                          iconBackgroundColor: Colors.orange.withValues(
                            alpha: 0.15,
                          ),
                          subtitle: 'Help me',
                          title: 'Report a problem',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<HelpBloc>(),
                                  child: const ReportProblemScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: ResponsiveUtils.responsiveWidth(
                        context,
                        mobile:
                            (MediaQuery.of(context).size.width -
                                ResponsiveUtils.spacing(
                                  context,
                                  mobile: 56,
                                  tablet: 60,
                                  desktop: 64,
                                )) /
                            2,
                        tablet:
                            (MediaQuery.of(context).size.width -
                                ResponsiveUtils.spacing(
                                  context,
                                  mobile: 56,
                                  tablet: 60,
                                  desktop: 64,
                                )) /
                            2,
                        desktop:
                            (MediaQuery.of(context).size.width -
                                ResponsiveUtils.spacing(
                                  context,
                                  mobile: 56,
                                  tablet: 60,
                                  desktop: 64,
                                )) /
                            2,
                      ),
                      child: _buildHelpCard(
                        context: context,
                        icon: Icons.description_outlined,
                        iconColor: Colors.blue,
                        iconBackgroundColor: Colors.blue.withValues(
                          alpha: 0.15,
                        ),
                        subtitle: 'Privacy',
                        title: 'Terms Of Conditions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<HelpBloc>(),
                                child: const TermsScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHelpCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String subtitle,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.radius(context, mobile: 16, tablet: 17, desktop: 18),
      ),
      child: Container(
        height: ResponsiveUtils.size(
          context,
          mobile: 180,
          tablet: 190,
          desktop: 200,
        ),
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 16, tablet: 17, desktop: 18),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 18,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveUtils.size(
                context,
                mobile: 60,
                tablet: 65,
                desktop: 70,
              ),
              height: ResponsiveUtils.size(
                context,
                mobile: 60,
                tablet: 65,
                desktop: 70,
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
                  mobile: 32,
                  tablet: 34,
                  desktop: 36,
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 4,
                tablet: 5,
                desktop: 6,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

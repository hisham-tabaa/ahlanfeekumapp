import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/registration_cubit.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import 'create_account_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../../../navigation/presentation/pages/main_navigation_screen.dart';

class ChooseAccountScreen extends StatefulWidget {
  const ChooseAccountScreen({super.key});

  @override
  State<ChooseAccountScreen> createState() => _ChooseAccountScreenState();
}

class _ChooseAccountScreenState extends State<ChooseAccountScreen> {
  int _selectedRole = 2; // 1 = Host, 2 = Guest

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationCubit>(
      create: (_) => getIt<RegistrationCubit>()..setRole(_selectedRole),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.responsive(
                    context,
                    mobile: double.infinity,
                    tablet: 600,
                    desktop: 700,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      mobile: 20,
                      tablet: 32,
                      desktop: 40,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 8,
                          tablet: 16,
                          desktop: 24,
                        ),
                      ),
                      Text(
                        'Choose Your Account',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 22,
                            tablet: 26,
                            desktop: 30,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 6,
                          tablet: 8,
                          desktop: 12,
                        ),
                      ),
                      Text(
                        'Select Your Account Type To Continue Your Journey',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 14,
                            tablet: 15,
                            desktop: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 24,
                          tablet: 32,
                          desktop: 40,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _AccountCard(
                              title: 'Host',
                              subtitle: 'Rent Out Your Property',
                              svgPath: 'assets/images/host.svg',
                              selected: _selectedRole == 1,
                              onTap: () {
                                setState(() => _selectedRole = 1);
                                context.read<RegistrationCubit>().setRole(1);
                                _goNext(context);
                              },
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 16,
                              tablet: 20,
                              desktop: 24,
                            ),
                          ),
                          Expanded(
                            child: _AccountCard(
                              title: 'Guest',
                              subtitle: 'Book Any Property To Stay',
                              svgPath: 'assets/images/Guest.svg',
                              selected: _selectedRole == 2,
                              onTap: () {
                                setState(() => _selectedRole = 2);
                                context.read<RegistrationCubit>().setRole(2);
                                _goNext(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'Continue As Visitor',
                        backgroundColor: Colors.grey[100],
                        textColor: AppColors.textPrimary,
                        onPressed: () {
                          // Trigger guest authentication
                          context.read<AuthBloc>().add(
                            const ContinueAsGuestEvent(),
                          );

                          // Navigate to main navigation screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _goNext(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const CreateAccountScreen(),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgPath;
  final bool selected;
  final VoidCallback onTap;

  const _AccountCard({
    required this.title,
    required this.subtitle,
    required this.svgPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );
    
    final cardRadius = ResponsiveUtils.radius(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    
    final iconSize = ResponsiveUtils.size(
      context,
      mobile: 60,
      tablet: 70,
      desktop: 80,
    );
    
    final titleSize = ResponsiveUtils.fontSize(
      context,
      mobile: 16,
      tablet: 18,
      desktop: 20,
    );
    
    final subtitleSize = ResponsiveUtils.fontSize(
      context,
      mobile: 11,
      tablet: 12,
      desktop: 13,
    );
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cardRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: cardPadding,
          vertical: cardPadding * 1.25,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: selected ? const Color(0xFFED1C24) : Colors.grey.shade300,
            width: selected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? 0.08 : 0.04),
              blurRadius: selected ? 12 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: titleSize,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: subtitleSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

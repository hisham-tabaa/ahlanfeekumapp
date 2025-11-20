// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/auth_options_screen.dart';
import '../../../help/presentation/bloc/help_bloc.dart';
import '../../../help/presentation/pages/help_screen.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import 'my_profile_screen.dart';
import 'saved_properties_screen.dart';
import 'my_reservations_screen.dart';
import '../../../property_management/presentation/pages/my_properties_screen.dart';
import '../../../property_management/presentation/bloc/property_management_bloc.dart';

class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
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
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isHost = authState is AuthAuthenticated && authState.user.roleId == 1;
          
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final profile = state.profile;

              return ResponsiveLayout(
                maxWidth: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                  // Profile Header
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 28,
                        desktop: 32,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Profile Photo
                        CircleAvatar(
                          radius: ResponsiveUtils.size(
                            context,
                            mobile: 35,
                            tablet: 40,
                            desktop: 45,
                          ),
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: profile?.profilePhotoUrl != null
                              ? CachedNetworkImageProvider(
                                  profile!.profilePhotoUrl!,
                                )
                              : null,
                          child: profile?.profilePhotoUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: ResponsiveUtils.size(
                                    context,
                                    mobile: 35,
                                    tablet: 40,
                                    desktop: 45,
                                  ),
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                        SizedBox(
                          width: ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                        // Profile Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.name ?? 'User',
                                style: AppTextStyles.h3.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 18,
                                    tablet: 20,
                                    desktop: 22,
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
                                profile?.email ?? '',
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
                            ],
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.edit,
                            color: AppColors.primary,
                            size: ResponsiveUtils.size(
                              context,
                              mobile: 24,
                              tablet: 26,
                              desktop: 28,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: const MyProfileScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),

                  // Menu Options
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _MenuTile(
                          icon: Icons.person_outline,
                          title: 'My Profile',
                          subtitle: 'My Information and details',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: const MyProfileScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                        _buildDivider(context),
                        _MenuTile(
                          icon: Icons.favorite_border,
                          title: 'Saved',
                          subtitle: 'Saved Advertisements',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: const SavedPropertiesScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                        _buildDivider(context),
                        _MenuTile(
                          icon: Icons.calendar_today_outlined,
                          title: 'My Reservations',
                          subtitle: 'Reservations, Orders',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: const MyReservationsScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Host Options Section
                  if (isHost) ...[
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 32,
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.spacing(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 32,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Host Management',
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
                      ),
                    ),
                    
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 8,
                        tablet: 10,
                        desktop: 12,
                      ),
                    ),
                    
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          _MenuTile(
                            icon: Icons.home_work_outlined,
                            title: 'My Properties',
                            subtitle: 'Manage your listed properties',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => getIt<PropertyManagementBloc>(),
                                    child: const MyPropertiesScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildDivider(context),
                          _MenuTile(
                            icon: Icons.add_home_outlined,
                            title: 'Add New Property',
                            subtitle: 'List a new property',
                            onTap: () {
                              Navigator.pushNamed(context, '/rent-create');
                            },
                          ),
                          _buildDivider(context),
                          _MenuTile(
                            icon: Icons.analytics_outlined,
                            title: 'Analytics',
                            subtitle: 'View performance and earnings',
                            onTap: () {
                              // TODO: Navigate to analytics screen
                            },
                          ),
                          _buildDivider(context),
                          _MenuTile(
                            icon: Icons.payment_outlined,
                            title: 'Payment Methods',
                            subtitle: 'Manage your payment information',
                            onTap: () {
                              // TODO: Navigate to payment methods screen
                            },
                          ),
                          _buildDivider(context),
                          _MenuTile(
                            icon: Icons.reviews_outlined,
                            title: 'Reviews',
                            subtitle: 'View and respond to guest reviews',
                            onTap: () {
                              // TODO: Navigate to reviews screen
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),

                  // Options Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 32,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Options',
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
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),

                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _MenuTile(
                          icon: Icons.help_outline,
                          title: 'Help',
                          subtitle: 'About us, Terms of conditions, Support',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => getIt<HelpBloc>(),
                                  child: const HelpScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                        _buildDivider(context),
                        _MenuTile(
                          icon: Icons.star_outline,
                          title: 'Rate App',
                          subtitle: 'Go To Google Play',
                          onTap: () {
                            // TODO: Open app store
                          },
                        ),
                        _buildDivider(context),
                        _MenuTile(
                          icon: Icons.share_outlined,
                          title: 'Share App',
                          subtitle: 'Share Our App To People',
                          onTap: () {
                            _shareApp(context);
                          },
                        ),
                        _buildDivider(context),
                        _MenuTile(
                          icon: Icons.logout,
                          title: 'Log Out',
                          subtitle: 'Account',
                          iconColor: Colors.red,
                          textColor: Colors.red,
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[100],
      indent: ResponsiveUtils.spacing(
        context,
        mobile: 20,
        tablet: 24,
        desktop: 32,
      ),
      endIndent: ResponsiveUtils.spacing(
        context,
        mobile: 20,
        tablet: 24,
        desktop: 32,
      ),
    );
  }

  void _shareApp(BuildContext context) {
    Share.share(
      'Check out Ahlan Feekum - Your trusted property rental app! '
      'Download now: https://play.google.com/store/apps/details?id=com.example.ahlanfeekum',
      subject: 'Ahlan Feekum - Property Rental App',
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // Close dialog
            Navigator.of(dialogContext).pop();

            // Navigate to auth options screen
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: getIt<AuthBloc>(),
                  child: const AuthOptionsScreen(),
                ),
              ),
              (route) => false,
            );

            context.showSnackBar('Logged out successfully');
          } else if (state is AuthError) {
            Navigator.of(dialogContext).pop();
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ),
          title: Text(
            'Log Out',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                return TextButton(
                  onPressed: () {
                    print('🔴 [LOGOUT] User confirmed logout');
                    context.read<AuthBloc>().add(const LogoutEvent());
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 32,
          ),
          vertical: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.textSecondary,
              size: ResponsiveUtils.size(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
                      ),
                      color: textColor,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 2,
                      tablet: 3,
                      desktop: 4,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                          textColor?.withOpacity(0.7) ??
                          AppColors.textSecondary,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 13,
                        tablet: 14,
                        desktop: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: iconColor ?? AppColors.textSecondary,
              size: ResponsiveUtils.size(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

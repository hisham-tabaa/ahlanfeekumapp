import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/pages/home_screen.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../reservations/presentation/pages/upcoming_reservations_screen.dart';
import '../../../reservations/presentation/bloc/reservation_bloc.dart';
import '../../../profile/presentation/pages/settings_menu_screen.dart';
import '../../../profile/presentation/pages/saved_properties_screen.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/auth_options_screen.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/responsive_utils.dart';
// BLoCs are now provided by the route in AppRouter
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Create BLoC instances
  late final HomeBloc _homeBloc;
  ReservationBloc? _reservationBloc; // Lazy load reservations
  ProfileBloc? _favoritesBloc; // Separate BLoC for favorites tab
  ProfileBloc? _settingsBloc; // Separate BLoC for settings tab

  // Track which tabs have been loaded
  bool _reservationsLoaded = false;
  bool _favoritesLoaded = false;
  bool _settingsLoaded = false;

  @override
  void initState() {
    super.initState();

    // Only initialize HomeBloc on startup
    _homeBloc = getIt<HomeBloc>()..add(const LoadHomeDataEvent());
    
    // Check if user is a host and redirect to settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated && authState.user.roleId == 1) {
        setState(() {
          _currentIndex = 3; // Settings page index
        });
      }
    });
  }

  List<Widget> _getPages(AuthState authState) {
    final isAuthenticated = authState is AuthAuthenticated;

    // Lazy load reservations BLoC when tab is accessed (only for authenticated users)
    if (_currentIndex == 2 && !_reservationsLoaded && isAuthenticated) {
      _reservationBloc = getIt<ReservationBloc>();
      _reservationsLoaded = true;
    }

    if (isAuthenticated) {
      // Lazy load favorites BLoC only when tab is accessed
      if (_currentIndex == 1 && !_favoritesLoaded) {
        _favoritesBloc = getIt<ProfileBloc>()..add(const LoadProfileEvent());
        _favoritesLoaded = true;
      }

      // Lazy load settings BLoC only when tab is accessed
      if (_currentIndex == 3 && !_settingsLoaded) {
        _settingsBloc = getIt<ProfileBloc>()..add(const LoadProfileEvent());
        _settingsLoaded = true;
      }

      return [
        BlocProvider.value(value: _homeBloc, child: const HomeScreen()),
        _favoritesBloc != null
            ? BlocProvider.value(
                value: _favoritesBloc!,
                child: const SavedPropertiesScreen(),
              )
            : const Center(child: CircularProgressIndicator()),
        _reservationBloc != null
            ? BlocProvider.value(
                value: _reservationBloc!,
                child: const UpcomingReservationsScreen(),
              )
            : const Center(child: CircularProgressIndicator()),
        _settingsBloc != null
            ? BlocProvider.value(
                value: _settingsBloc!,
                child: const SettingsMenuScreen(),
              )
            : const Center(child: CircularProgressIndicator()),
      ];
    } else {
      // Guest user pages - same layout but with restrictions
      return [
        BlocProvider.value(value: _homeBloc, child: const HomeScreen()),
        _GuestRestrictedScreen(
          title: 'Saved Properties',
          icon: Icons.favorite_border,
          description:
              'Sign in to save your favorite properties and access them anytime.',
          onContinueBrowsing: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        ),
        _GuestRestrictedScreen(
          title: 'Upcoming Reservations',
          icon: Icons.calendar_today_outlined,
          description:
              'Sign in to view your upcoming reservations and manage your bookings.',
          onContinueBrowsing: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        ),
        _GuestRestrictedScreen(
          title: 'Settings',
          icon: Icons.settings_outlined,
          description:
              'Sign in to access your profile settings, reservations, and account preferences.',
          onContinueBrowsing: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        ),
      ];
    }
  }

  @override
  void dispose() {
    _homeBloc.close();
    _reservationBloc?.close();
    _favoritesBloc?.close();
    _settingsBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final pages = _getPages(authState);
        final useDesktopNav = ResponsiveUtils.shouldUseDesktopNav(context);

        if (useDesktopNav) {
          // Desktop layout with side navigation
          return Scaffold(
            body: Row(
              children: [
                _buildSideNavigation(authState),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: pages),
                ),
              ],
            ),
          );
        } else {
          // Mobile/Tablet layout with bottom navigation
          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: IndexedStack(index: _currentIndex, children: pages),
            ),
            bottomNavigationBar: _buildBottomNavigation(authState),
            extendBody: false,
          );
        }
      },
    );
  }

  Widget _buildBottomNavigation(AuthState authState) {
    final isAuthenticated = authState is AuthAuthenticated;

    // Check if user has permission to create rent (roleId 1 for host or 0 for admin)
    bool canCreateRent = false;
    if (authState is AuthAuthenticated) {
      final roleId = authState.user.roleId;
      canCreateRent = roleId == 1 || roleId == 0;
    }

    // Wrap with SafeArea to handle system navigation (Samsung buttons, etc.)
    return SafeArea(
      top: false,
      child: Container(
        height: ResponsiveUtils.size(
          context,
          mobile: 70,
          tablet: 80,
          desktop: 90,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom > 0 
              ? ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)
              : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_filled, label: 'Home', index: 0),
              _buildNavItem(
                icon: _currentIndex == 1
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: isAuthenticated ? 'Favorite' : 'Saved',
                index: 1,
              ),
              // Only show add button for users with roleId 1 (host) or 0 (admin)
              if (canCreateRent) _buildAddButton(),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                label: 'Reservations',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.grey[400],
            size: ResponsiveUtils.size(
              context,
              mobile: 24,
              tablet: 26,
              desktop: 28,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 4,
              tablet: 6,
              desktop: 8,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive ? AppColors.primary : Colors.grey[400],
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 10,
                tablet: 11,
                desktop: 12,
              ),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    final buttonSize = ResponsiveUtils.size(
      context,
      mobile: 50,
      tablet: 56,
      desktop: 60,
    );
    
    return GestureDetector(
      onTap: () {
        _navigateToAddProperty();
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: ResponsiveUtils.size(
            context,
            mobile: 28,
            tablet: 32,
            desktop: 36,
          ),
        ),
      ),
    );
  }

  void _navigateToAddProperty() {
    Navigator.pushNamed(context, '/rent-create');
  }

  // Desktop side navigation
  Widget _buildSideNavigation(AuthState authState) {
    final isAuthenticated = authState is AuthAuthenticated;
    bool canCreateRent = false;
    if (authState is AuthAuthenticated) {
      final roleId = authState.user.roleId;
      canCreateRent = roleId == 1 || roleId == 0;
    }

    return Container(
      width: ResponsiveUtils.size(
        context,
        mobile: 240,
        tablet: 260,
        desktop: 280,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Logo/Title
            Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              child: Text(
                'Ahlan Feekum',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    mobile: 24,
                    tablet: 26,
                    desktop: 28,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 12,
                    desktop: 16,
                  ),
                ),
                children: [
                  _buildSideNavItem(
                    icon: Icons.home_filled,
                    label: 'Home',
                    index: 0,
                  ),
                  _buildSideNavItem(
                    icon: Icons.favorite,
                    label: isAuthenticated ? 'Favorite' : 'Saved',
                    index: 1,
                  ),
                  _buildSideNavItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Reservations',
                    index: 2,
                  ),
                  _buildSideNavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    index: 3,
                  ),
                ],
              ),
            ),

            // Add Property Button (for hosts)
            if (canCreateRent) ...[
              const Divider(),
              Padding(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: _navigateToAddProperty,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Property'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(
                      double.infinity,
                      ResponsiveUtils.size(
                        context,
                        mobile: 48,
                        tablet: 52,
                        desktop: 56,
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
                  ),
                ),
              ),
            ],
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
          vertical: ResponsiveUtils.spacing(
            context,
            mobile: 4,
            tablet: 6,
            desktop: 8,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
          vertical: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
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
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : Colors.grey[600],
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
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.primary : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
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

// Guest restricted screen widget
class _GuestRestrictedScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onContinueBrowsing;

  const _GuestRestrictedScreen({
    required this.title,
    required this.icon,
    required this.description,
    required this.onContinueBrowsing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.size(
              context,
              mobile: double.infinity,
              tablet: 500,
              desktop: 600,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: ResponsiveUtils.size(
                    context,
                    mobile: 100,
                    tablet: 120,
                    desktop: 140,
                  ),
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 100,
                    tablet: 120,
                    desktop: 140,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: ResponsiveUtils.size(
                      context,
                      mobile: 50,
                      tablet: 60,
                      desktop: 70,
                    ),
                    color: AppColors.primary,
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

                // Title
                Text(
                  'Sign in to access $title',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                ),

                // Description
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 32,
                    tablet: 40,
                    desktop: 48,
                  ),
                ),

                // Sign in button
                CustomButton(
                  text: 'Sign In',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AuthOptionsScreen(),
                      ),
                    );
                  },
                  width: double.infinity,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),

                // Continue browsing button
                CustomButton(
                  text: 'Continue Browsing',
                  onPressed: onContinueBrowsing,
                  width: double.infinity,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.textSecondary,
                  borderColor: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

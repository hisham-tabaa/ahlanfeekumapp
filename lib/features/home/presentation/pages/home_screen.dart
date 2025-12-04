import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

// Import separated widgets
import '../widgets/home_header_widget.dart';
import '../widgets/advertisement_banner_widget.dart';
import '../widgets/special_stays_widget.dart';
import '../widgets/highly_rated_properties_widget.dart';
import '../widgets/discover_section_widget.dart';
import '../widgets/hotels_of_week_widget.dart';
import '../widgets/only_for_you_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _showExitDialog(context);
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: null,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: ResponsiveUtils.size(
                        context,
                        mobile: 64,
                        tablet: 72,
                        desktop: 80,
                      ),
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    Text(
                      'Something went wrong',
                      style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 8,
                        tablet: 12,
                        desktop: 16,
                      ),
                    ),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.read<HomeBloc>().add(
                        const LoadHomeDataEvent(),
                      ),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(const RefreshHomeDataEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ResponsiveLayout(
                    child: Column(
                      children: [
                        // Header with profile and search
                        HomeHeaderWidget(
                          userProfile: state.homeData.userProfile,
                        ),

                        // Special Advertisement Banner
                        AdvertisementBannerWidget(
                          ads: state.homeData.specialAdvertisements,
                        ),

                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            mobile: 15,
                            tablet: 20,
                            desktop: 24,
                          ),
                        ),

                        // Special Stays Section
                        SpecialStaysWidget(
                          properties: state.homeData.siteProperties,
                        ),

                        // Highly Rated Properties
                        HighlyRatedPropertiesWidget(
                          properties: state.homeData.highlyRatedProperties,
                        ),

                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            mobile: 8,
                            tablet: 12,
                            desktop: 16,
                          ),
                        ),

                        // Discover Section
                        DiscoverSectionWidget(
                          governorates: state.homeData.governorates,
                        ),

                        // Hotels of the Week
                        HotelsOfWeekWidget(
                          hotels: state.homeData.hotelsOfTheWeek ?? const [],
                        ),

                        // Only For You Section
                        OnlyForYouWidget(
                          onlyForYouSection: state.homeData.onlyForYouSection,
                        ),

                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            mobile: 100,
                            tablet: 120,
                            desktop: 140,
                          ),
                        ), // Bottom padding for navigation
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App?'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  // Exit the app
                  SystemNavigator.pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/property_management_bloc.dart';
import '../bloc/property_management_event.dart';
import '../bloc/property_management_state.dart';
import 'property_calendar_screen.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  Locale? _previousLocale;

  @override
  void initState() {
    super.initState();
    context.read<PropertyManagementBloc>().add(const LoadHostPropertiesEvent());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_properties'.tr()),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/rent-create');
            },
          ),
        ],
      ),
      body: BlocBuilder<PropertyManagementBloc, PropertyManagementState>(
        builder: (context, state) {
          if (state.isLoadingProperties) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
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
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  Text(state.error!, style: AppTextStyles.bodyMedium),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PropertyManagementBloc>().add(
                        const LoadHostPropertiesEvent(),
                      );
                    },
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }

          if (state.properties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: ResponsiveUtils.size(
                      context,
                      mobile: 64,
                      tablet: 72,
                      desktop: 80,
                    ),
                    color: AppColors.textSecondary,
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
                    'no_properties_yet'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textSecondary,
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
                  Text(
                    'start_listing_first_property'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
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
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/rent-create');
                    },
                    icon: const Icon(Icons.add),
                    label: Text('add_property'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.spacing(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                        vertical: ResponsiveUtils.spacing(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<PropertyManagementBloc>().add(
                const LoadHostPropertiesEvent(),
              );
            },
            child: ListView.builder(
              cacheExtent: 500, // Preload items for smoother scrolling
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              addAutomaticKeepAlives: true,
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
              ),
              itemCount: state.properties.length,
              itemBuilder: (context, index) {
                final property = state.properties[index];
                return _PropertyCard(property: property);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final dynamic property;

  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
      child: InkWell(
        onTap: () {
          context.read<PropertyManagementBloc>().add(
            SelectPropertyEvent(propertyId: property.id),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PropertyManagementBloc>(),
                child: PropertyCalendarScreen(property: property),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: property.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: property.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.home_work_outlined,
                          size: ResponsiveUtils.size(
                            context,
                            mobile: 48,
                            tablet: 56,
                            desktop: 64,
                          ),
                          color: Colors.grey[400],
                        ),
                      ),
              ),
            ),
            // Property Details
            Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: AppTextStyles.h3.copyWith(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Status Toggle
                      Switch(
                        value: property.isActive,
                        onChanged: (value) {
                          context.read<PropertyManagementBloc>().add(
                            TogglePropertyStatusEvent(
                              propertyId: property.id,
                              isActive: value,
                            ),
                          );
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                  if (property.location != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: ResponsiveUtils.size(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(
                          width: ResponsiveUtils.spacing(
                            context,
                            mobile: 4,
                            tablet: 5,
                            desktop: 6,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            property.location!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 12,
                      tablet: 14,
                      desktop: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '\$${property.price.toStringAsFixed(0)}/${'night'.tr()}',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                      ),
                      // Rating
                      if (property.rating != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: ResponsiveUtils.size(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 20,
                              ),
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: ResponsiveUtils.spacing(
                                context,
                                mobile: 4,
                                tablet: 5,
                                desktop: 6,
                              ),
                            ),
                            Text(
                              property.rating!.toStringAsFixed(1),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      // Bookings
                      if (property.totalBookings != null)
                        Text(
                          'bookings_count'.tr().replaceAll('{0}', property.totalBookings.toString()),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        mobile: 4,
                        tablet: 5,
                        desktop: 6,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: property.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    child: Text(
                      property.isActive ? 'active'.tr() : 'inactive'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: property.isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_event.dart';
import '../../domain/entities/reservation.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  ReservationStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // Load reservations when screen initializes
    context.read<ProfileBloc>().add(const LoadMyReservationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('my_reservations'.tr()),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.isLoadingReservations) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveUtils.size(
                      context,
                      mobile: 80,
                      tablet: 90,
                      desktop: 100,
                    ),
                    color: Colors.red[400],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  Text(
                    'Error Loading Reservations',
                    style: AppTextStyles.h3.copyWith(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                      color: AppColors.textPrimary,
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
                    state.errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
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
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        const LoadMyReservationsEvent(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allReservations = state.myReservations;
          final filteredReservations = _selectedFilter == null
              ? allReservations
              : allReservations
                    .where((r) => r.status == _selectedFilter)
                    .toList();

          if (allReservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: ResponsiveUtils.size(
                      context,
                      mobile: 80,
                      tablet: 90,
                      desktop: 100,
                    ),
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  Text(
                    'No Reservations',
                    style: AppTextStyles.h3.copyWith(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                      color: AppColors.textPrimary,
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
                    'You have no reservations yet',
                    style: AppTextStyles.bodySmall.copyWith(
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
                ],
              ),
            );
          }

          return ResponsiveLayout(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(
                  const LoadMyReservationsEvent(),
                );
              },
              child: Column(
                children: [
                  // Filter chips
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All Reservation', null),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                          ),
                          _buildFilterChip(
                            'Confirmed',
                            ReservationStatus.approved,
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                          ),
                          _buildFilterChip(
                            'Pending',
                            ReservationStatus.pending,
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                          ),
                          _buildFilterChip(
                            'Not Available',
                            ReservationStatus.declined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Reservations list
                  Expanded(
                    child:
                        ResponsiveUtils.isDesktop(context) ||
                            ResponsiveUtils.isTablet(context)
                        ? _buildDesktopReservationsList(filteredReservations)
                        : _buildMobileReservationsList(filteredReservations),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, ReservationStatus? status) {
    final isSelected = _selectedFilter == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = status;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
          vertical: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileReservationsList(List<Reservation> reservations) {
    return ListView.builder(
      cacheExtent: 500, // Preload items for smoother scrolling
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      addAutomaticKeepAlives: true,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        ),
      ),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return _ReservationCard(reservation: reservation);
      },
    );
  }

  Widget _buildDesktopReservationsList(List<Reservation> reservations) {
    final crossAxisCount = ResponsiveUtils.responsive(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );

    return GridView.builder(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsive(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: ResponsiveUtils.responsive(
          context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        ),
        mainAxisSpacing: ResponsiveUtils.responsive(
          context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        ),
        childAspectRatio: ResponsiveUtils.responsive(
          context,
          mobile: 0.75,
          tablet: 0.8,
          desktop: 0.85,
        ),
      ),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return _ReservationCard(reservation: reservation, isDesktop: true);
      },
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final bool isDesktop;

  const _ReservationCard({required this.reservation, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isDesktop 
          ? EdgeInsets.zero 
          : EdgeInsets.only(
              bottom: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.responsive(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDesktop ? 0.08 : 0.05),
            blurRadius: ResponsiveUtils.responsive(
              context,
              mobile: 10,
              tablet: 15,
              desktop: 20,
            ),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image and status badge
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: ResponsiveUtils.responsive(
                  context,
                  mobile: 120,
                  tablet: 140,
                  desktop: 160,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      ResponsiveUtils.responsive(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                  ),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      ResponsiveUtils.responsive(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                  ),
                  child: CachedNetworkImage(
                          imageUrl: reservation.propertyMainImage,
                          width: double.infinity,
                    height: ResponsiveUtils.responsive(
                      context,
                            mobile: 120,
                            tablet: 140,
                            desktop: 160,
                          ),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                          strokeWidth: ResponsiveUtils.size(
                            context,
                            mobile: 2,
                            tablet: 2.5,
                            desktop: 3,
                          ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                        size: ResponsiveUtils.size(
                          context,
                          mobile: 40,
                          tablet: 44,
                          desktop: 48,
                        ),
                            ),
                          ),
                        ),
                ),
              ),
              // Status badge
              Positioned(
                top: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                left: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                    vertical: ResponsiveUtils.spacing(
                      context,
                      mobile: 4,
                      tablet: 5,
                      desktop: 6,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(reservation.status),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 8,
                        tablet: 10,
                        desktop: 12,
                      ),
                    ),
                  ),
                  child: Text(
                    reservation.status.displayName,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 12,
                        tablet: 13,
                        desktop: 14,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // More options button
              Positioned(
                top: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                right: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                child: Container(
                  width: ResponsiveUtils.size(
                    context,
                    mobile: 32,
                    tablet: 36,
                    desktop: 40,
                  ),
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 32,
                    tablet: 36,
                    desktop: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: ResponsiveUtils.size(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Reservation details
          Padding(
            padding: EdgeInsets.all(
              ResponsiveUtils.responsive(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property title
                Text(
                  reservation.propertyTitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.responsive(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                // Property details row
                Row(
                  children: [
                    // Area
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.square_foot,
                            size: ResponsiveUtils.size(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 4,
                              tablet: 5,
                              desktop: 6,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              reservation.propertyArea,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 12,
                                  tablet: 13,
                                  desktop: 14,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                    // Location
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: ResponsiveUtils.size(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 4,
                              tablet: 5,
                              desktop: 6,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Damascus, Al Qusor', // You can add location to reservation model
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 12,
                                  tablet: 13,
                                  desktop: 14,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                // Date and property type row
                Row(
                  children: [
                    // Date
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: ResponsiveUtils.size(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 4,
                              tablet: 5,
                              desktop: 6,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              _formatDate(reservation.fromDate),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 12,
                                  tablet: 13,
                                  desktop: 14,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                    // Property type (you can add this to reservation model)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            size: ResponsiveUtils.size(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              mobile: 4,
                              tablet: 5,
                              desktop: 6,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Hotel', // Default or from reservation data
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 12,
                                  tablet: 13,
                                  desktop: 14,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
                // Price and days left
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${reservation.price.toStringAsFixed(0)} \$',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 18,
                                tablet: 20,
                                desktop: 22,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' / Night',
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
                        ],
                      ),
                    ),
                    Text(
                      '${reservation.daysLeft} Days Left',
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.approved:
        return Colors.green;
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.declined:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd - MMM - yyyy').format(date);
  }
}

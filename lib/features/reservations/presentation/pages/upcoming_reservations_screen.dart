import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/reservation_bloc.dart';
import '../bloc/reservation_event.dart';
import '../bloc/reservation_state.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';
import '../../../../core/utils/web_scroll_behavior.dart';

class UpcomingReservationsScreen extends StatefulWidget {
  const UpcomingReservationsScreen({super.key});

  @override
  State<UpcomingReservationsScreen> createState() =>
      _UpcomingReservationsScreenState();
}

class _UpcomingReservationsScreenState
    extends State<UpcomingReservationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load upcoming reservations when the screen initializes
    context.read<ReservationBloc>().add(const LoadUpcomingReservationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'upcoming_reservations'.tr(),
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ReservationBloc>().add(
                const RefreshReservationsEvent(),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          if (state is ReservationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ReservationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveUtils.fontSize(context, mobile: 64, tablet: 72, desktop: 80),
                    color: AppColors.error,
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
                  Text(
                    'error_loading_reservations'.tr(),
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(context, mobile: 32, tablet: 36, desktop: 40)),
                    child: Text(
                      state.message.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReservationBloc>().add(
                        const LoadUpcomingReservationsEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16)),
                      ),
                    ),
                    child: Text(
                      'retry'.tr(),
                      style: AppTextStyles.buttonText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ReservationLoaded) {
            if (state.reservations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: ResponsiveUtils.fontSize(context, mobile: 64, tablet: 72, desktop: 80),
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
                    Text(
                      'no_upcoming_reservations'.tr(),
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                    Text(
                      'no_upcoming_reservations_message'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ResponsiveLayout(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ReservationBloc>().add(
                    const RefreshReservationsEvent(),
                  );
                },
                child: WebScrollUtils.listView(
                  padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
                  itemCount: state.reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = state.reservations[index];
                    return _buildReservationCard(reservation);
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReservationCard(ReservationEntity reservation) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image and Status
          Stack(
            children: [
              Container(
                height: ResponsiveUtils.size(context, mobile: 200, tablet: 230, desktop: 260),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
                  ),
                  color: AppColors.inputBackground,
                ),
                child:
                    reservation.propertyMainImage != null &&
                        reservation.propertyMainImage!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
                        ),
                        child: WebCompatibleNetworkImage(
                          imageUrl: reservation.propertyMainImage!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return _buildPlaceholderImage();
                          },
                        ),
                      )
                    : _buildPlaceholderImage(),
              ),
              Positioned(
                top: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                right: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                    vertical: ResponsiveUtils.spacing(context, mobile: 6, tablet: 7, desktop: 8),
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(reservation.reservationStatus),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 20, tablet: 22, desktop: 24)),
                  ),
                  child: Text(
                    reservation.reservationStatusAsString,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Reservation Details
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Title
                Text(
                  reservation.propertyTitle,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),

                // Dates
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      color: AppColors.primary,
                    ),
                    SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                    Text(
                      '${_formatDate(reservation.fromDateTime)} - ${_formatDate(reservation.toDateTime)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),

                // Guests
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      color: AppColors.primary,
                    ),
                    SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                    Text(
                      '${reservation.numberOfGuest} Guest${reservation.numberOfGuest > 1 ? 's' : ''}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                if (reservation.price > 0) ...[
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        color: AppColors.primary,
                      ),
                      SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                      Text(
                        '\$${reservation.price.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (reservation.discount > 0) ...[
                        SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                        Text(
                          '(Discount: \$${reservation.discount.toStringAsFixed(2)})',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Host Info
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
                Row(
                  children: [
                    CircleAvatar(
                      radius: ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
                      backgroundImage:
                          reservation.ownerProfilePhoto != null &&
                              reservation.ownerProfilePhoto!.isNotEmpty
                          ? NetworkImage(reservation.ownerProfilePhoto!)
                          : null,
                      backgroundColor: AppColors.inputBackground,
                      child:
                          reservation.ownerProfilePhoto == null ||
                              reservation.ownerProfilePhoto!.isEmpty
                          ? Icon(
                              Icons.person,
                              size: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                    Text(
                      'Host: ${reservation.ownerName}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                if (reservation.notes != null &&
                    reservation.notes!.isNotEmpty) ...[
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                        Expanded(
                          child: Text(
                            reservation.notes!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20))),
      ),
      child: Center(
        child: Icon(
          Icons.home_outlined,
          size: ResponsiveUtils.fontSize(context, mobile: 48, tablet: 52, desktop: 56),
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.orange; // Pending
      case 2:
        return Colors.green; // Confirmed
      case 3:
        return Colors.red; // Cancelled
      case 4:
        return Colors.blue; // Completed
      default:
        return Colors.grey; // Unknown
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


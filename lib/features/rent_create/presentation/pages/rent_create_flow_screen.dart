import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theming/colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/rent_create_bloc.dart';
import '../bloc/rent_create_event.dart';
import '../bloc/rent_create_state.dart';
import '../../domain/entities/rent_create_entities.dart';
import 'steps/property_details_step.dart';
import 'steps/photos_step.dart';
import 'steps/price_step.dart';
import 'steps/location_step.dart';
import 'steps/availability_step.dart';
import 'steps/review_step.dart';
import 'widgets/progress_step_indicator.dart';

class RentCreateFlowScreen extends StatefulWidget {
  const RentCreateFlowScreen({super.key});

  @override
  State<RentCreateFlowScreen> createState() => _RentCreateFlowScreenState();
}

class _RentCreateFlowScreenState extends State<RentCreateFlowScreen> {
  final PageController _pageController = PageController();
  DateTime? _lastNavigationTime;
  Locale? _previousLocale;

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reference locale to ensure widget rebuilds when language changes
    context.locale;

    return BlocListener<RentCreateBloc, RentCreateState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          // Clear the message after showing
          context.read<RentCreateBloc>().add(const ClearMessagesEvent());
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          // Clear the message after showing
          context.read<RentCreateBloc>().add(const ClearMessagesEvent());
        }

        // Auto-navigate to next step for specific successful statuses
        if (state.status == RentCreateStatus.availabilityAdded) {
          final now = DateTime.now();
          if (_lastNavigationTime == null ||
              now.difference(_lastNavigationTime!).inSeconds > 2) {
            _lastNavigationTime = now;
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {}
        }

        // Auto-navigate to next step when images are uploaded
        if (state.status == RentCreateStatus.imagesUploaded) {
          final now = DateTime.now();
          // Prevent rapid multiple navigations
          if (_lastNavigationTime == null ||
              now.difference(_lastNavigationTime!).inSeconds > 2) {
            _lastNavigationTime = now;
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {}
        }

        // Auto-navigate to next step when price is set
        if (state.status == RentCreateStatus.priceSet) {
          final now = DateTime.now();
          if (_lastNavigationTime == null ||
              now.difference(_lastNavigationTime!).inSeconds > 2) {
            _lastNavigationTime = now;
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {}
        }

        // Navigate to completion screen when property is submitted
        if (state.status == RentCreateStatus.propertySubmitted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PropertyCreatedSuccessScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => _showExitDialog(context),
          ),
          title: Text(
            'add_property'.tr(),
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.responsive(
                context,
                mobile: double.infinity,
                tablet: 800,
                desktop: 1000,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 30,
                    tablet: 35,
                    desktop: 40,
                  ),
                ),
                _buildStepIndicator(),
                Expanded(child: _buildStepContent()),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 80,
                    tablet: 90,
                    desktop: 100,
                  ),
                ), // Space for floating buttons
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildStepIndicator() {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return Column(
          children: [
            ProgressStepIndicator(steps: state.steps),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepContent() {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            context.read<RentCreateBloc>().add(NavigateToStepEvent(index));
          },
          children: [
            const PropertyDetailsStep(),
            const LocationStep(),
            const AvailabilityStep(),
            const PhotosStep(),
            const PriceStep(),
            const ReviewStep(),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButtons() {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            // Check if user has permission to create rent (roleId 1 for host or 0 for admin)
            bool hasPermission = false;
            if (authState is AuthAuthenticated) {
              final roleId = authState.user.roleId;
              hasPermission = roleId == 1 || roleId == 0;
            }

            // If on review step and user doesn't have permission, hide the create button
            final isReviewStep =
                state.currentStep == PropertyCreationStep.review;
            final shouldShowButton = !isReviewStep || hasPermission;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
              ),
              child: Builder(
                builder: (context) {
                  final isRTL = context.locale.languageCode == 'ar';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button (white with arrow)
                      if (state.canGoPrevious)
                        FloatingActionButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<RentCreateBloc>().add(
                                    const PreviousStepEvent(),
                                  );
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          backgroundColor: Colors.white,
                          elevation: 4,
                          heroTag: "previous_btn",
                          child: Icon(
                            isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                            color: AppColors.textPrimary,
                            size: ResponsiveUtils.fontSize(
                              context,
                              mobile: 20,
                              tablet: 21,
                              desktop: 22,
                            ),
                          ),
                        ),

                      // Continue/Create button (red with arrow)
                      if (shouldShowButton)
                        FloatingActionButton(
                          onPressed: state.canGoNext && !state.isLoading
                              ? () => _handleNextButton(context, state)
                              : null,
                          backgroundColor: state.canGoNext && !state.isLoading
                              ? AppColors.primary
                              : Colors.grey[400],
                          elevation: 4,
                          heroTag: "continue_btn",
                          child: state.isLoading
                              ? SizedBox(
                                  width: ResponsiveUtils.size(
                                    context,
                                    mobile: 20,
                                    tablet: 21,
                                    desktop: 22,
                                  ),
                                  height: ResponsiveUtils.size(
                                    context,
                                    mobile: 20,
                                    tablet: 21,
                                    desktop: 22,
                                  ),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Icon(
                                  isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 20,
                                    tablet: 21,
                                    desktop: 22,
                                  ),
                                ),
                        ),

                  // Show permission message if user doesn't have access on review step
                  if (isReviewStep && !hasPermission)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(
                          ResponsiveUtils.spacing(
                            context,
                            mobile: 12,
                            tablet: 13,
                            desktop: 14,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 8,
                              tablet: 9,
                              desktop: 10,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'only_hosts_admins_create_rent'.tr(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _handleNextButton(BuildContext context, RentCreateState state) {
    final bloc = context.read<RentCreateBloc>();

    if (state.isLastStep) {
      // Submit the property
      bloc.add(const SubmitPropertyEvent());
    } else {
      // Move to next step
      switch (state.currentStep) {
        case PropertyCreationStep.propertyDetails:
          // Create property in first step if not already created
          if (state.formData.propertyId == null) {
            bloc.add(const CreatePropertyStepOneEvent());

            // Navigate after API completes successfully
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!bloc.isClosed &&
                  !bloc.state.isLoading &&
                  bloc.state.errorMessage == null &&
                  bloc.state.formData.propertyId != null) {
                bloc.add(const NextStepEvent());
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else if (!bloc.isClosed) {}
            });
          } else {
            bloc.add(const NextStepEvent());
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          return;
        case PropertyCreationStep.location:
          // Update location details with step two API
          bloc.add(const CreatePropertyStepTwoEvent());

          // Navigate after API completes successfully
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!bloc.isClosed &&
                !bloc.state.isLoading &&
                bloc.state.errorMessage == null) {
              bloc.add(const NextStepEvent());
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else if (!bloc.isClosed) {}
          });
          return;
        case PropertyCreationStep.availability:
          bloc.add(const AddAvailabilityEvent());
          // Navigation handled by BlocListener when availabilityAdded status is emitted
          return;
        case PropertyCreationStep.photos:
          bloc.add(const UploadImagesEvent());
          // Navigation handled by BlocListener when imagesUploaded status is emitted
          return;
        case PropertyCreationStep.price:
          bloc.add(const SetPriceEvent());
          // Navigation handled by BlocListener when priceSet status is emitted
          return;
        case PropertyCreationStep.review:
          bloc.add(const SubmitPropertyEvent());
          return;
      }
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('exit_property_creation'.tr()),
        content: Text('exit_property_creation_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('exit'.tr()),
          ),
        ],
      ),
    );
  }
}

class PropertyCreatedSuccessScreen extends StatefulWidget {
  const PropertyCreatedSuccessScreen({super.key});

  @override
  State<PropertyCreatedSuccessScreen> createState() =>
      _PropertyCreatedSuccessScreenState();
}

class _PropertyCreatedSuccessScreenState
    extends State<PropertyCreatedSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Locale? _previousLocale;

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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.03),
              Colors.white,
              Colors.green.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 40,
                  desktop: 60,
                ),
                right: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 40,
                  desktop: 60,
                ),
                top: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 32,
                  desktop: 40,
                ),
                bottom: ResponsiveUtils.spacing(
                  context,
                  mobile: 32,
                  tablet: 40,
                  desktop: 48,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 550 : double.infinity,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Success Icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: ResponsiveUtils.size(
                          context,
                          mobile: 120,
                          tablet: 140,
                          desktop: 160,
                        ),
                        height: ResponsiveUtils.size(
                          context,
                          mobile: 120,
                          tablet: 140,
                          desktop: 160,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: ResponsiveUtils.fontSize(
                            context,
                            mobile: 60,
                            tablet: 70,
                            desktop: 80,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                    ),

                    // Success Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'property_listed_successfully'.tr(),
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 26,
                            tablet: 30,
                            desktop: 34,
                          ),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                    ),

                    // Success Message
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'property_under_review_message'.tr(),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 15,
                            tablet: 16,
                            desktop: 17,
                          ),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                    ),

                    // Info Cards
                    _buildInfoCard(
                      context,
                      icon: Icons.hourglass_empty_rounded,
                      iconColor: Colors.orange,
                      iconBgColor: Colors.orange.withValues(alpha: 0.1),
                      title: 'under_review'.tr(),
                      description: 'property_review_timeline'.tr(),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),

                    _buildInfoCard(
                      context,
                      icon: Icons.notifications_active_rounded,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.blue.withValues(alpha: 0.1),
                      title: 'stay_updated'.tr(),
                      description: 'property_approval_notification'.tr(),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                    ),

                    // Tips Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.08),
                            AppColors.primary.withValues(alpha: 0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.radius(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.tips_and_updates_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'quick_tips'.tr(),
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.primary,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 16,
                                    tablet: 17,
                                    desktop: 18,
                                  ),
                                  fontWeight: FontWeight.bold,
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
                          _buildTipItem(context, 'tip_calendar_updated'.tr()),
                          _buildTipItem(context, 'tip_respond_quickly'.tr()),
                          _buildTipItem(
                            context,
                            'tip_enable_notifications'.tr(),
                          ),
                          _buildTipItem(
                            context,
                            'tip_high_quality_photos'.tr(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 40,
                        tablet: 48,
                        desktop: 56,
                      ),
                    ),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Reset form before navigation
                          try {
                            context.read<RentCreateBloc>().add(
                              const ResetFormEvent(),
                            );
                          } catch (e) {
                            // Bloc might not be available, continue navigation
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/main-navigation',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.spacing(
                              context,
                              mobile: 18,
                              tablet: 20,
                              desktop: 22,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.radius(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                            ),
                          ),
                          elevation: 0,
                          shadowColor: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_rounded,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 22,
                                tablet: 24,
                                desktop: 26,
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveUtils.spacing(
                                context,
                                mobile: 10,
                                tablet: 12,
                                desktop: 14,
                              ),
                            ),
                            Text(
                              'back_to_home'.tr(),
                              style: TextStyle(
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 17,
                                  desktop: 18,
                                ),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                    ),

                    // Secondary Action Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Reset form before navigation
                          try {
                            context.read<RentCreateBloc>().add(
                              const ResetFormEvent(),
                            );
                          } catch (e) {
                            // Bloc might not be available, continue navigation
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RentCreateFlowScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.spacing(
                              context,
                              mobile: 18,
                              tablet: 20,
                              desktop: 22,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.radius(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_business_rounded,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 22,
                                tablet: 24,
                                desktop: 26,
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveUtils.spacing(
                                context,
                                mobile: 10,
                                tablet: 12,
                                desktop: 14,
                              ),
                            ),
                            Text(
                              'add_another_property'.tr(),
                              style: TextStyle(
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 17,
                                  desktop: 18,
                                ),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 18, tablet: 20, desktop: 22),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 6,
                    tablet: 7,
                    desktop: 8,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 13,
                      tablet: 14,
                      desktop: 15,
                    ),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(
          context,
          mobile: 10,
          tablet: 12,
          desktop: 14,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

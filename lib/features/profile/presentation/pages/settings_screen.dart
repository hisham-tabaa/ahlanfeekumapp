import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/models/update_profile_request.dart';
import '../../data/models/change_password_request.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isProfilePhotoChanged = false;
  String? _profilePhotoPath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _populateFields(ProfileState state) {
    final profile = state.profile;
    if (profile == null) {
      return;
    }

    _nameController.text = profile.name;
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phoneNumber ?? '';
    _addressController.text = profile.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.updateSuccess) {
          context.showSnackBar('Profile updated successfully');
        }

        if (state.changePasswordSuccess) {
          context.showSnackBar('Password changed successfully');
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }

        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }

        if (state.profile != null) {
          _populateFields(state);
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(const RefreshProfileEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                _buildHeader(profile),
                SizedBox(height: 24.h),
                _buildStatistics(profile),
                SizedBox(height: 32.h),
                _buildEditProfileSection(context, state),
                SizedBox(height: 32.h),
                _buildChangePasswordSection(context, state),
                SizedBox(height: 32.h),
                _buildFavoritesSection(profile),
                SizedBox(height: 24.h),
                _buildMyPropertiesSection(profile),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(profile) {
    return Row(
      children: [
        _buildAvatar(profile?.profilePhotoUrl),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile?.name ?? '---',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                profile?.email ?? '',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<ProfileBloc>().add(const RefreshProfileEvent());
          },
        ),
      ],
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 40.w,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          backgroundImage: imageUrl != null
              ? CachedNetworkImageProvider(imageUrl)
              : null,
          child: imageUrl == null
              ? Icon(Icons.person, size: 40.sp, color: AppColors.textSecondary)
              : null,
        ),
        GestureDetector(
          onTap: _onPickProfilePhoto,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.w),
            ),
            child: Icon(Icons.edit, size: 16.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(profile) {
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: 'Completion',
              value: profile.speedOfCompletion.toStringAsFixed(1),
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              label: 'Dealing',
              value: profile.dealing.toStringAsFixed(1),
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              label: 'Cleanliness',
              value: profile.cleanliness.toStringAsFixed(1),
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              label: 'Perfection',
              value: profile.perfection.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileSection(BuildContext context, ProfileState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: AppTextStyles.h2.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _nameController,
            hintText: 'Full Name',
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _phoneController,
            hintText: 'Phone Number',
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _emailController,
            hintText: 'Email Address',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _addressController,
            hintText: 'Location',
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          CustomButton(
            text: 'Save Changes',
            isLoading: state.isUpdating,
            onPressed: () {
              final request = UpdateProfileRequest(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                latitude: state.profile?.latitude ?? '0',
                longitude: state.profile?.longitude ?? '0',
                address: _addressController.text.trim(),
                isProfilePhotoChanged: _isProfilePhotoChanged,
                profilePhotoPath: _profilePhotoPath,
              );

              context.read<ProfileBloc>().add(UpdateProfileEvent(request));
            },
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection(BuildContext context, ProfileState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Change')),
            ],
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: _oldPasswordController,
            hintText: 'Old Password',
            obscureText: true,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _newPasswordController,
            hintText: 'New Password',
            obscureText: true,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: 'Repeat New Password',
            obscureText: true,
          ),
          SizedBox(height: 24.h),
          CustomButton(
            text: 'Change Password',
            isLoading: state.isChangingPassword,
            onPressed: () {
              if (_newPasswordController.text !=
                  _confirmPasswordController.text) {
                context.showSnackBar('Passwords do not match', isError: true);
                return;
              }

              final request = ChangePasswordRequest(
                emailOrPhone: state.profile?.email ?? '',
                oldPassword: _oldPasswordController.text,
                newPassword: _newPasswordController.text,
              );

              context.read<ProfileBloc>().add(ChangePasswordEvent(request));
            },
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(profile) {
    final favorites = profile?.favoriteProperties;
    if (favorites == null || favorites.isEmpty) {
      return const SizedBox.shrink();
    }

    return _PropertiesSection(
      title: 'Saved',
      subtitle: 'Saved Advertisements',
      properties: favorites,
    );
  }

  Widget _buildMyPropertiesSection(profile) {
    final properties = profile?.myProperties;
    if (properties == null || properties.isEmpty) {
      return const SizedBox.shrink();
    }

    return _PropertiesSection(
      title: 'My Reservations',
      subtitle: 'Reservations, Orders',
      properties: properties,
    );
  }

  Future<void> _onPickProfilePhoto() async {
    // TODO: Implement image picker integration
    context.showSnackBar('Profile photo picker coming soon');
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h2.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40.h,
      color: AppColors.border,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }
}

class _PropertiesSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List properties;

  const _PropertiesSection({
    required this.title,
    required this.subtitle,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h2.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final property = properties[index];
              return _PropertyCard(property: property);
            },
          ),
        ),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final dynamic property;

  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final imageUrl = property.mainImageUrl;

    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 100.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 100.h,
                    color: AppColors.border,
                    child: Icon(Icons.image, color: AppColors.textSecondary),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  property.address ?? property.streetAndBuildingNumber ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${property.pricePerNight.toStringAsFixed(0)} SYP/night',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

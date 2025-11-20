import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:io';

import '../../../../core/utils/extensions.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/models/update_profile_request.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'change_password_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isProfilePhotoChanged = false;
  String? _profilePhotoPath;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _countryCode = '+963'; // Default to Syria

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final state = context.read<ProfileBloc>().state;
    _populateFieldsFromState(state);
  }

  String _parseCountryCode(String fullPhoneNumber) {
    // List of common country codes (sorted by length, longest first)
    const countryCodes = [
      '+1242',
      '+1246',
      '+1264',
      '+1268',
      '+1284',
      '+1340',
      '+1345',
      '+1441',
      '+1473',
      '+1649',
      '+1664',
      '+1670',
      '+1671',
      '+1684',
      '+1758',
      '+1767',
      '+1784',
      '+1809',
      '+1829',
      '+1849',
      '+1868',
      '+1869',
      '+1876',
      '+213',
      '+216',
      '+218',
      '+220',
      '+221',
      '+222',
      '+223',
      '+224',
      '+225',
      '+226',
      '+227',
      '+228',
      '+229',
      '+230',
      '+231',
      '+232',
      '+233',
      '+234',
      '+235',
      '+236',
      '+237',
      '+238',
      '+239',
      '+240',
      '+241',
      '+242',
      '+243',
      '+244',
      '+245',
      '+246',
      '+248',
      '+249',
      '+250',
      '+251',
      '+252',
      '+253',
      '+254',
      '+255',
      '+256',
      '+257',
      '+258',
      '+260',
      '+261',
      '+262',
      '+263',
      '+264',
      '+265',
      '+266',
      '+267',
      '+268',
      '+269',
      '+290',
      '+291',
      '+297',
      '+298',
      '+299',
      '+350',
      '+351',
      '+352',
      '+353',
      '+354',
      '+355',
      '+356',
      '+357',
      '+358',
      '+359',
      '+370',
      '+371',
      '+372',
      '+373',
      '+374',
      '+375',
      '+376',
      '+377',
      '+378',
      '+379',
      '+380',
      '+381',
      '+382',
      '+383',
      '+385',
      '+386',
      '+387',
      '+389',
      '+420',
      '+421',
      '+423',
      '+500',
      '+501',
      '+502',
      '+503',
      '+504',
      '+505',
      '+506',
      '+507',
      '+508',
      '+509',
      '+590',
      '+591',
      '+592',
      '+593',
      '+594',
      '+595',
      '+596',
      '+597',
      '+598',
      '+599',
      '+670',
      '+672',
      '+673',
      '+674',
      '+675',
      '+676',
      '+677',
      '+678',
      '+679',
      '+680',
      '+681',
      '+682',
      '+683',
      '+684',
      '+685',
      '+686',
      '+687',
      '+688',
      '+689',
      '+690',
      '+691',
      '+692',
      '+850',
      '+852',
      '+853',
      '+855',
      '+856',
      '+872',
      '+878',
      '+880',
      '+886',
      '+960',
      '+961',
      '+962',
      '+963',
      '+964',
      '+965',
      '+966',
      '+967',
      '+968',
      '+970',
      '+971',
      '+972',
      '+973',
      '+974',
      '+975',
      '+976',
      '+977',
      '+30',
      '+31',
      '+32',
      '+33',
      '+34',
      '+36',
      '+39',
      '+40',
      '+41',
      '+43',
      '+44',
      '+45',
      '+46',
      '+47',
      '+48',
      '+49',
      '+51',
      '+52',
      '+53',
      '+54',
      '+55',
      '+56',
      '+57',
      '+58',
      '+60',
      '+61',
      '+62',
      '+63',
      '+64',
      '+65',
      '+66',
      '+81',
      '+82',
      '+84',
      '+86',
      '+90',
      '+91',
      '+92',
      '+93',
      '+94',
      '+95',
      '+98',
      '+1',
      '+2',
      '+7',
    ];

    for (final code in countryCodes) {
      if (fullPhoneNumber.startsWith(code)) {
        return code;
      }
    }

    // Default fallback
    return '+963';
  }

  void _populateFieldsFromState(ProfileState state) {
    final profile = state.profile;
    if (profile != null) {
      // Only update if values have changed to avoid cursor jumping
      if (_nameController.text != profile.name) {
        _nameController.text = profile.name;
      }
      if (_emailController.text != (profile.email ?? '')) {
        _emailController.text = profile.email ?? '';
      }
      if (_addressController.text != (profile.address ?? '')) {
        _addressController.text = profile.address ?? '';
      }

      // Parse phone number to separate country code and number
      final phoneNumber = profile.phoneNumber ?? '';
      if (phoneNumber.isNotEmpty) {
        // Check if phone starts with country code
        if (phoneNumber.startsWith('+')) {
          // Parse country code using known country codes
          final parsedCountryCode = _parseCountryCode(phoneNumber);
          final newPhone = phoneNumber.substring(parsedCountryCode.length);

          if (_countryCode != parsedCountryCode ||
              _phoneController.text != newPhone) {
            setState(() {
              _countryCode = parsedCountryCode;
            });
            _phoneController.text = newPhone;
            print(
              '🔄 [PROFILE] Parsed country code: $parsedCountryCode from $phoneNumber',
            );
            print('🔄 [PROFILE] Parsed phone: $newPhone');
          }
        } else {
          if (_phoneController.text != phoneNumber) {
            _phoneController.text = phoneNumber;
          }
        }
      }
    }
  }

  Future<void> _onPickProfilePhoto() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _profilePhotoPath = pickedFile.path;
          _isProfilePhotoChanged = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          fontSize: 18.sp,
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.updateSuccess) {
            context.showSnackBar('Profile updated successfully');
            // Repopulate fields with updated data
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFieldsFromState(state);
            });
            Navigator.pop(context);
          }

          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }

          // Update fields when profile data changes
          if (state.profile != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFieldsFromState(state);
            });
          }
        },
        builder: (context, state) {
          final profile = state.profile;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Profile Photo Section
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : profile?.profilePhotoUrl != null
                          ? CachedNetworkImageProvider(
                              profile!.profilePhotoUrl!,
                            )
                          : null,
                      child:
                          (_imageFile == null &&
                              profile?.profilePhotoUrl == null)
                          ? Icon(
                              Icons.person,
                              size: 60.sp,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _onPickProfilePhoto,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                TextButton.icon(
                  onPressed: _onPickProfilePhoto,
                  icon: Icon(Icons.edit, size: 16.sp),
                  label: const Text('Change Photo'),
                ),

                SizedBox(height: 24.h),

                // Form Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Enter your full name',
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      'Your Phone',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          // Country Code Picker
                          CountryCodePicker(
                            key: ValueKey(
                              _countryCode,
                            ), // Force rebuild when country code changes
                            onChanged: (country) {
                              setState(() {
                                _countryCode = country.dialCode ?? '+963';
                              });
                              print(
                                '🌍 [PROFILE] Country code changed to: $_countryCode',
                              );
                            },
                            initialSelection: _countryCode,
                            favorite: const [
                              '+963',
                              '+213',
                              '+1',
                              '+44',
                              '+971',
                            ],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            dialogTextStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            searchStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 0,
                            ),
                            flagWidth: 20.w,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.black54,
                            boxDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),

                          // Divider
                          Container(
                            height: 30.h,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),

                          // Phone Number Input
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Phone number',
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      'Email Address',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      'Location',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _addressController,
                      hintText: 'Enter your location',
                      suffixIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Password Section
                    Text(
                      'Password',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '••••••••••',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ProfileBloc>(),
                                    child: const ChangePasswordScreen(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40.h),

                // Save Button
                CustomButton(
                  text: 'Save Changes',
                  isLoading: state.isUpdating,
                  onPressed: () {
                    // Combine country code with phone number
                    final phone = _phoneController.text.trim();
                    final fullPhoneNumber = phone.isNotEmpty
                        ? '$_countryCode$phone'
                        : '';

                    print('📱 [PROFILE UPDATE] Updating phone number');
                    print('Country Code: $_countryCode');
                    print('Phone: $phone');
                    print('Full Phone: $fullPhoneNumber');

                    final request = UpdateProfileRequest(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      phoneNumber: fullPhoneNumber,
                      latitude: state.profile?.latitude ?? '0',
                      longitude: state.profile?.longitude ?? '0',
                      address: _addressController.text.trim(),
                      isProfilePhotoChanged: _isProfilePhotoChanged,
                      profilePhotoPath: _profilePhotoPath,
                    );

                    print('📦 [PROFILE UPDATE] Request: ${request.toJson()}');

                    context.read<ProfileBloc>().add(
                      UpdateProfileEvent(request),
                    );
                  },
                  backgroundColor: AppColors.primary,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

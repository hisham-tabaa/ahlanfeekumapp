import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io show File;

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/universal_io.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_field.dart';
import '../cubit/registration_cubit.dart';
import 'secure_account_screen.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({super.key});

  @override
  State<SetProfileScreen> createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistrationCubit>();
    nameController = TextEditingController(text: cubit.state.name);
    emailController = TextEditingController(text: cubit.state.email);
    addressController = TextEditingController(text: cubit.state.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('gallery'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('camera'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (image != null) {
        if (mounted) {
          context.read<RegistrationCubit>().setProfilePhotoFile(image);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('photo_selected_successfully'.tr())),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'error_picking_image'.tr()}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 32,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),
            Row(
              children: [
                // Profile Photo Picker
                BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (context, state) {
                    final avatarSize = ResponsiveUtils.size(
                      context,
                      mobile: 56,
                      tablet: 64,
                      desktop: 72,
                    );
                    final badgeSize = ResponsiveUtils.size(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    );

                    return GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          image: state.profilePhotoPath != null && !kIsWeb
                              ? DecorationImage(
                                  image: FileImage(
                                    io.File(File(state.profilePhotoPath!).path),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : state.profilePhotoPath != null && kIsWeb
                                  ? DecorationImage(
                                      image: NetworkImage(state.profilePhotoPath!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: Stack(
                          children: [
                            if (state.profilePhotoPath == null)
                              const Center(
                                child: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: badgeSize,
                                height: badgeSize,
                                decoration: BoxDecoration(
                                  color: state.profilePhotoPath == null
                                      ? const Color(0xFFED1C24)
                                      : Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  state.profilePhotoPath == null
                                      ? Icons.add
                                      : Icons.check,
                                  color: Colors.white,
                                  size: ResponsiveUtils.size(
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
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Your Profile',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 22,
                            tablet: 24,
                            desktop: 26,
                          ),
                          fontWeight: FontWeight.w700,
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
                        'Tap to add photo',
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
              ],
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
              'Complete Your Profile Details And Continue With Us.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),

            // Name
            CustomTextField(
              controller: nameController,
              labelText: 'Your Name',
              hintText: 'FullName',
              onChanged: cubit.setName,
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
            ),

            // Conditionally show Email or Phone based on registration method
            BlocBuilder<RegistrationCubit, RegistrationState>(
              builder: (context, state) {
                final needsEmail =
                    state.registrationMethod == RegistrationMethod.phone;
                final needsPhone =
                    state.registrationMethod == RegistrationMethod.email;

                return Column(
                  children: [
                    // Always show email field
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      forceLTR: true, // Force LTR for email addresses
                      onChanged: cubit.setEmail,
                      readOnly:
                          !needsEmail, // Only editable if user registered with phone
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                    ),

                    // Show phone field if user registered with email
                    if (needsPhone) ...[
                      PhoneField(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        readOnly: false,
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),

            // Address
            CustomTextField(
              controller: addressController,
              labelText: 'Address',
              hintText: 'Your Address',
              suffixIcon: const Icon(Icons.my_location_outlined),
              onChanged: cubit.setAddress,
            ),

            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 40,
                tablet: 48,
                desktop: 56,
              ),
            ),

            CustomButton(
              text: 'Next',
              backgroundColor: const Color(0xFFED1C24),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<RegistrationCubit>.value(
                      value: context.read<RegistrationCubit>(),
                      child: const SecureAccountScreen(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';

class PhotosStep extends StatefulWidget {
  const PhotosStep({super.key});

  @override
  State<PhotosStep> createState() => _PhotosStepState();
}

class _PhotosStepState extends State<PhotosStep> {
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
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildRequirementNotice(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildPhotoGrid(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 100,
                  tablet: 120,
                  desktop: 120, // Reduced for desktop
                ),
              ), // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'photos'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    mobile: 24,
                    tablet: 26,
                    desktop: 28,
                  ),
                  fontWeight: FontWeight.w600,
                ),
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
        Text(
          'property_images'.tr(),
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 22,
            ),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementNotice(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
      ),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12),
        ),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.red,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
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
          Expanded(
            child: Text(
              'add_atleast_20_photos_message'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.red[700],
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, RentCreateState state) {
    final crossAxisCount = ResponsiveUtils.responsive<int>(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
        mainAxisSpacing: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
        childAspectRatio: 1.0,
      ),
      itemCount: _getGridItemCount(state.formData.selectedImages),
      itemBuilder: (context, index) {
        final images = state.formData.selectedImages;
        final imageFiles = state.formData.selectedImageFiles;

        if (index == 0 && images.isNotEmpty) {
          // Primary image slot
          final xFile = imageFiles.isNotEmpty ? imageFiles[0] : null;
          return _buildPrimaryImageSlot(context, images[0], xFile, state);
        } else if (index > 0 && index <= images.length) {
          // Regular image slots
          final xFile = index - 1 < imageFiles.length
              ? imageFiles[index - 1]
              : null;
          return _buildImageSlot(
            context,
            images[index - 1],
            xFile,
            index - 1,
            state,
          );
        } else {
          // Empty slots
          return _buildEmptyImageSlot(context);
        }
      },
    );
  }

  int _getGridItemCount(List<File> images) {
    // Show at least 8 slots (including primary and 7 regular slots)
    return images.length < 7 ? 8 : images.length + 1;
  }

  Widget _buildPrimaryImageSlot(
    BuildContext context,
    File image,
    XFile? xFile,
    RentCreateState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12),
        ),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(context, mobile: 6, tablet: 7, desktop: 8),
            ),
            child: kIsWeb && xFile != null
                ? Image.network(
                    xFile.path,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            right: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 4,
                  tablet: 5,
                  desktop: 6,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
              ),
              child: Text(
                'primary'.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            right: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            child: GestureDetector(
              onTap: () {
                context.read<RentCreateBloc>().add(const RemovePhotoEvent(0));
              },
              child: Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 6,
                    tablet: 7,
                    desktop: 8,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: ResponsiveUtils.fontSize(
                    context,
                    mobile: 16,
                    tablet: 17,
                    desktop: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlot(
    BuildContext context,
    File image,
    XFile? xFile,
    int index,
    RentCreateState state,
  ) {
    final actualIndex = index + 1; // Adjust for primary image

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(context, mobile: 6, tablet: 7, desktop: 8),
            ),
            child: kIsWeb && xFile != null
                ? Image.network(
                    xFile.path,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            right: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            child: Row(
              children: [
                if (actualIndex != (state.formData.primaryImageIndex ?? 0))
                  GestureDetector(
                    onTap: () {
                      context.read<RentCreateBloc>().add(
                        SetPrimaryPhotoEvent(actualIndex),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                        size: ResponsiveUtils.fontSize(
                          context,
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<RentCreateBloc>().add(
                      RemovePhotoEvent(actualIndex),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 6,
                        tablet: 7,
                        desktop: 8,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyImageSlot(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12),
          ),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.grey[400],
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 24,
                  tablet: 26,
                  desktop: 28,
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
            Text(
              'add_photo'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[500],
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
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    // Capture the parent context that has access to the RentCreateBloc
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 20,
              tablet: 21,
              desktop: 22,
            ),
          ),
        ),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(
              context,
              mobile: 24,
              tablet: 26,
              desktop: 28,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'select_image_source'.tr(),
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
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildImageSourceOption(
                      context: bottomSheetContext,
                      icon: Icons.camera_alt,
                      title: 'camera'.tr(),
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _pickImages(
                          parentContext,
                          ImageSource.camera,
                        ); // Use parent context
                      },
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                  Expanded(
                    child: _buildImageSourceOption(
                      context: bottomSheetContext,
                      icon: Icons.photo_library,
                      title: 'gallery'.tr(),
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _pickImages(
                          parentContext,
                          ImageSource.gallery,
                        ); // Use parent context
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 17,
            desktop: 18,
          ),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 32,
                tablet: 34,
                desktop: 36,
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
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages(BuildContext context, ImageSource source) async {
    try {
      // Store BLoC reference before async operation
      final bloc = context.read<RentCreateBloc>();
      final ImagePicker picker = ImagePicker();

      if (source == ImageSource.gallery) {
        // Pick multiple images from gallery
        final List<XFile> images = await picker.pickMultipleMedia();

        if (images.isNotEmpty) {
          final files = images.map((xfile) => File(xfile.path)).toList();
          // Pass both Files (for mobile preview) and XFiles (for web compatibility)
          bloc.add(AddPhotosEvent(files, photoFiles: images));
        } else {
        }
      } else {
        // Pick single image from camera
        final XFile? image = await picker.pickImage(source: source);

        if (image != null) {
          final file = File(image.path);
          // Pass both File (for mobile preview) and XFile (for web compatibility)
          bloc.add(AddPhotosEvent([file], photoFiles: [image]));
        } else {
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_picking_image'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

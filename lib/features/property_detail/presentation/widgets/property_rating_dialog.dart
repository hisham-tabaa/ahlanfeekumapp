import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../data/models/property_rating_request.dart';

class PropertyRatingDialog extends StatefulWidget {
  final String propertyId;
  final Function(PropertyRatingRequest) onSubmit;

  const PropertyRatingDialog({
    super.key,
    required this.propertyId,
    required this.onSubmit,
  });

  @override
  State<PropertyRatingDialog> createState() => _PropertyRatingDialogState();
}

class _PropertyRatingDialogState extends State<PropertyRatingDialog> {
  int cleanlinessRating = 0;
  int priceAndValueRating = 0;
  int locationRating = 0;
  int accuracyRating = 0;
  int attitudeRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  bool get isValid =>
      cleanlinessRating > 0 &&
      priceAndValueRating > 0 &&
      locationRating > 0 &&
      accuracyRating > 0 &&
      attitudeRating > 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: ResponsiveUtils.size(
            context,
            mobile: 500,
            tablet: 600,
            desktop: 700,
          ),
        ),
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate Property',
                  style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),

            // Rating Categories
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRatingRow(
                      'Cleanliness',
                      cleanlinessRating,
                      (rating) => setState(() => cleanlinessRating = rating),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 28,
                      ),
                    ),
                    _buildRatingRow(
                      'Price & Value',
                      priceAndValueRating,
                      (rating) => setState(() => priceAndValueRating = rating),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 28,
                      ),
                    ),
                    _buildRatingRow(
                      'Location',
                      locationRating,
                      (rating) => setState(() => locationRating = rating),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 28,
                      ),
                    ),
                    _buildRatingRow(
                      'Accuracy',
                      accuracyRating,
                      (rating) => setState(() => accuracyRating = rating),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 28,
                      ),
                    ),
                    _buildRatingRow(
                      'Attitude',
                      attitudeRating,
                      (rating) => setState(() => attitudeRating = rating),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 32,
                        tablet: 36,
                        desktop: 40,
                      ),
                    ),

                    // Comment Field Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share Your Experience',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
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
                        TextField(
                          controller: commentController,
                          maxLines: 4,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText:
                                'Tell us more about your stay (optional)...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary.withValues(alpha: 0.6),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 20,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.radius(
                                  context,
                                  mobile: 12,
                                  tablet: 14,
                                  desktop: 16,
                                ),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.radius(
                                  context,
                                  mobile: 12,
                                  tablet: 14,
                                  desktop: 16,
                                ),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.radius(
                                  context,
                                  mobile: 12,
                                  tablet: 14,
                                  desktop: 16,
                                ),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: ResponsiveUtils.size(
                context,
                mobile: 50,
                tablet: 55,
                desktop: 60,
              ),
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                        final request = PropertyRatingRequest(
                          cleanliness: cleanlinessRating,
                          priceAndValue: priceAndValueRating,
                          location: locationRating,
                          accuracy: accuracyRating,
                          attitude: attitudeRating,
                          ratingComment: commentController.text,
                          sitePropertyId: widget.propertyId,
                        );
                        widget.onSubmit(request);
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
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
                child: Text(
                  'Submit Rating',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(
    String label,
    int currentRating,
    Function(int) onRatingChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with rating score
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (currentRating > 0)
              Container(
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
                  color: AppColors.primary.withValues(alpha: 0.1),
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
                  '$currentRating/10',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
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
        // Star rating
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = currentRating >= starValue * 2;
            return GestureDetector(
              onTap: () => onRatingChanged(starValue * 2),
              child: Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 4,
                    tablet: 5,
                    desktop: 6,
                  ),
                ),
                child: Icon(
                  isSelected ? Icons.star : Icons.star_border,
                  color: isSelected ? AppColors.warning : Colors.grey[400],
                  size: ResponsiveUtils.fontSize(
                    context,
                    mobile: 32,
                    tablet: 36,
                    desktop: 40,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

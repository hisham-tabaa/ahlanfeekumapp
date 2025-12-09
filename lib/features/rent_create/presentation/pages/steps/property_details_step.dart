import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../search/presentation/bloc/search_bloc.dart';
import '../../../../search/presentation/bloc/search_state.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';
import '../widgets/counter_widget.dart';
import '../widgets/feature_chip_widget.dart';
import '../widgets/property_type_chip.dart';

class PropertyDetailsStep extends StatefulWidget {
  const PropertyDetailsStep({super.key});

  @override
  State<PropertyDetailsStep> createState() => _PropertyDetailsStepState();
}

class _PropertyDetailsStepState extends State<PropertyDetailsStep> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _houseRulesController = TextEditingController();
  final _importantInfoController = TextEditingController();
  final _areaController = TextEditingController();
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
    _titleController.dispose();
    _descriptionController.dispose();
    _houseRulesController.dispose();
    _importantInfoController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, rentState) {
        // Update controllers when form data changes
        if (_titleController.text != (rentState.formData.propertyTitle ?? '')) {
          _titleController.text = rentState.formData.propertyTitle ?? '';
        }
        if (_areaController.text !=
            (rentState.formData.area?.toString() ?? '')) {
          _areaController.text = rentState.formData.area?.toString() ?? '';
        }

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
              _buildSectionTitle(context, 'property_type'.tr()),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              _buildPropertyTypeSelector(),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              _buildSectionTitle(context, 'property_title'.tr()),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              _buildTextField(
                context,
                controller: _titleController,
                hintText: 'title'.tr(),
                onChanged: (value) {
                  context.read<RentCreateBloc>().add(
                    UpdatePropertyTitleEvent(value),
                  );
                },
              ),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              _buildSectionTitle(context, 'property_details'.tr()),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              _buildPropertyCounters(context, rentState),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 20, // Reduced spacing on desktop
                ),
              ),
              _buildSectionTitle(context, 'property_description'.tr()),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 12, // Reduced spacing on desktop
                ),
              ),
              _buildTextField(
                context,
                controller: _descriptionController,
                hintText: 'type_here'.tr(),
                maxLines: 4,
                onChanged: (value) {
                  context.read<RentCreateBloc>().add(
                    UpdatePropertyDescriptionEvent(value),
                  );
                },
              ),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 20, // Reduced spacing on desktop
                ),
              ),
              _buildSectionTitle(context, 'more_features'.tr()),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              _buildPropertyFeatures(context),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 24, // Reduced spacing on desktop
                ),
              ),
              _buildInstructionsSection(context),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              _buildGovernorateSelector(context),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 100,
                  tablet: 110,
                  desktop: 120,
                ),
              ), // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    bool isRequired = true,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: AppTextStyles.h4.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 14,
            tablet: 15,
            desktop: 16,
          ),
          fontWeight: FontWeight.w600,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildSubSectionTitle(
    BuildContext context,
    String title, {
    bool isRequired = true,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 14,
            tablet: 15,
            desktop: 16,
          ),
          fontWeight: FontWeight.w500,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    // Desktop: 2-column layout for House Rules and Important Info
    if (ResponsiveUtils.isDesktop(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'instructions'.tr()),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 16,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubSectionTitle(context, 'house_rules'.tr()),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 8,
                        tablet: 9,
                        desktop: 10,
                      ),
                    ),
                    _buildTextField(
                      context,
                      controller: _houseRulesController,
                      hintText: 'type_here'.tr(),
                      maxLines: 5,
                      onChanged: (value) {
                        context.read<RentCreateBloc>().add(
                          UpdateHouseRulesEvent(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubSectionTitle(
                      context,
                      'important_information'.tr(),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 8,
                        tablet: 9,
                        desktop: 10,
                      ),
                    ),
                    _buildTextField(
                      context,
                      controller: _importantInfoController,
                      hintText: 'type_here'.tr(),
                      maxLines: 5,
                      onChanged: (value) {
                        context.read<RentCreateBloc>().add(
                          UpdateImportantInfoEvent(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Mobile/Tablet: Traditional single column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'instructions'.tr()),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        _buildSubSectionTitle(context, 'house_rules'.tr()),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 9,
            desktop: 10,
          ),
        ),
        _buildTextField(
          context,
          controller: _houseRulesController,
          hintText: 'type_here'.tr(),
          maxLines: 3,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateHouseRulesEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        _buildSubSectionTitle(context, 'important_information'.tr()),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 9,
            desktop: 10,
          ),
        ),
        _buildTextField(
          context,
          controller: _importantInfoController,
          hintText: 'type_here'.tr(),
          maxLines: 3,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateImportantInfoEvent(value));
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    required Function(String) onChanged,
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 13, desktop: 14),
        ),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: isRequired ? '$hintText *' : hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[400],
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(
              context,
              mobile: 18,
              tablet: 19,
              desktop: 20,
            ),
            vertical: maxLines > 1
                ? ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 17,
                    desktop: 18,
                  )
                : ResponsiveUtils.spacing(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 16,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeSelector() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        if (searchState is LookupsLoaded) {
          return BlocBuilder<RentCreateBloc, RentCreateState>(
            builder: (context, rentState) {
              return Wrap(
                spacing: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
                runSpacing: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
                children: searchState.propertyTypes.map((type) {
                  final isSelected =
                      type.id == rentState.formData.propertyTypeId;
                  return PropertyTypeChip(
                    label: type.displayName,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<RentCreateBloc>().add(
                        UpdatePropertyTypeEvent(type.id, type.displayName),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        }
        return SizedBox(
          height: ResponsiveUtils.size(
            context,
            mobile: 48,
            tablet: 52,
            desktop: 56,
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildPropertyCounters(BuildContext context, RentCreateState state) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    if (isDesktop) {
      // Two-column grid layout for desktop
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CounterWidget(
                  title: 'bedrooms'.tr(),
                  value: state.formData.bedrooms,
                  minValue: 0,
                  maxValue: 20,
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateBedroomsEvent(value),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CounterWidget(
                  title: 'bathrooms'.tr(),
                  value: state.formData.bathrooms,
                  minValue: 0,
                  maxValue: 20,
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateBathroomsEvent(value),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CounterWidget(
                  title: 'number_of_beds'.tr(),
                  value: state.formData.numberOfBeds,
                  minValue: 0,
                  maxValue: 20,
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateNumberOfBedsEvent(value),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CounterWidget(
                  title: 'living_rooms'.tr(),
                  value: state.formData.livingRooms,
                  minValue: 0,
                  maxValue: 20,
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateLivingRoomsEvent(value),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CounterWidget(
                  title: 'floor'.tr(),
                  value: state.formData.floor,
                  minValue: 0,
                  maxValue: 50,
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(UpdateFloorEvent(value));
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CounterWidget(
                  title: 'maximum_number_of_guests'.tr(),
                  value: state.formData.maximumNumberOfGuests,
                  minValue: 0,
                  maxValue: 50,
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateMaxGuestsEvent(value),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildAreaField(context, state),
        ],
      );
    }

    // Single column layout for mobile and tablet
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CounterWidget(
          title: 'bedrooms'.tr(),
          value: state.formData.bedrooms,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateBedroomsEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        CounterWidget(
          title: 'bathrooms'.tr(),
          value: state.formData.bathrooms,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateBathroomsEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        CounterWidget(
          title: 'number_of_beds'.tr(),
          value: state.formData.numberOfBeds,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateNumberOfBedsEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        CounterWidget(
          title: 'floor'.tr(),
          value: state.formData.floor,
          minValue: 0,
          maxValue: 50,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateFloorEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        CounterWidget(
          title: 'maximum_number_of_guests'.tr(),
          value: state.formData.maximumNumberOfGuests,
          minValue: 0,
          maxValue: 50,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateMaxGuestsEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        CounterWidget(
          title: 'living_rooms'.tr(),
          value: state.formData.livingRooms,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateLivingRoomsEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 21,
            desktop: 22,
          ),
        ),
        _buildAreaField(context, state),
      ],
    );
  }

  Widget _buildAreaField(BuildContext context, RentCreateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'area'.tr()} (${'square_meters'.tr()})',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
            fontWeight: FontWeight.w500,
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: _areaController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final intValue = int.tryParse(value);
              context.read<RentCreateBloc>().add(UpdateAreaEvent(intValue));
            },
            decoration: InputDecoration(
              hintText: 'enter_area_in_square_meters'.tr(),
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[400],
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 18,
                  tablet: 19,
                  desktop: 20,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyFeatures(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        if (searchState is LookupsLoaded) {
          return BlocBuilder<RentCreateBloc, RentCreateState>(
            builder: (context, rentState) {
              return Wrap(
                spacing: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
                runSpacing: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
                children: searchState.propertyFeatures.map((feature) {
                  final isSelected = rentState.formData.propertyFeatureIds
                      .contains(feature.id);

                  return FeatureChipWidget(
                    label: feature.displayName,
                    isSelected: isSelected,
                    onTap: () {
                      final currentIds = List<String>.from(
                        rentState.formData.propertyFeatureIds,
                      );
                      final currentNames = List<String>.from(
                        rentState.formData.selectedFeatures,
                      );

                      if (isSelected) {
                        currentIds.remove(feature.id);
                        currentNames.remove(feature.displayName);
                      } else {
                        currentIds.add(feature.id);
                        currentNames.add(feature.displayName);
                      }

                      context.read<RentCreateBloc>().add(
                        UpdatePropertyFeaturesEvent(currentIds, currentNames),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildGovernorateSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'governorate'.tr()),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, searchState) {
            if (searchState is LookupsLoaded) {
              return BlocBuilder<RentCreateBloc, RentCreateState>(
                builder: (context, rentState) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 18,
                        tablet: 19,
                        desktop: 20,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 13,
                        desktop: 14,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                      ),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: rentState.formData.governorateId,
                        icon: Icon(
                          Icons.expand_more,
                          color: AppColors.primary,
                          size: ResponsiveUtils.fontSize(
                            context,
                            mobile: 18,
                            tablet: 19,
                            desktop: 20,
                          ),
                        ),
                        hint: Text(
                          'select_governorate'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[400],
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              mobile: 14,
                              tablet: 15,
                              desktop: 16,
                            ),
                          ),
                        ),
                        items: searchState.governates.map((governorate) {
                          return DropdownMenuItem(
                            value: governorate.id,
                            child: Text(
                              governorate.displayName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 15,
                                  desktop: 16,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final selectedGovernorate = searchState.governates
                                .firstWhere((gov) => gov.id == value);
                            context.read<RentCreateBloc>().add(
                              UpdateGovernorateEvent(
                                value,
                                selectedGovernorate.displayName,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}

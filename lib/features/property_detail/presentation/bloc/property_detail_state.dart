import 'package:equatable/equatable.dart';

import '../../domain/entities/property_detail.dart';
import '../../data/models/property_availability_models.dart';

class PropertyDetailState extends Equatable {
  final bool isLoading;
  final PropertyDetail? propertyDetail;
  final String? errorMessage;
  final List<PropertyAvailabilityItem> availabilityData;
  final bool isLoadingAvailability;

  const PropertyDetailState({
    this.isLoading = false,
    this.propertyDetail,
    this.errorMessage,
    this.availabilityData = const [],
    this.isLoadingAvailability = false,
  });

  PropertyDetailState copyWith({
    bool? isLoading,
    PropertyDetail? propertyDetail,
    String? errorMessage,
    List<PropertyAvailabilityItem>? availabilityData,
    bool? isLoadingAvailability,
  }) {
    return PropertyDetailState(
      isLoading: isLoading ?? this.isLoading,
      propertyDetail: propertyDetail ?? this.propertyDetail,
      errorMessage: errorMessage,
      availabilityData: availabilityData ?? this.availabilityData,
      isLoadingAvailability:
          isLoadingAvailability ?? this.isLoadingAvailability,
    );
  }

  factory PropertyDetailState.initial() {
    return const PropertyDetailState();
  }

  @override
  List<Object?> get props => [
    isLoading,
    propertyDetail,
    errorMessage,
    availabilityData,
    isLoadingAvailability,
  ];
}

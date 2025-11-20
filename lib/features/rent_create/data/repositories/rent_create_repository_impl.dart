import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/rent_create_entities.dart';
import '../../domain/repositories/rent_create_repository.dart';
import '../datasources/rent_create_remote_data_source.dart';
import '../models/create_property_request.dart';
import '../models/property_form_data.dart';

class RentCreateRepositoryImpl implements RentCreateRepository {
  final RentCreateRemoteDataSource _remoteDataSource;

  RentCreateRepositoryImpl(this._remoteDataSource);

  @override
  Future<PropertyCreationResult> createPropertyStepOne(
    PropertyFormData formData,
  ) async {
    try {
      // Validate that all required fields are present
      if (formData.propertyTitle == null || formData.propertyTitle!.isEmpty) {
        throw Exception('Property title is required');
      }
      if (formData.propertyTypeId == null || formData.propertyTypeId!.isEmpty) {
        throw Exception('Property type is required');
      }
      if (formData.governorateId == null || formData.governorateId!.isEmpty) {
        throw Exception('Governorate is required');
      }
      if (formData.propertyDescription == null ||
          formData.propertyDescription!.isEmpty) {
        throw Exception('Property description is required');
      }
      if (formData.houseRules == null || formData.houseRules!.isEmpty) {
        throw Exception('House rules are required');
      }
      if (formData.importantInformation == null ||
          formData.importantInformation!.isEmpty) {
        throw Exception('Important information is required');
      }
      if (formData.propertyFeatureIds.isEmpty) {
        throw Exception('At least one property feature is required');
      }

      // Location fields are now optional - they will be updated in step two
      // Use empty strings or default values if not provided yet
      final request = CreatePropertyStepOneRequest(
        propertyTitle: formData.propertyTitle!,
        hotelName: formData.propertyTitle, // Using property title as hotel name
        bedrooms: formData.bedrooms,
        bathrooms: formData.bathrooms,
        numberOfBed: formData.numberOfBeds,
        floor: formData.floor,
        maximumNumberOfGuest: formData.maximumNumberOfGuests,
        livingrooms: formData.livingRooms,
        area: formData.area ?? 0,
        propertyDescription: formData.propertyDescription!,
        hourseRules: formData.houseRules!,
        importantInformation: formData.importantInformation!,
        address: formData.address ?? '',
        streetAndBuildingNumber: formData.streetAndBuildingNumber ?? '',
        landMark: formData.landMark ?? '',
        pricePerNight: formData.pricePerNight ?? 0,
        propertyTypeId: formData.propertyTypeId!,
        governorateId: formData.governorateId!,
        propertyFeatureIds: formData.propertyFeatureIds,
        latitude: formData.latitude?.toString(),
        longitude: formData.longitude?.toString(),
      );

      final response = await _remoteDataSource.createPropertyStepOne(request);

      return PropertyCreationResult(
        success: true,
        propertyId: response.id,
        message: 'Property created successfully',
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: ErrorHandler.getErrorMessage(e),
      );
    }
  }

  @override
  Future<PropertyCreationResult> createPropertyStepTwo(
    PropertyFormData formData,
  ) async {
    try {
      // Validate that all required fields are present
      if (formData.propertyId == null || formData.propertyId!.isEmpty) {
        throw Exception('Property ID is required');
      }
      if (formData.address == null || formData.address!.isEmpty) {
        throw Exception('Address is required');
      }
      if (formData.streetAndBuildingNumber == null ||
          formData.streetAndBuildingNumber!.isEmpty) {
        throw Exception('Street and building number is required');
      }
      if (formData.landMark == null || formData.landMark!.isEmpty) {
        throw Exception('Landmark is required');
      }
      if (formData.latitude == null) {
        throw Exception('Latitude is required');
      }
      if (formData.longitude == null) {
        throw Exception('Longitude is required');
      }

      final request = CreatePropertyStepTwoRequest(
        id: formData.propertyId!,
        address: formData.address!,
        streetAndBuildingNumber: formData.streetAndBuildingNumber!,
        landMark: formData.landMark!,
        latitude: formData.latitude!.toString(),
        longitude: formData.longitude!.toString(),
      );

      final response = await _remoteDataSource.createPropertyStepTwo(request);

      return PropertyCreationResult(
        success: true,
        propertyId: response.id,
        message: 'Property step two completed successfully',
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: ErrorHandler.getErrorMessage(e),
      );
    }
  }

  @override
  Future<PropertyCreationResult> addAvailability(
    PropertyFormData formData,
  ) async {
    try {

      // Validate that all required fields are present
      if (formData.propertyId == null || formData.propertyId!.isEmpty) {
        throw Exception('Property ID is required');
      }
      if (formData.availableDates.isEmpty) {
        throw Exception('At least one available date is required');
      }

      final availability = formData.availableDates.map((date) {
        final dateString = date.toIso8601String().split(
          'T',
        )[0]; // YYYY-MM-DD format
        final isAvailable = formData.dateAvailability[date] ?? true;

        return PropertyAvailability(
          propertyId: formData.propertyId!,
          date: dateString,
          isAvailable: isAvailable,
          price:
              formData.pricePerNight ??
              1, // Use 1 as default if price not set yet (0 might cause validation errors)
          note: '',
        );
      }).toList();


      final response = await _remoteDataSource.addAvailability(availability);


      return PropertyCreationResult(
        success: response.data ?? false,
        message: response.message,
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: ErrorHandler.getErrorMessage(e),
      );
    }
  }

  @override
  Future<PropertyCreationResult> uploadImages(PropertyFormData formData) async {
    try {

      // Validate that all required fields are present
      if (formData.propertyId == null || formData.propertyId!.isEmpty) {
        throw Exception('Property ID is required');
      }
      if (formData.selectedImages.isEmpty) {
        throw Exception('At least one image is required');
      }
      if (formData.primaryImageIndex == null) {
        throw Exception('Primary image selection is required');
      }


      // Create PropertyMediaUpload objects for all images
      final List<PropertyMediaUpload> mediaUploads = [];

      for (int i = 0; i < formData.selectedImages.length; i++) {
        final image = formData.selectedImages[i];
        final imageFile = i < formData.selectedImageFiles.length
            ? formData.selectedImageFiles[i]
            : null;
        mediaUploads.add(
          PropertyMediaUpload(
            propertyId: formData.propertyId!,
            image: image.path,
            imageFile: imageFile, // Include XFile for web compatibility
            order: i + 1, // Order starts from 1
            isActive: true,
          ),
        );
      }

      // Upload all media at once using the new multi-media endpoint
      final response = await _remoteDataSource.uploadMultipleMedia(
        mediaUploads,
      );

      // For upload endpoints, success is determined by code 200, not by data being non-null
      final isSuccess = response.code == 200;

      return PropertyCreationResult(
        success: isSuccess,
        message: response.message,
        data: response.data,
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: ErrorHandler.getErrorMessage(e),
      );
    }
  }

  @override
  Future<PropertyCreationResult> setPrice(PropertyFormData formData) async {
    try {

      // Validate that all required fields are present
      if (formData.propertyId == null || formData.propertyId!.isEmpty) {
        throw Exception('Property ID is required');
      }
      if (formData.pricePerNight == null || formData.pricePerNight! <= 0) {
        throw Exception(
          'Price per night is required and must be greater than 0',
        );
      }

      final request = SetPriceRequest(
        propertyId: formData.propertyId!,
        pricePerNight: formData.pricePerNight!,
      );

      final response = await _remoteDataSource.setPrice(request);


      return PropertyCreationResult(
        success: response.data ?? false,
        message: response.message,
      );
    } catch (e) {
      return PropertyCreationResult(
        success: false,
        message: ErrorHandler.getErrorMessage(e),
      );
    }
  }
}

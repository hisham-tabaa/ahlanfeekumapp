import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/universal_io.dart';

const _unset = Object();

class PropertyFormData {
  // Step 1: Property Details
  String? propertyTitle;
  String? propertyTypeId;
  String? propertyTypeName;
  int bedrooms;
  int bathrooms;
  int numberOfBeds;
  int floor;
  int maximumNumberOfGuests;
  int livingRooms;
  int? area;
  String? propertyDescription;
  String? houseRules;
  String? importantInformation;
  List<String> propertyFeatureIds;
  List<String> selectedFeatures;

  // Step 2: Photos
  List<File> selectedImages;
  List<XFile> selectedImageFiles; // Added for web compatibility
  int? primaryImageIndex;

  // Step 3: Price
  int? pricePerNight;

  // Step 4: Location
  String? address;
  String? streetAndBuildingNumber;
  String? landMark;
  String? governorateId;
  String? governorateName;
  double? latitude;
  double? longitude;

  // Step 5: Availability
  List<DateTime> availableDates;
  Map<DateTime, bool> dateAvailability;

  // Property ID (after step 1 creation)
  String? propertyId;

  PropertyFormData({
    this.propertyTitle,
    this.propertyTypeId,
    this.propertyTypeName,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.numberOfBeds = 1,
    this.floor = 1,
    this.maximumNumberOfGuests = 1,
    this.livingRooms = 1,
    this.area,
    this.propertyDescription,
    this.houseRules,
    this.importantInformation,
    this.propertyFeatureIds = const [],
    this.selectedFeatures = const [],
    this.selectedImages = const [],
    this.selectedImageFiles = const [],
    this.primaryImageIndex,
    this.pricePerNight,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.governorateId,
    this.governorateName,
    this.latitude,
    this.longitude,
    this.availableDates = const [],
    this.dateAvailability = const {},
    this.propertyId,
  });

  PropertyFormData copyWith({
    Object? propertyTitle = _unset,
    Object? propertyTypeId = _unset,
    Object? propertyTypeName = _unset,
    Object? bedrooms = _unset,
    Object? bathrooms = _unset,
    Object? numberOfBeds = _unset,
    Object? floor = _unset,
    Object? maximumNumberOfGuests = _unset,
    Object? livingRooms = _unset,
    Object? area = _unset,
    Object? propertyDescription = _unset,
    Object? houseRules = _unset,
    Object? importantInformation = _unset,
    Object? propertyFeatureIds = _unset,
    Object? selectedFeatures = _unset,
    Object? selectedImages = _unset,
    Object? selectedImageFiles = _unset,
    Object? primaryImageIndex = _unset,
    Object? pricePerNight = _unset,
    Object? address = _unset,
    Object? streetAndBuildingNumber = _unset,
    Object? landMark = _unset,
    Object? governorateId = _unset,
    Object? governorateName = _unset,
    Object? latitude = _unset,
    Object? longitude = _unset,
    Object? availableDates = _unset,
    Object? dateAvailability = _unset,
    Object? propertyId = _unset,
  }) {
    return PropertyFormData(
      propertyTitle: propertyTitle == _unset
          ? this.propertyTitle
          : propertyTitle as String?,
      propertyTypeId: propertyTypeId == _unset
          ? this.propertyTypeId
          : propertyTypeId as String?,
      propertyTypeName: propertyTypeName == _unset
          ? this.propertyTypeName
          : propertyTypeName as String?,
      bedrooms: bedrooms == _unset ? this.bedrooms : bedrooms as int,
      bathrooms: bathrooms == _unset ? this.bathrooms : bathrooms as int,
      numberOfBeds: numberOfBeds == _unset
          ? this.numberOfBeds
          : numberOfBeds as int,
      floor: floor == _unset ? this.floor : floor as int,
      maximumNumberOfGuests: maximumNumberOfGuests == _unset
          ? this.maximumNumberOfGuests
          : maximumNumberOfGuests as int,
      livingRooms: livingRooms == _unset
          ? this.livingRooms
          : livingRooms as int,
      area: area == _unset ? this.area : area as int?,
      propertyDescription: propertyDescription == _unset
          ? this.propertyDescription
          : propertyDescription as String?,
      houseRules: houseRules == _unset
          ? this.houseRules
          : houseRules as String?,
      importantInformation: importantInformation == _unset
          ? this.importantInformation
          : importantInformation as String?,
      propertyFeatureIds: propertyFeatureIds == _unset
          ? this.propertyFeatureIds
          : propertyFeatureIds as List<String>,
      selectedFeatures: selectedFeatures == _unset
          ? this.selectedFeatures
          : selectedFeatures as List<String>,
      selectedImages: selectedImages == _unset
          ? this.selectedImages
          : selectedImages as List<File>,
      selectedImageFiles: selectedImageFiles == _unset
          ? this.selectedImageFiles
          : selectedImageFiles as List<XFile>,
      primaryImageIndex: primaryImageIndex == _unset
          ? this.primaryImageIndex
          : primaryImageIndex as int?,
      pricePerNight: pricePerNight == _unset
          ? this.pricePerNight
          : pricePerNight as int?,
      address: address == _unset ? this.address : address as String?,
      streetAndBuildingNumber: streetAndBuildingNumber == _unset
          ? this.streetAndBuildingNumber
          : streetAndBuildingNumber as String?,
      landMark: landMark == _unset ? this.landMark : landMark as String?,
      governorateId: governorateId == _unset
          ? this.governorateId
          : governorateId as String?,
      governorateName: governorateName == _unset
          ? this.governorateName
          : governorateName as String?,
      latitude: latitude == _unset ? this.latitude : latitude as double?,
      longitude: longitude == _unset ? this.longitude : longitude as double?,
      availableDates: availableDates == _unset
          ? this.availableDates
          : availableDates as List<DateTime>,
      dateAvailability: dateAvailability == _unset
          ? this.dateAvailability
          : dateAvailability as Map<DateTime, bool>,
      propertyId: propertyId == _unset
          ? this.propertyId
          : propertyId as String?,
    );
  }

  bool get isStep1Valid {
    return propertyTitle != null &&
        propertyTitle!.isNotEmpty &&
        propertyTypeId != null &&
        propertyTypeId!.isNotEmpty &&
        area != null &&
        area! > 0 &&
        propertyDescription != null &&
        propertyDescription!.isNotEmpty &&
        houseRules != null &&
        houseRules!.isNotEmpty &&
        importantInformation != null &&
        importantInformation!.isNotEmpty &&
        propertyFeatureIds.isNotEmpty;
  }

  bool get isLocationStepValid {
    return address != null &&
        address!.isNotEmpty &&
        streetAndBuildingNumber != null &&
        streetAndBuildingNumber!.isNotEmpty &&
        landMark != null &&
        landMark!.isNotEmpty &&
        latitude != null &&
        longitude != null;
  }

  bool get isBothDetailsAndLocationValid {
    return isStep1Valid && isLocationStepValid;
  }

  bool get isStep2Valid {
    return selectedImages.isNotEmpty && primaryImageIndex != null;
  }

  bool get isStep3Valid {
    return pricePerNight != null && pricePerNight! > 0;
  }

  bool get isStep4Valid {
    return address != null &&
        address!.isNotEmpty &&
        streetAndBuildingNumber != null &&
        streetAndBuildingNumber!.isNotEmpty &&
        landMark != null &&
        landMark!.isNotEmpty &&
        latitude != null &&
        longitude != null;
  }

  bool get isStep5Valid {
    return availableDates.isNotEmpty;
  }
}

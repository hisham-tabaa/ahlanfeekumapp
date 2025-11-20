import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class RentCreateEvent extends Equatable {
  const RentCreateEvent();

  @override
  List<Object?> get props => [];
}

// Step Navigation Events
class NavigateToStepEvent extends RentCreateEvent {
  final int stepIndex;

  const NavigateToStepEvent(this.stepIndex);

  @override
  List<Object?> get props => [stepIndex];
}

class NextStepEvent extends RentCreateEvent {
  const NextStepEvent();
}

class PreviousStepEvent extends RentCreateEvent {
  const PreviousStepEvent();
}

// Form Data Events
class UpdatePropertyTitleEvent extends RentCreateEvent {
  final String title;

  const UpdatePropertyTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdatePropertyTypeEvent extends RentCreateEvent {
  final String typeId;
  final String typeName;

  const UpdatePropertyTypeEvent(this.typeId, this.typeName);

  @override
  List<Object?> get props => [typeId, typeName];
}

class UpdateBedroomsEvent extends RentCreateEvent {
  final int bedrooms;

  const UpdateBedroomsEvent(this.bedrooms);

  @override
  List<Object?> get props => [bedrooms];
}

class UpdateBathroomsEvent extends RentCreateEvent {
  final int bathrooms;

  const UpdateBathroomsEvent(this.bathrooms);

  @override
  List<Object?> get props => [bathrooms];
}

class UpdateNumberOfBedsEvent extends RentCreateEvent {
  final int numberOfBeds;

  const UpdateNumberOfBedsEvent(this.numberOfBeds);

  @override
  List<Object?> get props => [numberOfBeds];
}

class UpdateFloorEvent extends RentCreateEvent {
  final int floor;

  const UpdateFloorEvent(this.floor);

  @override
  List<Object?> get props => [floor];
}

class UpdateMaxGuestsEvent extends RentCreateEvent {
  final int maxGuests;

  const UpdateMaxGuestsEvent(this.maxGuests);

  @override
  List<Object?> get props => [maxGuests];
}

class UpdateLivingRoomsEvent extends RentCreateEvent {
  final int livingRooms;

  const UpdateLivingRoomsEvent(this.livingRooms);

  @override
  List<Object?> get props => [livingRooms];
}

class UpdateAreaEvent extends RentCreateEvent {
  final int? area;

  const UpdateAreaEvent(this.area);

  @override
  List<Object?> get props => [area];
}

class UpdatePropertyDescriptionEvent extends RentCreateEvent {
  final String description;

  const UpdatePropertyDescriptionEvent(this.description);

  @override
  List<Object?> get props => [description];
}

class UpdateHouseRulesEvent extends RentCreateEvent {
  final String houseRules;

  const UpdateHouseRulesEvent(this.houseRules);

  @override
  List<Object?> get props => [houseRules];
}

class UpdateImportantInfoEvent extends RentCreateEvent {
  final String importantInfo;

  const UpdateImportantInfoEvent(this.importantInfo);

  @override
  List<Object?> get props => [importantInfo];
}

class UpdatePropertyFeaturesEvent extends RentCreateEvent {
  final List<String> featureIds;
  final List<String> featureNames;

  const UpdatePropertyFeaturesEvent(this.featureIds, this.featureNames);

  @override
  List<Object?> get props => [featureIds, featureNames];
}

class UpdateGovernorateEvent extends RentCreateEvent {
  final String governorateId;
  final String governorateName;

  const UpdateGovernorateEvent(this.governorateId, this.governorateName);

  @override
  List<Object?> get props => [governorateId, governorateName];
}

// Photos Events
class AddPhotosEvent extends RentCreateEvent {
  final List<File> photos;
  final List<XFile> photoFiles; // Added for web compatibility

  const AddPhotosEvent(this.photos, {this.photoFiles = const []});

  @override
  List<Object?> get props => [photos, photoFiles];
}

class RemovePhotoEvent extends RentCreateEvent {
  final int index;

  const RemovePhotoEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SetPrimaryPhotoEvent extends RentCreateEvent {
  final int index;

  const SetPrimaryPhotoEvent(this.index);

  @override
  List<Object?> get props => [index];
}

// Price Events
class UpdatePriceEvent extends RentCreateEvent {
  final int? price;

  const UpdatePriceEvent(this.price);

  @override
  List<Object?> get props => [price];
}

// Location Events
class UpdateAddressEvent extends RentCreateEvent {
  final String address;

  const UpdateAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateStreetEvent extends RentCreateEvent {
  final String street;

  const UpdateStreetEvent(this.street);

  @override
  List<Object?> get props => [street];
}

class UpdateLandMarkEvent extends RentCreateEvent {
  final String landMark;

  const UpdateLandMarkEvent(this.landMark);

  @override
  List<Object?> get props => [landMark];
}

class UpdateLocationEvent extends RentCreateEvent {
  final double latitude;
  final double longitude;

  const UpdateLocationEvent(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

class ClearLocationEvent extends RentCreateEvent {
  const ClearLocationEvent();
}

// Availability Events
class UpdateAvailabilityEvent extends RentCreateEvent {
  final DateTime date;
  final bool isAvailable;

  const UpdateAvailabilityEvent(this.date, this.isAvailable);

  @override
  List<Object?> get props => [date, isAvailable];
}

class AddAvailableDateEvent extends RentCreateEvent {
  final DateTime date;

  const AddAvailableDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class RemoveAvailableDateEvent extends RentCreateEvent {
  final DateTime date;

  const RemoveAvailableDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

// API Events
class CreatePropertyStepOneEvent extends RentCreateEvent {
  const CreatePropertyStepOneEvent();
}

class CreatePropertyStepTwoEvent extends RentCreateEvent {
  const CreatePropertyStepTwoEvent();
}

class UploadImagesEvent extends RentCreateEvent {
  const UploadImagesEvent();
}

class SetPriceEvent extends RentCreateEvent {
  const SetPriceEvent();
}

class AddAvailabilityEvent extends RentCreateEvent {
  const AddAvailabilityEvent();
}

class SubmitPropertyEvent extends RentCreateEvent {
  const SubmitPropertyEvent();
}

class ResetFormEvent extends RentCreateEvent {
  const ResetFormEvent();
}

class ClearMessagesEvent extends RentCreateEvent {
  const ClearMessagesEvent();
}

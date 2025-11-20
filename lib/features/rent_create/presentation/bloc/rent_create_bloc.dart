import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/rent_create_entities.dart';
import '../../domain/usecases/create_property_usecase.dart';
import 'rent_create_event.dart';
import 'rent_create_state.dart';

class RentCreateBloc extends Bloc<RentCreateEvent, RentCreateState> {
  final CreatePropertyStepOneUseCase _createPropertyStepOneUseCase;
  final CreatePropertyStepTwoUseCase _createPropertyStepTwoUseCase;
  final UploadImagesUseCase _uploadImagesUseCase;
  final SetPriceUseCase _setPriceUseCase;
  final AddAvailabilityUseCase _addAvailabilityUseCase;

  RentCreateBloc({
    required CreatePropertyStepOneUseCase createPropertyStepOneUseCase,
    required CreatePropertyStepTwoUseCase createPropertyStepTwoUseCase,
    required UploadImagesUseCase uploadImagesUseCase,
    required SetPriceUseCase setPriceUseCase,
    required AddAvailabilityUseCase addAvailabilityUseCase,
  }) : _createPropertyStepOneUseCase = createPropertyStepOneUseCase,
       _createPropertyStepTwoUseCase = createPropertyStepTwoUseCase,
       _uploadImagesUseCase = uploadImagesUseCase,
       _setPriceUseCase = setPriceUseCase,
       _addAvailabilityUseCase = addAvailabilityUseCase,
       super(RentCreateState.initial()) {
    on<NavigateToStepEvent>(_onNavigateToStep);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);

    // Form Data Events
    on<UpdatePropertyTitleEvent>(_onUpdatePropertyTitle);
    on<UpdatePropertyTypeEvent>(_onUpdatePropertyType);
    on<UpdateBedroomsEvent>(_onUpdateBedrooms);
    on<UpdateBathroomsEvent>(_onUpdateBathrooms);
    on<UpdateNumberOfBedsEvent>(_onUpdateNumberOfBeds);
    on<UpdateFloorEvent>(_onUpdateFloor);
    on<UpdateMaxGuestsEvent>(_onUpdateMaxGuests);
    on<UpdateLivingRoomsEvent>(_onUpdateLivingRooms);
    on<UpdateAreaEvent>(_onUpdateArea);
    on<UpdatePropertyDescriptionEvent>(_onUpdatePropertyDescription);
    on<UpdateHouseRulesEvent>(_onUpdateHouseRules);
    on<UpdateImportantInfoEvent>(_onUpdateImportantInfo);
    on<UpdatePropertyFeaturesEvent>(_onUpdatePropertyFeatures);
    on<UpdateGovernorateEvent>(_onUpdateGovernorate);

    // Photos Events
    on<AddPhotosEvent>(_onAddPhotos);
    on<RemovePhotoEvent>(_onRemovePhoto);
    on<SetPrimaryPhotoEvent>(_onSetPrimaryPhoto);

    // Price Events
    on<UpdatePriceEvent>(_onUpdatePrice);

    // Location Events
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<UpdateStreetEvent>(_onUpdateStreet);
    on<UpdateLandMarkEvent>(_onUpdateLandMark);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<ClearLocationEvent>(_onClearLocation);

    // Availability Events
    on<UpdateAvailabilityEvent>(_onUpdateAvailability);
    on<AddAvailableDateEvent>(_onAddAvailableDate);
    on<RemoveAvailableDateEvent>(_onRemoveAvailableDate);

    // API Events
    on<CreatePropertyStepOneEvent>(_onCreatePropertyStepOne);
    on<CreatePropertyStepTwoEvent>(_onCreatePropertyStepTwo);
    on<UploadImagesEvent>(_onUploadImages);
    on<SetPriceEvent>(_onSetPrice);
    on<AddAvailabilityEvent>(_onAddAvailability);
    on<SubmitPropertyEvent>(_onSubmitProperty);
    on<ResetFormEvent>(_onResetForm);
    on<ClearMessagesEvent>(_onClearMessages);
  }

  void _onNavigateToStep(
    NavigateToStepEvent event,
    Emitter<RentCreateState> emit,
  ) {
    if (event.stepIndex >= 0 &&
        event.stepIndex < PropertyCreationStep.values.length) {
      emit(state.activateStep(event.stepIndex));
    }
  }

  void _onNextStep(NextStepEvent event, Emitter<RentCreateState> emit) {
    if (state.canGoNext && !state.isLastStep) {
      final nextIndex = state.currentStepIndex + 1;
      emit(state.activateStep(nextIndex));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<RentCreateState> emit) {
    if (state.canGoPrevious) {
      final previousIndex = state.currentStepIndex - 1;
      emit(state.activateStep(previousIndex));
    }
  }

  // Form Data Event Handlers
  void _onUpdatePropertyTitle(
    UpdatePropertyTitleEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(propertyTitle: event.title);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdatePropertyType(
    UpdatePropertyTypeEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      propertyTypeId: event.typeId,
      propertyTypeName: event.typeName,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateBedrooms(
    UpdateBedroomsEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(bedrooms: event.bedrooms);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateBathrooms(
    UpdateBathroomsEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(bathrooms: event.bathrooms);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateNumberOfBeds(
    UpdateNumberOfBedsEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      numberOfBeds: event.numberOfBeds,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateFloor(UpdateFloorEvent event, Emitter<RentCreateState> emit) {
    final updatedFormData = state.formData.copyWith(floor: event.floor);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateMaxGuests(
    UpdateMaxGuestsEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      maximumNumberOfGuests: event.maxGuests,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateLivingRooms(
    UpdateLivingRoomsEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      livingRooms: event.livingRooms,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateArea(UpdateAreaEvent event, Emitter<RentCreateState> emit) {
    final updatedFormData = state.formData.copyWith(area: event.area);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdatePropertyDescription(
    UpdatePropertyDescriptionEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      propertyDescription: event.description,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateHouseRules(
    UpdateHouseRulesEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      houseRules: event.houseRules,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateImportantInfo(
    UpdateImportantInfoEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      importantInformation: event.importantInfo,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdatePropertyFeatures(
    UpdatePropertyFeaturesEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      propertyFeatureIds: event.featureIds,
      selectedFeatures: event.featureNames,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateGovernorate(
    UpdateGovernorateEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      governorateId: event.governorateId,
      governorateName: event.governorateName,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  // Photos Event Handlers
  void _onAddPhotos(AddPhotosEvent event, Emitter<RentCreateState> emit) {
    final updatedImages = List<File>.from(state.formData.selectedImages)
      ..addAll(event.photos);

    // Also update XFiles for web compatibility
    final updatedImageFiles = List<XFile>.from(
      state.formData.selectedImageFiles,
    )..addAll(event.photoFiles);

    // Set the first image as primary if no primary image is set yet
    final primaryIndex =
        state.formData.primaryImageIndex ??
        (updatedImages.isNotEmpty ? 0 : null);

    final updatedFormData = state.formData.copyWith(
      selectedImages: updatedImages,
      selectedImageFiles: updatedImageFiles,
      primaryImageIndex: primaryIndex,
    );

    // Emit the updated state with photos
    emit(
      state.copyWith(
        formData: updatedFormData,
        status: RentCreateStatus
            .photosAdded, // New status to indicate photos were added
      ),
    );

    // Automatically start upload process after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!isClosed && state.currentStep == PropertyCreationStep.photos) {
        add(const UploadImagesEvent());
      }
    });
  }

  void _onRemovePhoto(RemovePhotoEvent event, Emitter<RentCreateState> emit) {
    final updatedImages = List<File>.from(state.formData.selectedImages);
    final updatedImageFiles = List<XFile>.from(
      state.formData.selectedImageFiles,
    );

    if (event.index >= 0 && event.index < updatedImages.length) {
      updatedImages.removeAt(event.index);

      // Also remove from XFiles list
      if (event.index < updatedImageFiles.length) {
        updatedImageFiles.removeAt(event.index);
      }

      // Handle primary image index after removal
      int? newPrimaryIndex = state.formData.primaryImageIndex;

      if (updatedImages.isEmpty) {
        // No images left, clear primary index
        newPrimaryIndex = null;
      } else if (newPrimaryIndex == event.index) {
        // Primary image was removed, set first image as primary
        newPrimaryIndex = 0;
      } else if (newPrimaryIndex != null && newPrimaryIndex > event.index) {
        // Adjust primary index if it was after the removed image
        newPrimaryIndex = newPrimaryIndex - 1;
      }

      final updatedFormData = state.formData.copyWith(
        selectedImages: updatedImages,
        selectedImageFiles: updatedImageFiles,
        primaryImageIndex: newPrimaryIndex,
      );
      emit(state.copyWith(formData: updatedFormData));
    }
  }

  void _onSetPrimaryPhoto(
    SetPrimaryPhotoEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      primaryImageIndex: event.index,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  // Price Event Handlers
  void _onUpdatePrice(UpdatePriceEvent event, Emitter<RentCreateState> emit) {
    final updatedFormData = state.formData.copyWith(pricePerNight: event.price);
    // Reset status to prevent auto-navigation when editing
    emit(
      state.copyWith(
        formData: updatedFormData,
        status: RentCreateStatus.initial,
      ),
    );
  }

  // Location Event Handlers
  void _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(address: event.address);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateStreet(UpdateStreetEvent event, Emitter<RentCreateState> emit) {
    final updatedFormData = state.formData.copyWith(
      streetAndBuildingNumber: event.street,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateLandMark(
    UpdateLandMarkEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(landMark: event.landMark);
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedFormData = state.formData.copyWith(
      latitude: event.latitude,
      longitude: event.longitude,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onClearLocation(
    ClearLocationEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final clearedFormData = state.formData.copyWith(
      address: null,
      streetAndBuildingNumber: null,
      landMark: null,
      latitude: null,
      longitude: null,
    );
    emit(state.copyWith(formData: clearedFormData));
  }

  // Availability Event Handlers
  void _onUpdateAvailability(
    UpdateAvailabilityEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedAvailability = Map<DateTime, bool>.from(
      state.formData.dateAvailability,
    );
    updatedAvailability[event.date] = event.isAvailable;
    final updatedFormData = state.formData.copyWith(
      dateAvailability: updatedAvailability,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  void _onAddAvailableDate(
    AddAvailableDateEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedDates = List<DateTime>.from(state.formData.availableDates);
    if (!updatedDates.contains(event.date)) {
      updatedDates.add(event.date);
      final updatedAvailability = Map<DateTime, bool>.from(
        state.formData.dateAvailability,
      );
      updatedAvailability[event.date] = true;
      final updatedFormData = state.formData.copyWith(
        availableDates: updatedDates,
        dateAvailability: updatedAvailability,
      );
      emit(state.copyWith(formData: updatedFormData));
    }
  }

  void _onRemoveAvailableDate(
    RemoveAvailableDateEvent event,
    Emitter<RentCreateState> emit,
  ) {
    final updatedDates = List<DateTime>.from(state.formData.availableDates);
    updatedDates.remove(event.date);
    final updatedAvailability = Map<DateTime, bool>.from(
      state.formData.dateAvailability,
    );
    updatedAvailability.remove(event.date);
    final updatedFormData = state.formData.copyWith(
      availableDates: updatedDates,
      dateAvailability: updatedAvailability,
    );
    emit(state.copyWith(formData: updatedFormData));
  }

  // API Event Handlers
  Future<void> _onCreatePropertyStepOne(
    CreatePropertyStepOneEvent event,
    Emitter<RentCreateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, status: RentCreateStatus.loading));

    try {
      final result = await _createPropertyStepOneUseCase(state.formData);

      if (result.success) {
        final updatedFormData = state.formData.copyWith(
          propertyId: result.propertyId,
        );
        emit(
          state
              .copyWith(
                isLoading: false,
                status: RentCreateStatus.stepOneCompleted,
                formData: updatedFormData,
                successMessage: result.message,
              )
              .updateStepStatus(0, isCompleted: true)
              .updateStepStatus(1, isCompleted: true),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            status: RentCreateStatus.error,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.error,
          errorMessage: 'Failed to create property: $e',
        ),
      );
    }
  }

  Future<void> _onCreatePropertyStepTwo(
    CreatePropertyStepTwoEvent event,
    Emitter<RentCreateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, status: RentCreateStatus.loading));

    try {
      final result = await _createPropertyStepTwoUseCase(state.formData);

      if (result.success) {
        emit(
          state
              .copyWith(
                isLoading: false,
                status: RentCreateStatus.stepTwoCompleted,
                successMessage: result.message,
              )
              .updateStepStatus(
                1,
                isCompleted: true,
              ), // Location step (index 1)
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            status: RentCreateStatus.error,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.error,
          errorMessage: 'Failed to update location: $e',
        ),
      );
    }
  }

  Future<void> _onUploadImages(
    UploadImagesEvent event,
    Emitter<RentCreateState> emit,
  ) async {

    emit(state.copyWith(isLoading: true, status: RentCreateStatus.loading));

    try {
      final result = await _uploadImagesUseCase(state.formData);

      if (result.success) {
        emit(
          state
              .copyWith(
                isLoading: false,
                status: RentCreateStatus.imagesUploaded,
                successMessage: result.message,
                errorMessage: null, // Clear any previous error
              )
              .updateStepStatus(3, isCompleted: true),
        ); // Photos step (index 3 in PropertyCreationStep enum)

        // Navigation is handled by the BlocListener in the UI
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            status: RentCreateStatus.error,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.error,
          errorMessage: 'Failed to upload images: $e',
        ),
      );
    }
  }

  Future<void> _onSetPrice(
    SetPriceEvent event,
    Emitter<RentCreateState> emit,
  ) async {

    emit(state.copyWith(isLoading: true, status: RentCreateStatus.loading));

    try {
      final result = await _setPriceUseCase(state.formData);


      if (result.success) {
        emit(
          state
              .copyWith(
                isLoading: false,
                status: RentCreateStatus.priceSet,
                successMessage: result.message,
                errorMessage: null, // Clear any previous error
              )
              .updateStepStatus(4, isCompleted: true),
        ); // Price step (index 4 in PropertyCreationStep enum)
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            status: RentCreateStatus.error,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.error,
          errorMessage: 'Failed to set price: $e',
        ),
      );
    }
  }

  Future<void> _onAddAvailability(
    AddAvailabilityEvent event,
    Emitter<RentCreateState> emit,
  ) async {

    emit(state.copyWith(isLoading: true, status: RentCreateStatus.loading));

    try {
      final result = await _addAvailabilityUseCase(state.formData);


      if (result.success) {
        emit(
          state
              .copyWith(
                isLoading: false,
                status: RentCreateStatus.availabilityAdded,
                successMessage: result.message,
                errorMessage: null, // Clear any previous error
              )
              .updateStepStatus(2, isCompleted: true),
        ); // Availability step (index 2 in PropertyCreationStep enum)
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            status: RentCreateStatus.error,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.error,
          errorMessage: 'Failed to add availability: $e',
        ),
      );
    }
  }

  Future<void> _onSubmitProperty(
    SubmitPropertyEvent event,
    Emitter<RentCreateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, status: RentCreateStatus.loading));

    try {
      // Execute all steps in sequence
      await _executePropertyCreationFlow(emit);

      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.propertySubmitted,
          successMessage: 'Property created successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: RentCreateStatus.error,
          errorMessage: 'Failed to submit property: $e',
        ),
      );
    }
  }

  Future<void> _executePropertyCreationFlow(
    Emitter<RentCreateState> emit,
  ) async {
    // Step 1: Create Property Basic Info
    if (state.formData.propertyId == null) {
      final stepOneResult = await _createPropertyStepOneUseCase(state.formData);
      if (!stepOneResult.success) throw Exception(stepOneResult.message);

      final updatedFormData = state.formData.copyWith(
        propertyId: stepOneResult.propertyId,
      );
      emit(state.copyWith(formData: updatedFormData));
    }

    // Step 2: Upload Images
    if (state.formData.selectedImages.isNotEmpty) {
      final uploadResult = await _uploadImagesUseCase(state.formData);
      if (!uploadResult.success) throw Exception(uploadResult.message);
    }

    // Step 3: Set Price
    if (state.formData.pricePerNight != null) {
      final priceResult = await _setPriceUseCase(state.formData);
      if (!priceResult.success) throw Exception(priceResult.message);
    }

    // Step 4: Update Location
    final stepTwoResult = await _createPropertyStepTwoUseCase(state.formData);
    if (!stepTwoResult.success) throw Exception(stepTwoResult.message);

    // Step 5: Add Availability
    if (state.formData.availableDates.isNotEmpty) {
      final availabilityResult = await _addAvailabilityUseCase(state.formData);
      if (!availabilityResult.success) {
        throw Exception(availabilityResult.message);
      }
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<RentCreateState> emit) {
    emit(RentCreateState.initial());
  }

  void _onClearMessages(
    ClearMessagesEvent event,
    Emitter<RentCreateState> emit,
  ) {
    emit(state.clearMessages());
  }
}

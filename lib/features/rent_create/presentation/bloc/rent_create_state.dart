import 'package:equatable/equatable.dart';
import '../../data/models/property_form_data.dart';
import '../../domain/entities/rent_create_entities.dart';

enum RentCreateStatus {
  initial,
  loading,
  success,
  error,
  stepOneCompleted,
  stepTwoCompleted,
  photosAdded,
  imagesUploaded,
  priceSet,
  availabilityAdded,
  propertySubmitted,
}

class RentCreateState extends Equatable {
  final RentCreateStatus status;
  final PropertyFormData formData;
  final int currentStepIndex;
  final List<PropertyCreationStepStatus> steps;
  final String? errorMessage;
  final String? successMessage;
  final bool isLoading;

  const RentCreateState({
    this.status = RentCreateStatus.initial,
    required this.formData,
    this.currentStepIndex = 0,
    required this.steps,
    this.errorMessage,
    this.successMessage,
    this.isLoading = false,
  });

  factory RentCreateState.initial() {
    return RentCreateState(
      formData: PropertyFormData(),
      steps: PropertyCreationStep.values
          .map(
            (step) => PropertyCreationStepStatus(
              step: step,
              isCompleted: false,
              isActive: step == PropertyCreationStep.propertyDetails,
            ),
          )
          .toList(),
    );
  }

  RentCreateState copyWith({
    RentCreateStatus? status,
    PropertyFormData? formData,
    int? currentStepIndex,
    List<PropertyCreationStepStatus>? steps,
    String? errorMessage,
    String? successMessage,
    bool? isLoading,
  }) {
    return RentCreateState(
      status: status ?? this.status,
      formData: formData ?? this.formData,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      steps: steps ?? this.steps,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  RentCreateState clearMessages() {
    return copyWith(errorMessage: null, successMessage: null);
  }

  PropertyCreationStep get currentStep {
    return PropertyCreationStep.values[currentStepIndex];
  }

  bool get canGoNext {
    switch (currentStep) {
      case PropertyCreationStep.propertyDetails:
        return formData.isStep1Valid;
      case PropertyCreationStep.location:
        return formData.isLocationStepValid;
      case PropertyCreationStep.availability:
        return formData.isStep5Valid;
      case PropertyCreationStep.photos:
        return formData.isStep2Valid;
      case PropertyCreationStep.price:
        return formData.isStep3Valid;
      case PropertyCreationStep.review:
        return true;
    }
  }

  bool get canGoPrevious {
    return currentStepIndex > 0;
  }

  bool get isLastStep {
    return currentStepIndex == PropertyCreationStep.values.length - 1;
  }

  RentCreateState updateStepStatus(
    int stepIndex, {
    bool? isCompleted,
    bool? isActive,
  }) {
    final updatedSteps = List<PropertyCreationStepStatus>.from(steps);
    if (stepIndex >= 0 && stepIndex < updatedSteps.length) {
      updatedSteps[stepIndex] = PropertyCreationStepStatus(
        step: updatedSteps[stepIndex].step,
        isCompleted: isCompleted ?? updatedSteps[stepIndex].isCompleted,
        isActive: isActive ?? updatedSteps[stepIndex].isActive,
      );
    }
    return copyWith(steps: updatedSteps);
  }

  RentCreateState activateStep(int stepIndex) {
    final updatedSteps = steps.map((step) {
      final index = step.step.stepNumber - 1;
      return PropertyCreationStepStatus(
        step: step.step,
        isCompleted: step.isCompleted,
        isActive: index == stepIndex,
      );
    }).toList();

    return copyWith(currentStepIndex: stepIndex, steps: updatedSteps);
  }

  @override
  List<Object?> get props => [
    status,
    formData,
    currentStepIndex,
    steps,
    errorMessage,
    successMessage,
    isLoading,
  ];
}

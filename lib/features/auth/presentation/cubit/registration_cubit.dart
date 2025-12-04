import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../data/models/register_user_request.dart';

enum RegistrationMethod { email, phone, none }

class RegistrationState {
  final int roleId; // 1 host, 2 guest
  final String name;
  final String email;
  final String address;
  final String latitude;
  final String longitude;
  final String phoneNumber;
  final String countryCode;
  final bool isSuperHost;
  final String password;
  final String confirmPassword;
  final String? profilePhotoPath;
  final XFile? profilePhotoFile; // Added for web compatibility
  final bool isLoading;
  final String? error;
  final bool success;
  final RegistrationMethod
  registrationMethod; // Track what method was used for OTP

  RegistrationState({
    this.roleId = 2, // Default to Guest (2), Host is 1
    this.name = '',
    this.email = '',
    this.address = '',
    this.latitude = '',
    this.longitude = '',
    this.phoneNumber = '',
    this.countryCode = '+963', // Default to Syria but user can change
    this.isSuperHost = true, // Default to true to match Postman
    this.password = '',
    this.confirmPassword = '',
    this.profilePhotoPath,
    this.profilePhotoFile,
    this.isLoading = false,
    this.error,
    this.success = false,
    this.registrationMethod = RegistrationMethod.none,
  });

  RegistrationState copyWith({
    int? roleId,
    String? name,
    String? email,
    String? address,
    String? latitude,
    String? longitude,
    String? phoneNumber,
    String? countryCode,
    bool? isSuperHost,
    String? password,
    String? confirmPassword,
    String? profilePhotoPath,
    XFile? profilePhotoFile,
    bool? isLoading,
    String? error,
    bool? success,
    RegistrationMethod? registrationMethod,
  }) {
    return RegistrationState(
      roleId: roleId ?? this.roleId,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      isSuperHost: isSuperHost ?? this.isSuperHost,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      profilePhotoFile: profilePhotoFile ?? this.profilePhotoFile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
      registrationMethod: registrationMethod ?? this.registrationMethod,
    );
  }
}

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegisterUserUseCase registerUserUseCase;

  RegistrationCubit(this.registerUserUseCase) : super(RegistrationState());

  void setRole(int roleId) => emit(state.copyWith(roleId: roleId));
  void setName(String value) => emit(state.copyWith(name: value));
  void setEmail(String value) => emit(state.copyWith(email: value));
  void setAddress(String value) => emit(state.copyWith(address: value));
  void setLatLng(String lat, String lng) =>
      emit(state.copyWith(latitude: lat, longitude: lng));
  void setPhone(String value) {
    emit(state.copyWith(phoneNumber: value));
  }

  void setCountryCode(String countryCode) {
    emit(state.copyWith(countryCode: countryCode));
  }

  void setSuperHost(bool value) => emit(state.copyWith(isSuperHost: value));
  void setPassword(String value) => emit(state.copyWith(password: value));
  void setConfirmPassword(String value) =>
      emit(state.copyWith(confirmPassword: value));
  void setProfilePhoto(String? path) =>
      emit(state.copyWith(profilePhotoPath: path));
  void setProfilePhotoFile(XFile? file) => emit(
    state.copyWith(profilePhotoPath: file?.path, profilePhotoFile: file),
  );
  void setRegistrationMethod(RegistrationMethod method) =>
      emit(state.copyWith(registrationMethod: method));

  void clearError() => emit(state.copyWith(error: null));

  Future<void> submit() async {
    // Basic validation
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter your name'));
      return;
    }
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter your email'));
      return;
    }
    if (state.phoneNumber.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter your phone number'));
      return;
    }
    if (state.address.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter your address'));
      return;
    }
    if (state.password.length < 6) {
      emit(state.copyWith(error: 'Password must be at least 6 characters'));
      return;
    }
    // Simplified password validation - removed complexity requirements
    // Now accepts simple passwords like "12345678"
    if (state.password != state.confirmPassword) {
      emit(state.copyWith(error: 'Passwords do not match'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    final fullPhoneNumber = '${state.countryCode}${state.phoneNumber}';
    final req = RegisterUserRequest(
      profilePhotoPath: state.profilePhotoPath,
      profilePhotoFile: state.profilePhotoFile,
      name: state.name,
      latitude: state.latitude.isEmpty ? 'string' : state.latitude,
      longitude: state.longitude.isEmpty ? 'string' : state.longitude,
      roleId: state.roleId,
      address: state.address,
      phoneNumber: fullPhoneNumber,
      isSuperHost: state.isSuperHost,
      password: state.password,
      email: state.email,
    );
    final res = await registerUserUseCase(req);
    res.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l.message)),
      (r) => emit(state.copyWith(isLoading: false, success: true)),
    );
  }
}

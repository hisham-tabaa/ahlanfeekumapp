import 'package:equatable/equatable.dart';

import '../../domain/entities/profile.dart';
import '../../domain/entities/reservation.dart';

class ProfileState extends Equatable {
  final Profile? profile;
  final bool isLoading;
  final bool isUpdating;
  final bool isChangingPassword;
  final bool isLoadingReservations;
  final String? errorMessage;
  final bool updateSuccess;
  final bool changePasswordSuccess;
  final List<Reservation> myReservations;
  final List<Reservation> userReservations;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isUpdating = false,
    this.isChangingPassword = false,
    this.isLoadingReservations = false,
    this.errorMessage,
    this.updateSuccess = false,
    this.changePasswordSuccess = false,
    this.myReservations = const [],
    this.userReservations = const [],
  });

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? isUpdating,
    bool? isChangingPassword,
    bool? isLoadingReservations,
    String? errorMessage,
    bool? updateSuccess,
    bool? changePasswordSuccess,
    List<Reservation>? myReservations,
    List<Reservation>? userReservations,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      isLoadingReservations:
          isLoadingReservations ?? this.isLoadingReservations,
      errorMessage: errorMessage,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      changePasswordSuccess:
          changePasswordSuccess ?? this.changePasswordSuccess,
      myReservations: myReservations ?? this.myReservations,
      userReservations: userReservations ?? this.userReservations,
    );
  }

  ProfileState clearMessages() {
    return copyWith(
      errorMessage: null,
      updateSuccess: false,
      changePasswordSuccess: false,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    isLoading,
    isUpdating,
    isChangingPassword,
    errorMessage,
    updateSuccess,
    changePasswordSuccess,
  ];

  factory ProfileState.initial() {
    return const ProfileState();
  }
}

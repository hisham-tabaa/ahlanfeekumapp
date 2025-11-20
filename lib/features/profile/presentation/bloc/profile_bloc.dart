import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_profile_details_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/get_my_reservations_usecase.dart';
import '../../domain/usecases/get_user_reservations_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetailsUseCase _getProfileDetailsUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final GetMyReservationsUseCase _getMyReservationsUseCase;
  final GetUserReservationsUseCase _getUserReservationsUseCase;

  ProfileBloc({
    required GetProfileDetailsUseCase getProfileDetailsUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required GetMyReservationsUseCase getMyReservationsUseCase,
    required GetUserReservationsUseCase getUserReservationsUseCase,
  }) : _getProfileDetailsUseCase = getProfileDetailsUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _getMyReservationsUseCase = getMyReservationsUseCase,
       _getUserReservationsUseCase = getUserReservationsUseCase,
       super(ProfileState.initial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
    on<LoadMyReservationsEvent>(_onLoadMyReservations);
    on<LoadUserReservationsEvent>(_onLoadUserReservations);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getProfileDetailsUseCase();
    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (profile) => emit(state.copyWith(isLoading: false, profile: profile)),
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _getProfileDetailsUseCase();
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error)),
      (profile) => emit(state.copyWith(profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isUpdating: true,
        errorMessage: null,
        updateSuccess: false,
      ),
    );

    final result = await _updateProfileUseCase(event.request);
    result.fold(
      (error) => emit(state.copyWith(isUpdating: false, errorMessage: error)),
      (_) async {
        emit(state.copyWith(isUpdating: false, updateSuccess: true));
        add(const RefreshProfileEvent());
      },
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isChangingPassword: true,
        errorMessage: null,
        changePasswordSuccess: false,
      ),
    );

    final result = await _changePasswordUseCase(event.request);
    result.fold(
      (error) =>
          emit(state.copyWith(isChangingPassword: false, errorMessage: error)),
      (_) => emit(
        state.copyWith(isChangingPassword: false, changePasswordSuccess: true),
      ),
    );
  }

  Future<void> _onLoadMyReservations(
    LoadMyReservationsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingReservations: true, errorMessage: null));

    final result = await _getMyReservationsUseCase();
    result.fold(
      (error) => emit(
        state.copyWith(isLoadingReservations: false, errorMessage: error),
      ),
      (reservations) => emit(
        state.copyWith(
          isLoadingReservations: false,
          myReservations: reservations,
        ),
      ),
    );
  }

  Future<void> _onLoadUserReservations(
    LoadUserReservationsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingReservations: true, errorMessage: null));

    final result = await _getUserReservationsUseCase(event.userId);
    result.fold(
      (error) => emit(
        state.copyWith(isLoadingReservations: false, errorMessage: error),
      ),
      (reservations) => emit(
        state.copyWith(
          isLoadingReservations: false,
          userReservations: reservations,
        ),
      ),
    );
  }
}

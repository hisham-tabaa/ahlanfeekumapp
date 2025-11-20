import '../../data/models/change_password_request.dart';
import '../../data/models/update_profile_request.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class RefreshProfileEvent extends ProfileEvent {
  const RefreshProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final UpdateProfileRequest request;

  const UpdateProfileEvent(this.request);
}

class ChangePasswordEvent extends ProfileEvent {
  final ChangePasswordRequest request;

  const ChangePasswordEvent(this.request);
}

class LoadMyReservationsEvent extends ProfileEvent {
  const LoadMyReservationsEvent();
}

class LoadUserReservationsEvent extends ProfileEvent {
  final String userId;

  const LoadUserReservationsEvent(this.userId);
}

import 'package:equatable/equatable.dart';

import '../../domain/entities/host_profile.dart';

abstract class HostProfileState extends Equatable {
  const HostProfileState();

  @override
  List<Object?> get props => [];
}

class HostProfileInitial extends HostProfileState {}

class HostProfileLoading extends HostProfileState {}

class HostProfileLoaded extends HostProfileState {
  final HostProfile hostProfile;

  const HostProfileLoaded(this.hostProfile);

  @override
  List<Object?> get props => [hostProfile];
}

class HostProfileError extends HostProfileState {
  final String message;

  const HostProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

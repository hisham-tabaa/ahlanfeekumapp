import 'package:equatable/equatable.dart';

abstract class HostProfileEvent extends Equatable {
  const HostProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadHostProfile extends HostProfileEvent {
  final String hostId;

  const LoadHostProfile(this.hostId);

  @override
  List<Object?> get props => [hostId];
}

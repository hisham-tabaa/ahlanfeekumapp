import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_host_profile_usecase.dart';
import 'host_profile_event.dart';
import 'host_profile_state.dart';

class HostProfileBloc extends Bloc<HostProfileEvent, HostProfileState> {
  final GetHostProfileUseCase _getHostProfileUseCase;

  HostProfileBloc({required GetHostProfileUseCase getHostProfileUseCase})
    : _getHostProfileUseCase = getHostProfileUseCase,
      super(HostProfileInitial()) {
    on<LoadHostProfile>(_onLoadHostProfile);
  }

  Future<void> _onLoadHostProfile(
    LoadHostProfile event,
    Emitter<HostProfileState> emit,
  ) async {
    emit(HostProfileLoading());

    final result = await _getHostProfileUseCase(event.hostId);

    result.fold(
      (error) => emit(HostProfileError(error)),
      (hostProfile) => emit(HostProfileLoaded(hostProfile)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_result.dart';
import '../../domain/repositories/help_repository.dart';
import 'help_event.dart';
import 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final HelpRepository _repository;

  HelpBloc(this._repository) : super(const HelpState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SubmitTicketEvent>(_onSubmitTicket);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<HelpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getSettings();

    result.when(
      success: (settings) {
        emit(state.copyWith(isLoading: false, settings: settings));
      },
      failure: (message) {
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
    );
  }

  Future<void> _onSubmitTicket(
    SubmitTicketEvent event,
    Emitter<HelpState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await _repository.createTicket(event.request);

    result.when(
      success: (_) {
        emit(state.copyWith(isSubmitting: false, ticketSubmitted: true));
      },
      failure: (message) {
        emit(state.copyWith(isSubmitting: false, errorMessage: message));
      },
    );
  }
}

import 'package:equatable/equatable.dart';

import '../../domain/entities/settings.dart';

class HelpState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final Settings? settings;
  final String? errorMessage;
  final bool ticketSubmitted;

  const HelpState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.settings,
    this.errorMessage,
    this.ticketSubmitted = false,
  });

  HelpState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    Settings? settings,
    String? errorMessage,
    bool? ticketSubmitted,
  }) {
    return HelpState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      settings: settings ?? this.settings,
      errorMessage: errorMessage,
      ticketSubmitted: ticketSubmitted ?? this.ticketSubmitted,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    settings,
    errorMessage,
    ticketSubmitted,
  ];
}

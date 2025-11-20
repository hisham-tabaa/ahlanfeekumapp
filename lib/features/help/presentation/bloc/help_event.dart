import 'package:equatable/equatable.dart';

import '../../data/models/create_ticket_request.dart';

abstract class HelpEvent extends Equatable {
  const HelpEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends HelpEvent {
  const LoadSettingsEvent();
}

class SubmitTicketEvent extends HelpEvent {
  final CreateTicketRequest request;

  const SubmitTicketEvent(this.request);

  @override
  List<Object?> get props => [request];
}

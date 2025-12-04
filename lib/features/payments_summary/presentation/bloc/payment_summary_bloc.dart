import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_payment_summary_usecase.dart';
import 'payment_summary_event.dart';
import 'payment_summary_state.dart';

class PaymentSummaryBloc extends Bloc<PaymentSummaryEvent, PaymentSummaryState> {
  final GetPaymentSummaryUseCase getPaymentSummaryUseCase;

  PaymentSummaryBloc({
    required this.getPaymentSummaryUseCase,
  }) : super(PaymentSummaryInitial()) {
    on<LoadPaymentSummaryEvent>(_onLoadPaymentSummary);
    on<RefreshPaymentSummaryEvent>(_onRefreshPaymentSummary);
  }

  Future<void> _onLoadPaymentSummary(
    LoadPaymentSummaryEvent event,
    Emitter<PaymentSummaryState> emit,
  ) async {
    emit(PaymentSummaryLoading());

    final result = await getPaymentSummaryUseCase(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(PaymentSummaryError(failure.message)),
      (paymentSummary) => emit(PaymentSummaryLoaded(paymentSummary)),
    );
  }

  Future<void> _onRefreshPaymentSummary(
    RefreshPaymentSummaryEvent event,
    Emitter<PaymentSummaryState> emit,
  ) async {
    // Refresh doesn't show loading state
    final result = await getPaymentSummaryUseCase(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(PaymentSummaryError(failure.message)),
      (paymentSummary) => emit(PaymentSummaryLoaded(paymentSummary)),
    );
  }
}

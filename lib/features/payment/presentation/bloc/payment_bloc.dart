import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import '../../domain/usecases/create_payment_intent_usecase.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';
import '../../domain/usecases/get_payment_status_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessPaymentUseCase processPaymentUseCase;
  final CreatePaymentIntentUseCase createPaymentIntentUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final GetPaymentStatusUseCase getPaymentStatusUseCase;

  PaymentBloc({
    required this.processPaymentUseCase,
    required this.createPaymentIntentUseCase,
    required this.confirmPaymentUseCase,
    required this.getPaymentStatusUseCase,
  }) : super(const PaymentInitial()) {
    on<ProcessPaymentEvent>(_onProcessPayment);
    on<CreatePaymentIntentEvent>(_onCreatePaymentIntent);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<GetPaymentStatusEvent>(_onGetPaymentStatus);
    on<ResetPaymentEvent>(_onResetPayment);
  }

  Future<void> _onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await processPaymentUseCase(
      amount: event.amount,
      email: event.email,
      name: event.name,
      description: event.description,
      metadata: event.metadata,
      userId: event.userId,
    );

    if (result.success) {
      emit(PaymentSuccess(result));
    } else {
      emit(PaymentFailure(result.error ?? 'Payment failed'));
    }
  }

  Future<void> _onCreatePaymentIntent(
    CreatePaymentIntentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await createPaymentIntentUseCase(
      amount: event.amount,
      currency: event.currency,
      description: event.description,
      receiptEmail: event.receiptEmail,
      metadata: event.metadata,
      userId: event.userId,
    );

    result.when(
      success: (payment) => emit(PaymentIntentCreated(payment)),
      failure: (failure) => emit(PaymentFailure(failure)),
    );
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await confirmPaymentUseCase(
      paymentIntentId: event.paymentIntentId,
      paymentMethodId: event.paymentMethodId,
    );

    result.when(
      success: (payment) => emit(PaymentConfirmed(payment)),
      failure: (failure) => emit(PaymentFailure(failure)),
    );
  }

  Future<void> _onGetPaymentStatus(
    GetPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await getPaymentStatusUseCase(event.paymentIntentId);

    result.when(
      success: (payment) => emit(PaymentStatusLoaded(payment)),
      failure: (failure) => emit(PaymentFailure(failure)),
    );
  }

  void _onResetPayment(
    ResetPaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}

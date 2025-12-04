import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/help/data/datasources/help_remote_data_source.dart';
import '../../features/help/data/repositories/help_repository_impl.dart';
import '../../features/help/domain/repositories/help_repository.dart';
import '../../features/help/presentation/bloc/help_bloc.dart';
import '../../features/property_management/data/datasources/property_management_remote_data_source.dart';
import '../../features/property_management/data/repositories/property_management_repository_impl.dart';
import '../../features/property_management/domain/repositories/property_management_repository.dart';
import '../../features/property_management/presentation/bloc/property_management_bloc.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/register_user_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_phone_usecase.dart';
import '../../features/auth/domain/usecases/request_password_reset_usecase.dart';
import '../../features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/cubit/registration_cubit.dart';
import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/rent_create/data/datasources/rent_create_remote_data_source.dart';
import '../../features/rent_create/data/repositories/rent_create_repository_impl.dart';
import '../../features/rent_create/domain/repositories/rent_create_repository.dart';
import '../../features/rent_create/domain/usecases/create_property_usecase.dart';
import '../../features/rent_create/presentation/bloc/rent_create_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_details_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/domain/usecases/change_password_usecase.dart';
import '../../features/profile/domain/usecases/get_my_reservations_usecase.dart';
import '../../features/profile/domain/usecases/get_user_reservations_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/property_detail/data/datasources/property_detail_remote_data_source.dart';
import '../../features/property_detail/data/repositories/property_detail_repository_impl.dart';
import '../../features/property_detail/domain/repositories/property_detail_repository.dart';
import '../../features/property_detail/domain/usecases/get_property_detail_usecase.dart';
import '../../features/property_detail/domain/usecases/get_host_profile_usecase.dart';
import '../../features/property_detail/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/property_detail/domain/usecases/rate_property_usecase.dart';
import '../../features/property_detail/domain/usecases/get_property_availability_usecase.dart';
import '../../features/property_detail/presentation/bloc/property_detail_bloc.dart';
import '../../features/property_detail/presentation/bloc/host_profile_bloc.dart';
import '../../features/reservations/data/datasources/reservation_remote_data_source.dart';
import '../../features/reservations/data/repositories/reservation_repository_impl.dart';
import '../../features/reservations/domain/repositories/reservation_repository.dart';
import '../../features/reservations/presentation/bloc/reservation_bloc.dart';
import '../../features/payment/data/datasources/payment_remote_data_source.dart';
import '../../features/payment/data/datasources/payment_methods_data_source.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/process_payment_usecase.dart';
import '../../features/payment/domain/usecases/create_payment_intent_usecase.dart';
import '../../features/payment/domain/usecases/confirm_payment_usecase.dart';
import '../../features/payment/domain/usecases/get_payment_status_usecase.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';
import '../services/image_loader_service.dart';
import '../../features/auth/domain/usecases/verify_phone_usecase.dart';
import '../../features/auth/domain/usecases/check_user_exists_usecase.dart';
import '../../features/payments_summary/data/datasources/payment_summary_remote_data_source.dart';
import '../../features/payments_summary/data/repositories/payment_summary_repository_impl.dart';
import '../../features/payments_summary/domain/repositories/payment_summary_repository.dart';
import '../../features/payments_summary/domain/usecases/get_payment_summary_usecase.dart';
import '../../features/payments_summary/presentation/bloc/payment_summary_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  final dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Services
  getIt.registerLazySingleton<ImageLoaderService>(
    () => ImageLoaderService(getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<RentCreateRemoteDataSource>(
    () => RentCreateRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PropertyDetailRemoteDataSource>(
    () => PropertyDetailRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<HelpRemoteDataSource>(
    () => HelpRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ReservationRemoteDataSource>(
    () => ReservationRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PropertyManagementRemoteDataSource>(
    () => PropertyManagementRemoteDataSourceImpl(
      dio: getIt(),
      sharedPreferences: getIt(),
    ),
  );

  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PaymentMethodsDataSource>(
    () => PaymentMethodsDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PaymentSummaryRemoteDataSource>(
    () => PaymentSummaryRemoteDataSourceImpl(dio: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<RentCreateRepository>(
    () => RentCreateRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<PropertyDetailRepository>(
    () => PropertyDetailRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<HelpRepository>(
    () => HelpRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<ReservationRepository>(
    () => ReservationRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<PropertyManagementRepository>(
    () => PropertyManagementRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<PaymentSummaryRepository>(
    () => PaymentSummaryRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyPhoneUseCase(getIt()));
  getIt.registerLazySingleton(() => RequestPasswordResetUseCase(getIt()));
  getIt.registerLazySingleton(() => ConfirmPasswordResetUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpPhoneUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckUserExistsUseCase(getIt()));

  // Rent Create Use Cases
  getIt.registerLazySingleton(() => CreatePropertyStepOneUseCase(getIt()));
  getIt.registerLazySingleton(() => CreatePropertyStepTwoUseCase(getIt()));
  getIt.registerLazySingleton(() => UploadImagesUseCase(getIt()));
  getIt.registerLazySingleton(() => SetPriceUseCase(getIt()));
  getIt.registerLazySingleton(() => AddAvailabilityUseCase(getIt()));

  getIt.registerLazySingleton(() => GetProfileDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMyReservationsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserReservationsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPropertyDetailUseCase(getIt()));
  getIt.registerLazySingleton(() => GetHostProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleFavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => RatePropertyUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPropertyAvailabilityUseCase(getIt()));

  getIt.registerLazySingleton(() => ProcessPaymentUseCase(getIt()));
  getIt.registerLazySingleton(() => CreatePaymentIntentUseCase(getIt()));
  getIt.registerLazySingleton(() => ConfirmPaymentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPaymentStatusUseCase(getIt()));

  getIt.registerLazySingleton(() => GetPaymentSummaryUseCase(getIt()));

  // BLoC
  // AuthBloc must be singleton to maintain authentication state across the app
  getIt.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: getIt(),
      sendOtpUseCase: getIt(),
      verifyOtpUseCase: getIt(),
      requestPasswordResetUseCase: getIt(),
      confirmPasswordResetUseCase: getIt(),
      authLocalDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => SearchBloc(searchRepository: getIt(), sharedPreferences: getIt()),
  );

  getIt.registerFactory(() => HomeBloc(homeRepository: getIt()));

  getIt.registerFactory(
    () => RentCreateBloc(
      createPropertyStepOneUseCase: getIt(),
      createPropertyStepTwoUseCase: getIt(),
      uploadImagesUseCase: getIt(),
      setPriceUseCase: getIt(),
      addAvailabilityUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => ProfileBloc(
      getProfileDetailsUseCase: getIt(),
      updateProfileUseCase: getIt(),
      changePasswordUseCase: getIt(),
      getMyReservationsUseCase: getIt(),
      getUserReservationsUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PropertyDetailBloc(
      getPropertyDetailUseCase: getIt(),
      toggleFavoriteUseCase: getIt(),
      ratePropertyUseCase: getIt(),
      getPropertyAvailabilityUseCase: getIt(),
    ),
  );

  getIt.registerFactory(() => HostProfileBloc(getHostProfileUseCase: getIt()));

  getIt.registerFactory(() => HelpBloc(getIt()));

  getIt.registerFactory(() => ReservationBloc(reservationRepository: getIt()));

  getIt.registerFactory(() => PropertyManagementBloc(repository: getIt()));

  getIt.registerFactory(
    () => PaymentBloc(
      processPaymentUseCase: getIt(),
      createPaymentIntentUseCase: getIt(),
      confirmPaymentUseCase: getIt(),
      getPaymentStatusUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PaymentSummaryBloc(
      getPaymentSummaryUseCase: getIt(),
    ),
  );

  // Cubits
  getIt.registerFactory(() => RegistrationCubit(getIt()));
}

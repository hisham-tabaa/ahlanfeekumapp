class AppConstants {
  static const String baseUrl =
      'https://admin.srv954186.hstgr.cloud/api/mobile/';

  // Authentication Endpoints
  static const String loginEndpoint = 'auth/abp-login-url';
  static const String firebaseAuthEndpoint = 'auth/firebase-auth';

  static const String sendOtpEmailEndpoint =
      'user-profiles/send-secret-key-email';
  static const String sendOtpPhoneEndpoint =
      'user-profiles/send-secret-key-phone';
  static const String verifyOtpEndpoint = 'user-profiles/verify';
  static const String verifyPhoneEndpoint = 'user-profiles/verify-phone';
  static const String passwordResetRequestEndpoint =
      'user-profiles/password-reset-request';
  static const String confirmPasswordResetEndpoint =
      'user-profiles/confirm-password-reset';
  static const String registerUserEndpoint = 'user-profiles/register-user';

  // User Profile Endpoints
  static const String homeEndpoint = 'user-profiles/home';
  static const String userProfileDetailsEndpoint =
      'user-profiles/user-profile-details';
  static const String updateMyProfileEndpoint =
      'user-profiles/update-my-profile';
  static const String passwordChangeEndpoint = 'user-profiles/password-change';

  // Lookup Endpoints
  static const String propertyTypesEndpoint = 'lookups/property-types';
  static const String propertyFeaturesEndpoint = 'lookups/property-features';
  static const String governatesEndpoint = 'lookups/governates';
  static const String statusesEndpoint = 'lookups/statuses';

  // Property Endpoints
  static const String searchPropertyEndpoint = 'properties/search-property';
  static const String propertyWithDetailsEndpoint =
      'properties/with-details'; // + /{id}
  static const String addToFavoriteEndpoint =
      'properties/add-to-favorite'; // + /{propertyId}
  static const String removeFromFavoriteEndpoint =
      'properties/remove-from-favorite'; // + /{propertyId}

  // Property Creation Endpoints
  static const String createPropertyStepOne = 'properties/create-step-one';
  static const String createPropertyStepTwo = 'properties/create-step-two';
  static const String addAvailability = 'properties/add-availability';
  static const String propertyCalendar =
      'properties/property-calendar'; // GET availability
  static const String uploadSingleMedia = 'properties/upload-one-media';
  static const String uploadMultipleMedia = 'properties/upload-medias';
  static const String setPrice = 'properties/set-price';

  // Property Rating Endpoint
  static const String propertyRatingEndpoint = 'properties/property-rating';

  // Reservation Endpoints
  static const String myReservationsEndpoint = 'reservations/my-reservations';
  static const String upcomingReservationsEndpoint =
      'reservations/my-upcoming-reservations';
  static const String userReservationsEndpoint =
      'reservations/user-reservations'; // + /{userId}
  static const String createReservationEndpoint =
      'reservations/create-reservation';

  // Payment Endpoints
  static const String createPaymentIntentEndpoint =
      'payments/create-intent';
  static const String confirmPaymentEndpoint = 'payments/confirm';
  static const String getPaymentStatusEndpoint =
      'payments'; // + /{paymentIntentId}
  static const String paymentWebhookEndpoint = 'payments/webhook';

  // Host Profile Endpoint
  static const String userProfileDetailsById =
      'user-profiles/user-profile-details'; // + /{id}

  // Help & Settings Endpoints
  static const String settingsGetEndpoint = 'settings/get';
  static const String createTicketEndpoint = 'user-profiles/create-ticket';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String isGuestKey = 'is_guest';
  static const String languageKey = 'language';

  // Validation
  static const int minPasswordLength = 6;
  static const int otpLength = 4;
  static const int otpResendTimeInSeconds = 60;

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'ar'];
  static const String defaultLanguage = 'en';

  // Google Sign In
  static const String googleClientId =
      'YOUR_GOOGLE_CLIENT_ID'; // Replace with actual client ID

  // Stripe
  static const String stripePublishableKey =
      'pk_test_51ST2HiPBrnuRjM3IphemP3SvLHg6xVLVIHSM1p16Q0vKODf4ZQFhcm3shcbLWQZ240cUgdmZvvWVaSuIdHXrtyAa004hn0q3BD';
}

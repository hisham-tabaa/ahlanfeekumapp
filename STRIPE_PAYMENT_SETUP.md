# Stripe Payment Integration Setup Guide

This guide explains how to complete the Stripe payment integration in your AhlanFeekum app.

## Overview

The Stripe payment gateway has been integrated into the reservation/booking flow. When a user books a property, they will be redirected to a payment screen where they can enter their card details and complete the payment before the reservation is confirmed.

## Payment Flow

1. **User selects booking dates and clicks "Book Now"**
2. **Payment screen is shown** with:
   - Total amount calculation (price per night × number of nights)
   - Stripe card input form
   - Secure payment processing
3. **Payment is processed** through the backend API
4. **On success**: Reservation is created and user sees confirmation
5. **On failure**: User is notified and can retry

## Setup Steps

### 1. Install Dependencies

Run the following command to install the new dependencies:

```bash
flutter pub get
```

### 2. Generate JSON Serialization Files

The payment models use `json_serializable`. Generate the required files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Update Stripe Publishable Key

In `lib/core/constants/app_constants.dart`, replace the placeholder with your actual Stripe publishable key:

```dart
static const String stripePublishableKey = 'pk_test_YOUR_ACTUAL_KEY_HERE';
```

Get your publishable key from: https://dashboard.stripe.com/test/apikeys

### 4. Backend API Requirements

Ensure your backend implements the following endpoints:

#### Create Payment Intent
- **POST** `/api/mobile/payments/create-intent`
- **Request Body**:
  ```json
  {
    "amount": 1099,
    "currency": "usd",
    "description": "Property booking payment",
    "receiptEmail": "customer@example.com",
    "metadata": {
      "propertyId": "123",
      "checkIn": "2024-01-15",
      "checkOut": "2024-01-20"
    }
  }
  ```
- **Response**:
  ```json
  {
    "id": "pi_xxxxx",
    "clientSecret": "pi_xxxxx_secret_xxxxx",
    "status": "requires_payment_method",
    "amount": 1099,
    "currency": "usd"
  }
  ```

#### Confirm Payment
- **POST** `/api/mobile/payments/confirm`
- **Request Body**:
  ```json
  {
    "paymentIntentId": "pi_xxxxx",
    "paymentMethodId": "pm_xxxxx"
  }
  ```
- **Response**:
  ```json
  {
    "id": "pi_xxxxx",
    "status": "succeeded",
    "amount": 1099,
    "amountReceived": 1099,
    "currency": "usd"
  }
  ```

#### Get Payment Status
- **GET** `/api/mobile/payments/{paymentIntentId}`
- **Response**: Same as confirm payment response

### 5. Test the Integration

#### Test Cards for Development

Use these Stripe test cards:

- **Success**: `4242 4242 4242 4242`
- **Requires Authentication**: `4000 0025 0000 3155`
- **Declined**: `4000 0000 0000 9995`

Use any future expiry date, any 3-digit CVC, and any postal code.

#### Testing Steps

1. Run the app: `flutter run`
2. Navigate to a property detail page
3. Select check-in and check-out dates
4. Click "Book Now"
5. Enter test card details on payment screen
6. Click "Pay Now"
7. Verify:
   - Payment succeeds
   - Reservation is created
   - Success message is shown

## Project Structure

The payment feature follows Clean Architecture:

```
lib/features/payment/
├── data/
│   ├── datasources/
│   │   └── payment_remote_data_source.dart
│   ├── models/
│   │   ├── payment_intent_request.dart
│   │   ├── payment_intent_response.dart
│   │   ├── confirm_payment_request.dart
│   │   └── payment_result.dart
│   └── repositories/
│       └── payment_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── payment_entity.dart
│   ├── repositories/
│   │   └── payment_repository.dart
│   └── usecases/
│       ├── process_payment_usecase.dart
│       ├── create_payment_intent_usecase.dart
│       ├── confirm_payment_usecase.dart
│       └── get_payment_status_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── payment_bloc.dart
    │   ├── payment_event.dart
    │   └── payment_state.dart
    └── pages/
        └── payment_screen.dart
```

## Important Notes

1. **Amount Format**: Amounts are in cents (e.g., $10.99 = 1099)
2. **Currency**: Currently set to USD, modify in code if needed
3. **Security**: Never commit your Stripe secret key to the repository
4. **Production**: Replace test keys with live keys before production release
5. **Error Handling**: All errors are caught and displayed to users
6. **Web Support**: Stripe Flutter SDK has limited web support; test thoroughly on mobile

## Customization

### Change Currency

In `lib/features/payment/data/models/payment_intent_request.dart`:
```dart
this.currency = 'eur',  // Change to your preferred currency
```

### Modify Payment Screen UI

Edit `lib/features/payment/presentation/pages/payment_screen.dart` to customize the payment screen appearance.

### Add Additional Metadata

In `lib/features/property_detail/presentation/pages/property_detail_screen.dart`, add more fields to the metadata map:
```dart
metadata: {<!-- Add custom fields here -->
  'propertyId': property.id,
  'checkIn': checkIn.toIso8601String().split('T')[0],
  'checkOut': checkOut.toIso8601String().split('T')[0],
  'guests': guests.toString(),
  'yourCustomField': 'value',
},
```

## Troubleshooting

### Issue: "Stripe publishable key is not set"
**Solution**: Update `stripePublishableKey` in `app_constants.dart`

### Issue: Payment fails with network error
**Solution**: Check that your backend endpoints are correctly implemented and accessible

### Issue: Build errors after adding dependencies
**Solution**: Run `flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: Payment screen shows blank card form
**Solution**: Ensure Stripe is initialized in `main.dart` before the app starts

## Support

For Stripe-specific issues, refer to:
- Flutter Stripe Documentation: https://pub.dev/packages/flutter_stripe
- Stripe API Documentation: https://stripe.com/docs/api
- Stripe Dashboard: https://dashboard.stripe.com

## Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Run `build_runner` to generate files
3. ✅ Update Stripe publishable key
4. ✅ Test with Stripe test cards
5. ✅ Verify backend endpoints are working
6. ✅ Test complete booking flow
7. ✅ Deploy to production with live keys
